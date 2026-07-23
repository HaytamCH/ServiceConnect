<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\User;
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

    public function register(Request $request)
    {
        $validated = $request->validate([
            'nom' => 'required|string|max:100',
            'prenom' => 'required|string|max:100',
            'email' => 'required|email|max:150|unique:users,email',
            'password' => 'required|string|min:8',
            'telephone' => 'nullable|string|max:30',
            'role' => 'required|in:membre,prestataire',
            'localisation' => 'nullable|string|max:255',
            'description_profil' => 'nullable|string',
            'langue' => 'nullable|string|max:10',
        ]);

        $user = User::create([
            'nom' => $validated['nom'],
            'prenom' => $validated['prenom'],
            'email' => $validated['email'],
            'password' => Hash::make($validated['password']),
            'telephone' => $validated['telephone'] ?? null,
            'role' => $validated['role'],
            'statut' => 'actif',
            'langue' => $validated['langue'] ?? 'fr',
            'localisation' => $validated['localisation'] ?? null,
            'description_profil' => $validated['description_profil'] ?? null,
            'paiement_active' => false,
        ]);

        $token = $user->createToken('serviceconnect_token')->plainTextToken;

        return response()->json([
            'message' => 'Inscription réussie.',
            'token' => $token,
            'user' => $this->formatUser($user),
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
                'message' => 'Ce compte n’est pas actif.'
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
            $frontendUrl = rtrim(config('services.stripe.frontend_url', env('FRONTEND_URL', 'http://localhost:5173')), '/');

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
            'password' => 'required|string|min:8|confirmed',
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
