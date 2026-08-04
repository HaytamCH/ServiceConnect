<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\User;
use App\Models\UserNotification;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Password;
use Illuminate\Support\Str;
use Illuminate\Auth\Events\PasswordReset;
use Illuminate\Auth\Notifications\ResetPassword as ResetPasswordNotification;
class AuthController extends Controller
{
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

    public function register(Request $request)
    {
        $validated = $request->validate([
            'nom' => 'required|string|max:100',
            'prenom' => 'required|string|max:100',
            'email' => 'required|email|max:150|unique:users,email',
            'telephone' => 'required_if:role,prestataire|nullable|string|max:30',
            'localisation' => 'required_if:role,prestataire|nullable|string|max:255',
            'role' => 'required|in:membre,prestataire',
            'description_profil' => 'required_if:role,prestataire|nullable|string|min:20',
            'langue' => 'nullable|string|max:10',

            'password' => [
                'required',
                'string',
                'min:8',
                function ($attribute, $value, $fail) {
                    if (!preg_match('/[A-Z]/', $value)) {
                        $fail('Le mot de passe doit contenir au moins une majuscule.');
                    }

                    if (!preg_match('/[0-9]/', $value)) {
                        $fail('Le mot de passe doit contenir au moins un chiffre.');
                    }

                    if (!preg_match('/[^A-Za-z0-9]/', $value)) {
                        $fail('Le mot de passe doit contenir au moins un caractère spécial.');
                    }
                },
            ],
        ], [
            'telephone.required_if' => 'Le numéro de téléphone est obligatoire pour créer une demande prestataire.',
            'localisation.required_if' => 'La localisation est obligatoire pour créer une demande prestataire.',
            'description_profil.required_if' => 'La description du profil est obligatoire pour créer une demande prestataire.',
            'description_profil.min' => 'La description du profil doit contenir au moins 20 caractères.',
        ]);

        $roleDemande = $validated['role'];

        $user = User::create([
            'nom' => $validated['nom'],
            'prenom' => $validated['prenom'],
            'email' => $validated['email'],
            'password' => Hash::make($validated['password']),
            'telephone' => $validated['telephone'] ?? null,


            // même si l’utilisateur choisit prestataire,
            // il reste membre jusqu’à validation admin.
            'role' => 'membre',

            'statut' => 'actif',
            'langue' => $validated['langue'] ?? 'fr',
            'localisation' => $validated['localisation'] ?? null,
            'description_profil' => null,
            'paiement_active' => false,

            'demande_prestataire_statut' => $roleDemande === 'prestataire' ? 'en_attente' : 'aucune',
            'demande_prestataire_description' => $roleDemande === 'prestataire'
                ? $validated['description_profil']
                : null,
            'demande_prestataire_localisation' => $roleDemande === 'prestataire'
                ? $validated['localisation']
                : null,
            'demande_prestataire_telephone' => $roleDemande === 'prestataire'
                ? $validated['telephone']
                : null,
            'demande_prestataire_date' => $roleDemande === 'prestataire'
                ? now()
                : null,
            'demande_prestataire_decision_at' => null,
        ]);

        if ($roleDemande === 'prestataire') {
            $this->notifierAdmins(
                'admin_demande_prestataire',
                'Nouvelle demande prestataire',
                $user->prenom . ' ' . $user->nom . ' souhaite créer un compte prestataire.',
                '/admin/users',
                'user',
                $user->id
            );
        }

        $token = $user->createToken('serviceconnect_token')->plainTextToken;

        return response()->json([
            'message' => $roleDemande === 'prestataire'
                ? 'Inscription réussie. Votre demande prestataire est en attente de validation.'
                : 'Inscription réussie.',
            'token' => $token,
            'user' => $this->formatUser($user->fresh())
        ], 201);
    }

    public function login(Request $request)
    {
        $validated = $request->validate([
            'email' => 'required|email',
            'password' => 'required|string',
        ]);

        if (!Auth::attempt($validated)) {
            return response()->json([
                'message' => 'Identifiants incorrects.'
            ], 401);
        }

        $user = Auth::user();

        if ($user->statut !== 'actif') {
            return response()->json([
                'message' => 'Votre compte a été désactivé. Veuillez contacter le service client ou l’administrateur pour plus d’informations.'
            ], 403);
        }

        $token = $user->createToken('serviceconnect_token')->plainTextToken;

        return response()->json([
            'message' => 'Connexion réussie.',
            'token' => $token,
            'user' => $this->formatUser($user),
        ]);
    }

    public function me(Request $request)
    {
        $user = $request->user();

        if ($user->statut !== 'actif') {
            $user->tokens()->delete();

            return response()->json([
                'message' => 'Votre compte a été désactivé. Veuillez contacter le service client ou l’administrateur pour plus d’informations.'
            ], 403);
        }

        return response()->json([
            'data' => $this->formatUser($user)
        ]);
    }

    public function logout(Request $request)
    {
        $request->user()->currentAccessToken()->delete();

        return response()->json([
            'message' => 'Déconnexion réussie.'
        ]);
    }

    public function forgotPassword(Request $request)
    {
        $request->validate([
            'email' => 'required|email',
        ]);

        ResetPasswordNotification::createUrlUsing(function ($notifiable, $token) {
            $frontendUrl = rtrim(
                (string) config('app.frontend_url'),
                '/'
            );

            return $frontendUrl . '/reset-password?token=' . $token . '&email=' . urlencode($notifiable->getEmailForPasswordReset());
        });

        Password::sendResetLink(
            $request->only('email')
        );

        return response()->json([
            'message' => 'Si cette adresse existe dans notre système, un lien de réinitialisation sera envoyé.'
        ]);
    }

    public function resetPassword(Request $request)
    {
        $validated = $request->validate([
            'token' => 'required',
            'email' => 'required|email',
            'password' => [
                'required',
                'string',
                'min:8',
                'confirmed',
                function ($attribute, $value, $fail) {
                    if (!preg_match('/[A-Z]/', $value)) {
                        $fail('Le mot de passe doit contenir au moins une majuscule.');
                    }

                    if (!preg_match('/[0-9]/', $value)) {
                        $fail('Le mot de passe doit contenir au moins un chiffre.');
                    }

                    if (!preg_match('/[^A-Za-z0-9]/', $value)) {
                        $fail('Le mot de passe doit contenir au moins un caractère spécial.');
                    }
                },
            ],
        ]);

        $status = Password::reset(
            $validated,
            function ($user, $password) {
                $user->forceFill([
                    'password' => Hash::make($password),
                    'remember_token' => Str::random(60),
                ])->save();

                $user->tokens()->delete();

                event(new PasswordReset($user));
            }
        );

        if ($status !== Password::PASSWORD_RESET) {
            return response()->json([
                'message' => 'Le lien de réinitialisation est invalide ou expiré.'
            ], 422);
        }

        return response()->json([
            'message' => 'Mot de passe réinitialisé avec succès.'
        ]);
    }
}
