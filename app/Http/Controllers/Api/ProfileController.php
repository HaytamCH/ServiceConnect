<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\User;
use App\Models\UserNotification;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Log;
use Illuminate\Validation\Rule;
use Illuminate\Support\Facades\Storage;

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
            'photo_profil' => 'nullable|image|mimes:jpg,jpeg,png,webp|max:2048',
        ]);

        $data = [
            'nom' => $validated['nom'],
            'prenom' => $validated['prenom'],
            'email' => $validated['email'],
            'telephone' => $validated['telephone'] ?? null,
            'langue' => $validated['langue'] ?? $user->langue,
            'localisation' => $validated['localisation'] ?? null,
            'description_profil' => $validated['description_profil'] ?? null,
        ];

        if ($request->hasFile('photo_profil')) {
            if ($user->photo_profil) {
                Storage::disk('public')->delete($user->photo_profil);
            }

            $data['photo_profil'] = $request->file('photo_profil')
                ->store('profile_photos', 'public');
        }

        $user->update($data);
        $user->refresh();

        return response()->json([
            'message' => 'Profil mis à jour avec succès.',
            'data' => $this->formatUser($user)
        ]);
    }

    private function notifierAdmins($type, $titre, $message, $lien, $relatedType, $relatedId)
    {
        $admins = User::where('role', 'administrateur')
            ->where('statut', 'actif')
            ->get();

        foreach ($admins as $admin) {
            UserNotification::create([
                'user_id' => $admin->id,
                'type' => $type,
                'titre' => $titre,
                'message' => $message,
                'lien' => $lien,
                'related_type' => $relatedType,
                'related_id' => $relatedId,
                'lu' => false,
            ]);
        }
    }

    private function formatUser($user)
    {
        return [
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
            'photo_profil' => $user->photo_profil,
            'photo_profil_url' => $user->photo_profil_url,
            'paiement_active' => $user->paiement_active,
            'demande_prestataire_statut' => $user->demande_prestataire_statut,
            'demande_prestataire_description' => $user->demande_prestataire_description,
            'demande_prestataire_localisation' => $user->demande_prestataire_localisation,
            'demande_prestataire_telephone' => $user->demande_prestataire_telephone,
            'demande_prestataire_date' => $user->demande_prestataire_date,
        ];
    }

    public function updatePassword(Request $request)
    {
        $user = $request->user();

        $validated = $request->validate([
            'ancien_mot_de_passe' => 'required|string',
            'nouveau_mot_de_passe' => [
                'required',
                'string',
                'min:8',
                'confirmed',
                function ($attribute, $value, $fail) {
                    if (!preg_match('/[A-Z]/', $value)) {
                        $fail('Le nouveau mot de passe doit contenir au moins une majuscule.');
                    }

                    if (!preg_match('/[0-9]/', $value)) {
                        $fail('Le nouveau mot de passe doit contenir au moins un chiffre.');
                    }

                    if (!preg_match('/[^A-Za-z0-9]/', $value)) {
                        $fail('Le nouveau mot de passe doit contenir au moins un caractère spécial.');
                    }
                },
            ],
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
    public function destroy(Request $request)
    {
        $user = $request->user();

        if (!in_array($user->role, ['membre', 'prestataire'], true)) {
            return response()->json([
                'message' => 'La désinscription directe est réservée aux comptes membres et prestataires.'
            ], 403);
        }

        $validated = $request->validate([
            'password' => 'required|string',
            'confirmation' => 'accepted',
        ]);

        if (!Hash::check($validated['password'], $user->password)) {
            return response()->json([
                'message' => 'Le mot de passe est incorrect.',
                'errors' => [
                    'password' => ['Le mot de passe est incorrect.'],
                ],
            ], 422);
        }

        $userId = $user->id;
        $reservationsConservees = $user->reservationsCommeMembre()->count();
        $paiementsConserves = $user->paiements()->count();
        $annoncesRetirees = $user->estPrestataire()
            ? $user->annonces()->where('statut', '!=', 'supprimee')->count()
            : 0;

        DB::transaction(function () use ($user) {
            if ($user->estPrestataire()) {
                $user->annonces()->update(['statut' => 'supprimee']);
            }

            $user->tokens()->delete();
            $user->update(['statut' => 'desactive']);
            $user->delete();
        });

        Log::info('Compte utilisateur désinscrit par soft delete.', [
            'user_id' => $userId,
            'reservations_conservees' => $reservationsConservees,
            'paiements_conserves' => $paiementsConserves,
            'annonces_retirees' => $annoncesRetirees,
        ]);

        return response()->json([
            'message' => 'Votre compte a été désinscrit. Vos transactions restent conservées dans l’historique.',
            'data' => [
                'user_id' => $userId,
                'deleted_at' => optional($user->deleted_at)->toISOString(),
                'reservations_conservees' => $reservationsConservees,
                'paiements_conserves' => $paiementsConserves,
                'annonces_retirees' => $annoncesRetirees,
            ],
        ]);
    }

    public function devenirPrestataire(Request $request)
    {
        $user = $request->user();

        if ($user->role === 'administrateur') {
            return response()->json([
                'message' => 'Un administrateur ne peut pas faire une demande prestataire.'
            ], 403);
        }

        if ($user->role === 'prestataire') {
            return response()->json([
                'message' => 'Votre compte est déjà un compte prestataire.',
                'data' => $this->formatUser($user)
            ]);
        }

        if ($user->demande_prestataire_statut === 'en_attente') {
            return response()->json([
                'message' => 'Votre demande prestataire est déjà en attente de validation.',
                'data' => $this->formatUser($user)
            ], 422);
        }

        $validated = $request->validate([
            'description_profil' => 'required|string|min:20',
            'localisation' => 'required|string|max:255',
            'telephone' => 'required|string|max:30',
        ]);

        $user->update([
            'demande_prestataire_statut' => 'en_attente',
            'demande_prestataire_description' => $validated['description_profil'],
            'demande_prestataire_localisation' => $validated['localisation'],
            'demande_prestataire_telephone' => $validated['telephone'],
            'demande_prestataire_date' => now(),
            'demande_prestataire_decision_at' => null,
        ]);

        $this->notifierAdmins(
            'admin_demande_prestataire',
            'Nouvelle demande prestataire',
            $user->prenom . ' ' . $user->nom . ' souhaite devenir prestataire.',
            '/admin/users',
            'user',
            $user->id
        );

        return response()->json([
            'message' => 'Votre demande prestataire a été envoyée. Elle doit être validée par un administrateur.',
            'data' => $this->formatUser($user->fresh())
        ]);
    }
}
