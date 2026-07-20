<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Annonce;
use App\Models\Like;
use App\Models\User;
use Illuminate\Http\Request;

class LikeController extends Controller
{
    private function peutUtiliserFavoris($user)
    {
        return in_array($user->role, ['membre', 'prestataire']);
    }

    public function store(Request $request)
    {
        $user = $request->user();

        if (!$this->peutUtiliserFavoris($user)) {
            return response()->json([
                'message' => 'Seuls les membres peuvent ajouter un favori.'
            ], 403);
        }

        if ($user->statut !== 'actif') {
            return response()->json([
                'message' => 'Votre compte n’est pas actif.'
            ], 403);
        }

        $validated = $request->validate([
            'type_cible' => 'required|in:annonce,prestataire',
            'annonce_id' => 'nullable|exists:annonces,id',
            'prestataire_id' => 'nullable|exists:users,id',
        ]);

        if ($validated['type_cible'] === 'annonce') {
            if (empty($validated['annonce_id'])) {
                return response()->json([
                    'message' => 'L’annonce est obligatoire pour ce type de favori.'
                ], 422);
            }

            $annonce = Annonce::where('id', $validated['annonce_id'])
                ->where('statut', 'publiee')
                ->first();

            if (!$annonce) {
                return response()->json([
                    'message' => 'Annonce introuvable ou non publiée.'
                ], 404);
            }

            $like = Like::firstOrCreate([
                'membre_id' => $user->id,
                'annonce_id' => $annonce->id,
            ], [
                'prestataire_id' => null,
                'type_cible' => 'annonce',
            ]);

            return response()->json([
                'message' => 'Annonce ajoutée aux favoris.',
                'data' => $like
            ], 201);
        }

        if ($validated['type_cible'] === 'prestataire') {
            if (empty($validated['prestataire_id'])) {
                return response()->json([
                    'message' => 'Le prestataire est obligatoire pour ce type de favori.'
                ], 422);
            }

            $prestataire = User::where('id', $validated['prestataire_id'])
                ->where('role', 'prestataire')
                ->where('statut', 'actif')
                ->first();

            if (!$prestataire) {
                return response()->json([
                    'message' => 'Prestataire introuvable ou inactif.'
                ], 404);
            }

            if ((int) $prestataire->id === (int) $user->id) {
                return response()->json([
                    'message' => 'Vous ne pouvez pas ajouter votre propre profil prestataire aux favoris.'
                ], 422);
            }

            $like = Like::firstOrCreate([
                'membre_id' => $user->id,
                'prestataire_id' => $prestataire->id,
            ], [
                'annonce_id' => null,
                'type_cible' => 'prestataire',
            ]);

            return response()->json([
                'message' => 'Prestataire ajouté aux favoris.',
                'data' => $like
            ], 201);
        }
    }

    public function destroy(Request $request, $id)
    {
        $user = $request->user();

        if (!$this->peutUtiliserFavoris($user)) {
            return response()->json([
                'message' => 'Seuls les membres peuvent supprimer un favori.'
            ], 403);
        }

        $like = Like::where('id', $id)
            ->where('membre_id', $user->id)
            ->first();

        if (!$like) {
            return response()->json([
                'message' => 'Favori introuvable.'
            ], 404);
        }

        $like->delete();

        return response()->json([
            'message' => 'Favori supprimé avec succès.'
        ]);
    }

    public function mesLikes(Request $request)
    {
        $user = $request->user();

        if (!$this->peutUtiliserFavoris($user)) {
            return response()->json([
                'message' => 'Seuls les membres peuvent consulter leurs favoris.'
            ], 403);
        }

        $likes = Like::with([
            'annonce' => function ($query) {
                $query->select([
                    'id',
                    'prestataire_id',
                    'categorie_id',
                    'titre',
                    'description',
                    'tarif',
                    'localisation',
                    'statut',
                    'created_at',
                ])
                    ->where('statut', 'publiee')
                    ->with([
                        'categorie:id,nom',
                        'prestataire:id,nom,prenom,localisation,description_profil'
                    ]);
            },
            'prestataire:id,nom,prenom,localisation,description_profil,paiement_active'
        ])
            ->where('membre_id', $user->id)
            ->latest()
            ->get();

        return response()->json([
            'data' => $likes
        ]);
    }
}
