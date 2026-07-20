<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Paiement;
use App\Models\Reservation;
use Illuminate\Http\Request;
use Illuminate\Support\Str;
use Stripe\StripeClient;
use Stripe\Webhook;

class PaiementController extends Controller
{
    private function peutPayer($user)
    {
        return in_array($user->role, ['membre', 'prestataire']);
    }

    private function estPrestataire($user)
    {
        return $user->role === 'prestataire';
    }

    public function store(Request $request)
    {
        $user = $request->user();

        if (!$this->peutPayer($user)) {
            return response()->json([
                'message' => 'Seuls les membres peuvent effectuer un paiement.'
            ], 403);
        }

        if ($user->statut !== 'actif') {
            return response()->json([
                'message' => 'Votre compte n’est pas actif.'
            ], 403);
        }

        $validated = $request->validate([
            'reservation_id' => 'required|exists:reservations,id',
            'methode' => 'required|in:stripe',
        ]);

        $reservation = Reservation::with([
            'annonce:id,titre,tarif,localisation',
            'prestataire:id,nom,prenom'
        ])
            ->where('id', $validated['reservation_id'])
            ->where('membre_id', $user->id)
            ->first();

        if (!$reservation) {
            return response()->json([
                'message' => 'Réservation introuvable ou accès interdit.'
            ], 404);
        }

        if ($reservation->statut !== 'acceptee') {
            return response()->json([
                'message' => 'Le paiement est possible uniquement pour une réservation acceptée.'
            ], 422);
        }

        if (!$reservation->annonce || $reservation->annonce->tarif === null) {
            return response()->json([
                'message' => 'Le tarif de l’annonce est indisponible.'
            ], 422);
        }

        if ((int) $reservation->prestataire_id === (int) $user->id) {
            return response()->json([
                'message' => 'Vous ne pouvez pas payer votre propre prestation.'
            ], 422);
        }

        $stripeSecret = config('services.stripe.secret');

        if (!$stripeSecret) {
            return response()->json([
                'message' => 'La configuration Stripe est manquante.'
            ], 500);
        }

        $paiement = Paiement::where('reservation_id', $reservation->id)->first();

        if ($paiement && $paiement->statut === 'accepte') {
            return response()->json([
                'message' => 'Cette réservation a déjà été payée.'
            ], 422);
        }

        if (!$paiement) {
            $paiement = Paiement::create([
                'reservation_id' => $reservation->id,
                'membre_id' => $user->id,
                'montant' => $reservation->annonce->tarif,
                'devise' => 'EUR',
                'methode' => 'stripe',
                'statut' => 'en_attente',
                'transaction_externe_id' => 'PENDING-' . strtoupper(Str::random(12)),
            ]);
        } else {
            $paiement->update([
                'montant' => $reservation->annonce->tarif,
                'devise' => 'EUR',
                'methode' => 'stripe',
                'statut' => 'en_attente',
            ]);
        }

        $stripe = new StripeClient($stripeSecret);

        $montantCentimes = (int) round($reservation->annonce->tarif * 100);

        $session = $stripe->checkout->sessions->create([
            'mode' => 'payment',
            'payment_method_types' => ['card'],
            'customer_email' => $user->email,

            'line_items' => [
                [
                    'price_data' => [
                        'currency' => 'eur',
                        'product_data' => [
                            'name' => $reservation->annonce->titre,
                            'description' => 'Réservation ServiceConnect n°' . $reservation->id,
                        ],
                        'unit_amount' => $montantCentimes,
                    ],
                    'quantity' => 1,
                ],
            ],

            'metadata' => [
                'paiement_id' => $paiement->id,
                'reservation_id' => $reservation->id,
                'membre_id' => $user->id,
            ],

            'success_url' => config('services.stripe.frontend_url') . '/mes-paiements?paiement=success&session_id={CHECKOUT_SESSION_ID}',
            'cancel_url' => config('services.stripe.frontend_url') . '/mes-reservations?paiement=cancel',
        ]);

        $paiement->update([
            'transaction_externe_id' => $session->id,
        ]);

        $paiement->load([
            'reservation:id,annonce_id,membre_id,prestataire_id,statut,date_service',
            'reservation.annonce:id,titre,tarif,localisation',
            'membre:id,nom,prenom,email'
        ]);

        return response()->json([
            'message' => 'Session Stripe créée avec succès.',
            'checkout_url' => $session->url,
            'data' => $paiement
        ], 201);
    }

