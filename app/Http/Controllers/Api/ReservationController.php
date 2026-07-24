<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Annonce;
use App\Models\Disponibilite;
use App\Models\Reservation;
use App\Models\UserNotification;
use Illuminate\Http\Request;

class ReservationController extends Controller
{
    private function peutReserver($user)
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

        if (!$this->peutReserver($user)) {
            return response()->json([
                'message' => 'Seuls les membres peuvent réserver un service.'
            ], 403);
        }

        if ($user->statut !== 'actif') {
            return response()->json([
                'message' => 'Votre compte n’est pas actif.'
            ], 403);
        }

        $validated = $request->validate([
            'annonce_id' => 'required|exists:annonces,id',
            'disponibilite_id' => 'required|exists:disponibilites,id',
            'message_demande' => 'nullable|string|max:1000',
        ]);

        $annonce = Annonce::where('statut', 'publiee')
            ->find($validated['annonce_id']);

        if (!$annonce) {
            return response()->json([
                'message' => 'Annonce introuvable ou non disponible.'
            ], 404);
        }

        if ((int) $annonce->prestataire_id === (int) $user->id) {
            return response()->json([
                'message' => 'Vous ne pouvez pas réserver votre propre annonce.'
            ], 422);
        }

        $disponibilite = Disponibilite::where('id', $validated['disponibilite_id'])
            ->where('annonce_id', $annonce->id)
            ->where('disponible', true)
            ->first();

        if (!$disponibilite) {
            return response()->json([
                'message' => 'Cette disponibilité n’est plus disponible.'
            ], 422);
        }

        $reservation = Reservation::create([
            'membre_id' => $user->id,
            'annonce_id' => $annonce->id,
            'prestataire_id' => $annonce->prestataire_id,
            'disponibilite_id' => $disponibilite->id,
            'date_demande' => now(),
            'date_service' => $disponibilite->date_debut,
            'message_demande' => $validated['message_demande'] ?? null,
            'statut' => 'en_attente',
        ]);

        UserNotification::create([
            'user_id' => $annonce->prestataire_id,
            'type' => 'reservation_recue',
            'titre' => 'Nouvelle réservation',
            'message' => $user->prenom . ' ' . $user->nom . ' a envoyé une demande de réservation.',
            'lien' => '/prestataire/reservations',
            'related_type' => 'reservation',
            'related_id' => $reservation->id,
            'lu' => false,
        ]);

        $disponibilite->disponible = false;
        $disponibilite->save();

