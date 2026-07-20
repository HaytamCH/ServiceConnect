<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Annonce;
use App\Models\Disponibilite;
use Illuminate\Http\Request;

class DisponibiliteController extends Controller
{
    public function store(Request $request)
    {
        $user = $request->user();

        if ($user->role !== 'prestataire') {
            return response()->json([
                'message' => 'Seuls les prestataires peuvent ajouter des disponibilités.'
            ], 403);
        }

        if ($user->statut !== 'actif') {
            return response()->json([
                'message' => 'Votre compte n’est pas actif.'
            ], 403);
        }

        $validated = $request->validate([
            'annonce_id' => 'required|exists:annonces,id',
            'date_debut' => 'required|date|after:now',
            'date_fin' => 'required|date|after:date_debut',
        ]);

        $annonce = Annonce::where('id', $validated['annonce_id'])
            ->where('prestataire_id', $user->id)
            ->first();

        if (!$annonce) {
            return response()->json([
                'message' => 'Annonce introuvable ou accès interdit.'
            ], 404);
        }

        if ($annonce->statut === 'supprimee') {
            return response()->json([
                'message' => 'Impossible d’ajouter une disponibilité à une annonce supprimée.'
            ], 422);
        }

        $disponibilite = Disponibilite::create([
            'annonce_id' => $annonce->id,
            'date_debut' => $validated['date_debut'],
            'date_fin' => $validated['date_fin'],
            'disponible' => true,
        ]);

        return response()->json([
            'message' => 'Disponibilité ajoutée avec succès.',
            'data' => $disponibilite
        ], 201);
    }

    public function index(Request $request)
    {
        $user = $request->user();

        if ($user->role !== 'prestataire') {
            return response()->json([
                'message' => 'Seuls les prestataires peuvent consulter leurs disponibilités.'
            ], 403);
        }

        $disponibilites = Disponibilite::with([
            'annonce:id,titre,prestataire_id,statut'
        ])
            ->whereHas('annonce', function ($query) use ($user) {
                $query->where('prestataire_id', $user->id);
            })
            ->orderBy('date_debut', 'desc')
            ->get();

        return response()->json([
            'data' => $disponibilites
        ]);
    }

    public function destroy(Request $request, $id)
    {
        $user = $request->user();

        if ($user->role !== 'prestataire') {
            return response()->json([
                'message' => 'Seuls les prestataires peuvent supprimer une disponibilité.'
            ], 403);
        }

        $disponibilite = Disponibilite::where('id', $id)
            ->whereHas('annonce', function ($query) use ($user) {
                $query->where('prestataire_id', $user->id);
            })
            ->first();

        if (!$disponibilite) {
            return response()->json([
                'message' => 'Disponibilité introuvable ou accès interdit.'
            ], 404);
        }

        if ($disponibilite->reservations()->exists()) {
            $disponibilite->update([
                'disponible' => false,
            ]);

            return response()->json([
                'message' => 'Cette disponibilité est liée à une réservation. Elle a donc été désactivée.'
            ]);
        }

        $disponibilite->delete();

        return response()->json([
            'message' => 'Disponibilité supprimée avec succès.'
        ]);
    }




}
