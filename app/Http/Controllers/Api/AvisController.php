<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Avis;
use App\Models\Reservation;
use Illuminate\Http\Request;

class AvisController extends Controller
{
    private function peutLaisserAvis($user)
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

        if (!$this->peutLaisserAvis($user)) {
            return response()->json([
                'message' => 'Seuls les membres peuvent laisser un avis.'
            ], 403);
        }

        if ($user->statut !== 'actif') {
            return response()->json([
                'message' => 'Votre compte n’est pas actif.'
            ], 403);
        }

        $validated = $request->validate([
            'reservation_id' => 'required|exists:reservations,id',
            'note' => 'required|integer|min:1|max:5',
            'commentaire' => 'nullable|string|max:1500',
        ]);

        $reservation = Reservation::with('annonce')
            ->find($validated['reservation_id']);

        if (!$reservation) {
            return response()->json([
                'message' => 'Réservation introuvable.'
            ], 404);
        }

        if ((int) $reservation->membre_id !== (int) $user->id) {
            return response()->json([
                'message' => 'Vous ne pouvez laisser un avis que sur vos propres réservations.'
            ], 403);
        }

        if (!in_array($reservation->statut, ['acceptee', 'terminee'])) {
            return response()->json([
                'message' => 'Un avis ne peut être laissé que pour une réservation acceptée ou terminée.'
            ], 422);
        }

        $avisExisteDeja = Avis::where('membre_id', $user->id)
            ->where('reservation_id', $reservation->id)
            ->exists();

        if ($avisExisteDeja) {
            return response()->json([
                'message' => 'Vous avez déjà laissé un avis pour cette réservation.'
            ], 422);
        }

        $avis = Avis::create([
            'membre_id' => $user->id,
            'prestataire_id' => $reservation->prestataire_id,
            'annonce_id' => $reservation->annonce_id,
            'reservation_id' => $reservation->id,
            'note' => $validated['note'],
            'commentaire' => $validated['commentaire'] ?? null,
            'visible' => true,
        ]);

        $avis->load([
            'membre:id,nom,prenom',
            'prestataire:id,nom,prenom,localisation',
            'annonce:id,titre,localisation',
            'reservation:id,statut'
        ]);

        return response()->json([
            'message' => 'Avis ajouté avec succès.',
            'data' => $avis
        ], 201);
    }

    public function avisRecus(Request $request)
    {
        $user = $request->user();

        if (!$this->estPrestataire($user)) {
            return response()->json([
                'message' => 'Seuls les prestataires peuvent consulter les avis reçus.'
            ], 403);
        }

        $avis = Avis::with([
            'membre:id,nom,prenom',
            'annonce:id,titre,localisation',
            'reservation:id,statut,date_service'
        ])
            ->where('prestataire_id', $user->id)
            ->where('visible', true)
            ->latest()
            ->get();

        return response()->json([
            'data' => $avis
        ]);
    }
}