        return response()->json([
            'message' => 'Demande de réservation créée avec succès.',
            'data' => $reservation
        ], 201);
    }

    public function mesReservations(Request $request)
    {
        $user = $request->user();

        if (!$this->peutReserver($user)) {
            return response()->json([
                'message' => 'Seuls les membres peuvent consulter leurs réservations.'
            ], 403);
        }

        $reservations = Reservation::with([
            'annonce:id,titre,localisation,tarif',
            'prestataire:id,nom,prenom,localisation',
            'disponibilite:id,date_debut,date_fin,disponible',
            'paiement:id,reservation_id,montant,devise,methode,statut,transaction_externe_id',
            'avis:id,reservation_id,note,commentaire,visible,created_at'
        ])
            ->where('membre_id', $user->id)
            ->latest()
            ->get();

        return response()->json([
            'data' => $reservations
        ]);
    }

    public function show(Request $request, $id)
    {
        $user = $request->user();

        $reservation = Reservation::with([
            'membre:id,nom,prenom,email',
            'prestataire:id,nom,prenom,localisation',
            'annonce:id,titre,description,tarif,localisation',
            'disponibilite:id,date_debut,date_fin,disponible',
            'paiement'
        ])->find($id);

        if (!$reservation) {
            return response()->json([
                'message' => 'Réservation introuvable.'
            ], 404);
        }

        if (
            (int) $reservation->membre_id !== (int) $user->id &&
            (int) $reservation->prestataire_id !== (int) $user->id &&
            $user->role !== 'administrateur'
        ) {
            return response()->json([
                'message' => 'Accès interdit à cette réservation.'
            ], 403);
        }

        return response()->json([
            'data' => $reservation
        ]);
    }

    public function reservationsRecues(Request $request)
    {
        $user = $request->user();

        if (!$this->estPrestataire($user)) {
            return response()->json([
                'message' => 'Seuls les prestataires peuvent consulter les réservations reçues.'
            ], 403);
        }

        $reservations = Reservation::with([
            'membre:id,nom,prenom',
            'annonce:id,titre,localisation,tarif',
            'disponibilite:id,date_debut,date_fin,disponible'
        ])
            ->where('prestataire_id', $user->id)
            ->latest()
            ->get();

        return response()->json([
            'data' => $reservations
        ]);
    }

    public function modifierStatutPrestataire(Request $request, $id)
    {
        $user = $request->user();

        if (!$this->estPrestataire($user)) {
            return response()->json([
                'message' => 'Seuls les prestataires peuvent répondre aux réservations.'
            ], 403);
        }

        if ($user->statut !== 'actif') {
            return response()->json([
                'message' => 'Votre compte n’est pas actif.'
            ], 403);
        }

        $validated = $request->validate([
            'statut' => 'required|in:acceptee,refusee,alternative_proposee,terminee',
            'date_alternative_debut' => 'required_if:statut,alternative_proposee|nullable|date|after:now',
            'date_alternative_fin' => 'required_if:statut,alternative_proposee|nullable|date|after:date_alternative_debut',
            'message_alternative' => 'nullable|string|max:1000',
        ]);

        $reservation = Reservation::with('paiement')
            ->where('id', $id)
            ->where('prestataire_id', $user->id)
            ->first();

        if (!$reservation) {
            return response()->json([
                'message' => 'Réservation introuvable ou accès interdit.'
            ], 404);
        }

        $nouveauStatut = $validated['statut'];

        if (in_array($nouveauStatut, ['acceptee', 'refusee', 'alternative_proposee'])) {
            if ($reservation->statut !== 'en_attente') {
                return response()->json([
                    'message' => 'Cette réservation ne peut plus être acceptée, refusée ou modifiée.'
                ], 422);
            }
        }

        if ($nouveauStatut === 'terminee') {
            if ($reservation->statut !== 'acceptee') {
                return response()->json([
                    'message' => 'Seule une réservation acceptée peut être marquée comme terminée.'
                ], 422);
            }

            if (!$reservation->paiement || $reservation->paiement->statut !== 'accepte') {
                return response()->json([
                    'message' => 'La réservation peut être marquée comme terminée uniquement après confirmation du paiement.'
                ], 422);
            }
        }

        $updateData = [
            'statut' => $nouveauStatut,
        ];

        if ($nouveauStatut === 'alternative_proposee') {
            $updateData['date_alternative_debut'] = $validated['date_alternative_debut'];
            $updateData['date_alternative_fin'] = $validated['date_alternative_fin'];
            $updateData['message_alternative'] = $validated['message_alternative'] ?? null;
        }

        $reservation->update($updateData);

        $notificationData = [
            'acceptee' => [
                'type' => 'reservation_acceptee',
                'titre' => 'Réservation acceptée',
                'message' => 'Votre demande de réservation a été acceptée.',
            ],
            'refusee' => [
                'type' => 'reservation_refusee',
                'titre' => 'Réservation refusée',
                'message' => 'Votre demande de réservation a été refusée.',
            ],
            'alternative_proposee' => [
                'type' => 'reservation_alternative',
                'titre' => 'Nouveau créneau proposé',
                'message' => 'Le prestataire ne peut pas assurer le créneau initial et vous propose un nouveau créneau.',
            ],
            'terminee' => [
                'type' => 'reservation_terminee',
                'titre' => 'Réservation terminée',
                'message' => 'Votre réservation a été marquée comme terminée.',
            ],
        ];

        if (isset($notificationData[$nouveauStatut])) {
            $data = $notificationData[$nouveauStatut];

            UserNotification::create([
                'user_id' => $reservation->membre_id,
                'type' => $data['type'],
                'titre' => $data['titre'],
                'message' => $data['message'],
                'lien' => '/mes-reservations',
                'related_type' => 'reservation',
                'related_id' => $reservation->id,
                'lu' => false,
            ]);
        }


        if (in_array($nouveauStatut, ['refusee', 'alternative_proposee']) && $reservation->disponibilite_id) {
            $disponibilite = Disponibilite::find($reservation->disponibilite_id);

            if ($disponibilite) {
                $disponibilite->disponible = true;
                $disponibilite->save();
            }
        }

        return response()->json([
            'message' => 'Statut de la réservation mis à jour.',
            'data' => $reservation
        ]);
    }

    public function accepterAlternative(Request $request, $id)
    {
        $user = $request->user();

        if (!$this->peutReserver($user)) {
            return response()->json([
                'message' => 'Seuls les membres peuvent accepter une alternative.'
            ], 403);
        }

        if ($user->statut !== 'actif') {
            return response()->json([
                'message' => 'Votre compte n’est pas actif.'
            ], 403);
        }

        $reservation = Reservation::where('id', $id)
            ->where('membre_id', $user->id)
            ->first();

        if (!$reservation) {
            return response()->json([
                'message' => 'Réservation introuvable ou accès interdit.'
            ], 404);
        }

        if ($reservation->statut !== 'alternative_proposee') {
            return response()->json([
                'message' => 'Cette réservation ne contient pas d’alternative à accepter.'
            ], 422);
        }

        if (!$reservation->date_alternative_debut || !$reservation->date_alternative_fin) {
            return response()->json([
                'message' => 'Le créneau alternatif est incomplet.'
            ], 422);
        }

        $disponibilite = Disponibilite::create([
            'annonce_id' => $reservation->annonce_id,
            'date_debut' => $reservation->date_alternative_debut,
            'date_fin' => $reservation->date_alternative_fin,
            'disponible' => false,
        ]);

        $reservation->update([
            'statut' => 'acceptee',
            'date_service' => $reservation->date_alternative_debut,
            'disponibilite_id' => $disponibilite->id,
        ]);

        UserNotification::create([
            'user_id' => $reservation->prestataire_id,
            'type' => 'reservation_alternative_acceptee',
            'titre' => 'Alternative acceptée',
            'message' => $user->prenom . ' ' . $user->nom . ' a accepté le nouveau créneau proposé.',
            'lien' => '/prestataire/reservations',
            'related_type' => 'reservation',
            'related_id' => $reservation->id,
            'lu' => false,
        ]);

        $reservation->load([
            'annonce:id,titre,localisation,tarif',
            'prestataire:id,nom,prenom,localisation',
            'disponibilite:id,date_debut,date_fin,disponible',
            'paiement:id,reservation_id,montant,devise,methode,statut,transaction_externe_id',
            'avis:id,reservation_id,note,commentaire,visible,created_at'
        ]);

        return response()->json([
            'message' => 'Alternative acceptée. Vous pouvez maintenant procéder au paiement.',
            'data' => $reservation
        ]);
    }
}