    public function mesPaiements(Request $request)
    {
        $user = $request->user();

        if (!$this->peutPayer($user)) {
            return response()->json([
                'message' => 'Seuls les membres peuvent consulter leurs paiements.'
            ], 403);
        }

        $paiements = Paiement::with([
            'reservation:id,annonce_id,statut,date_service',
            'reservation.annonce:id,titre,tarif,localisation'
        ])
            ->where('membre_id', $user->id)
            ->latest()
            ->get();

        return response()->json([
            'data' => $paiements
        ]);
    }

    public function show(Request $request, $id)
    {
        $user = $request->user();

        $paiement = Paiement::with([
            'reservation:id,annonce_id,membre_id,prestataire_id,statut,date_service',
            'reservation.annonce:id,titre,tarif,localisation',
            'membre:id,nom,prenom,email'
        ])->find($id);

        if (!$paiement) {
            return response()->json([
                'message' => 'Paiement introuvable.'
            ], 404);
        }

        if (
            (int) $paiement->membre_id !== (int) $user->id &&
            (int) $paiement->reservation->prestataire_id !== (int) $user->id &&
            $user->role !== 'administrateur'
        ) {
            return response()->json([
                'message' => 'Accès interdit à ce paiement.'
            ], 403);
        }

        return response()->json([
            'data' => $paiement
        ]);
    }

    public function paiementsPrestataire(Request $request)
    {
        $user = $request->user();

        if (!$this->estPrestataire($user)) {
            return response()->json([
                'message' => 'Seuls les prestataires peuvent consulter les paiements reçus.'
            ], 403);
        }

        $paiements = Paiement::with([
            'membre:id,nom,prenom',
            'reservation:id,annonce_id,membre_id,prestataire_id,statut,date_service',
            'reservation.annonce:id,titre,tarif,localisation'
        ])
            ->whereHas('reservation', function ($query) use ($user) {
                $query->where('prestataire_id', $user->id);
            })
            ->latest()
            ->get();

        return response()->json([
            'data' => $paiements
        ]);
    }

    public function stripeWebhook(Request $request)
    {
        $payload = $request->getContent();
        $signature = $request->header('Stripe-Signature');
        $webhookSecret = config('services.stripe.webhook_secret');

        if (!$webhookSecret) {
            return response()->json([
                'message' => 'Webhook Stripe non configuré.'
            ], 500);
        }

        try {
            $event = Webhook::constructEvent(
                $payload,
                $signature,
                $webhookSecret
            );
        } catch (\UnexpectedValueException $e) {
            return response()->json([
                'message' => 'Payload Stripe invalide.'
            ], 400);
        } catch (\Stripe\Exception\SignatureVerificationException $e) {
            return response()->json([
                'message' => 'Signature Stripe invalide.'
            ], 400);
        }

        if ($event->type === 'checkout.session.completed') {
            $session = $event->data->object;

            $paiementId = $session->metadata->paiement_id ?? null;

            if ($paiementId) {
                $paiement = Paiement::find($paiementId);

                if ($paiement) {
                    $paiement->update([
                        'statut' => 'accepte',
                        'transaction_externe_id' => $session->payment_intent ?? $session->id,
                    ]);
                }
            }
        }

        if ($event->type === 'checkout.session.expired') {
            $session = $event->data->object;

            $paiementId = $session->metadata->paiement_id ?? null;

            if ($paiementId) {
                $paiement = Paiement::find($paiementId);

                if ($paiement && $paiement->statut === 'en_attente') {
                    $paiement->update([
                        'statut' => 'refuse',
                    ]);
                }
            }
        }

        return response()->json([
            'received' => true
        ]);
    }
}
