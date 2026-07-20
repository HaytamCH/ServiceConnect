<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use Illuminate\Validation\Rule;

class ProfileController extends Controller
{
    public function update(Request $request)
    {
        $user = $request->user();

        $validated = $request->validate([
            'nom' => 'required|string|max:100',
            'prenom' => 'required|string|max:100',
            'email' => [
                'required',
                'email',
                'max:150',
                Rule::unique('users', 'email')->ignore($user->id),
            ],
            'telephone' => 'nullable|string|max:30',
            'langue' => 'nullable|string|max:10',
            'localisation' => 'nullable|string|max:255',
            'description_profil' => 'nullable|string',
        ]);

        $user->update([
            'nom' => $validated['nom'],
            'prenom' => $validated['prenom'],
            'email' => $validated['email'],
            'telephone' => $validated['telephone'] ?? null,
            'langue' => $validated['langue'] ?? $user->langue,
            'localisation' => $validated['localisation'] ?? null,
            'description_profil' => $validated['description_profil'] ?? null,
        ]);

        return response()->json([
            'message' => 'Profil mis à jour avec succès.',
            'data' => [
                'id' => $user->id,
                'nom' => $user->nom,
                'prenom' => $user->prenom,
                'email' => $user->email,
                'telephone' => $user->telephone,
                'role' => $user->role,
                'statut' => $user->statut,
                'langue' => $user->langue,
                'localisation' => $user->localisation,
                'description_profil' => $user->description_profil,
                'paiement_active' => $user->paiement_active,
            ]
        ]);
    }

    public function updatePassword(Request $request)
    {
        $user = $request->user();

        $validated = $request->validate([
            'ancien_mot_de_passe' => 'required|string',
            'nouveau_mot_de_passe' => 'required|string|min:8|confirmed',
        ]);

        if (!Hash::check($validated['ancien_mot_de_passe'], $user->password)) {
            return response()->json([
                'message' => 'Ancien mot de passe incorrect.'
            ], 422);
        }

        $user->update([
            'password' => Hash::make($validated['nouveau_mot_de_passe']),
        ]);

        $user->tokens()->delete();

        return response()->json([
            'message' => 'Mot de passe modifié avec succès. Veuillez vous reconnecter.'
        ]);
    }
    public function devenirPrestataire(Request $request)
    {
        $user = $request->user();

        if ($user->role === 'administrateur') {
            return response()->json([
                'message' => 'Un administrateur ne peut pas devenir prestataire.'
            ], 403);
        }

        if ($user->role === 'prestataire') {
            return response()->json([
                'message' => 'Votre compte est déjà un compte prestataire.',
                'data' => $user
            ]);
        }

        $validated = $request->validate([
            'description_profil' => 'required|string|min:20',
            'localisation' => 'required|string|max:255',
            'telephone' => 'nullable|string|max:30',
        ]);

        $user->update([
            'role' => 'prestataire',
            'description_profil' => $validated['description_profil'],
            'localisation' => $validated['localisation'],
            'telephone' => $validated['telephone'] ?? $user->telephone,
            'paiement_active' => false,
        ]);

        return response()->json([
            'message' => 'Votre profil prestataire a été activé avec succès.',
            'data' => $user
        ]);
    }
}
