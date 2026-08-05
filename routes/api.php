<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\Api\CategorieController;
use App\Http\Controllers\Api\AnnonceController;
use App\Http\Controllers\Api\PrestataireController;
use App\Http\Controllers\Api\AuthController;
use App\Http\Controllers\Api\ReservationController;
use App\Http\Controllers\Api\MessageController;
use App\Http\Controllers\Api\LikeController;
use App\Http\Controllers\Api\AvisController;
use App\Http\Controllers\Api\DisponibiliteController;
use App\Http\Controllers\Api\AdminController;
use App\Http\Controllers\Api\PaiementController;
use App\Http\Controllers\Api\ProfileController;
use App\Http\Controllers\Api\NotificationController;
use App\Http\Controllers\Api\DemandeCategorieController;

/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
*/

Route::prefix('v1')->group(function () {

    /*
    |--------------------------------------------------------------------------
    | Routes publiques
    |--------------------------------------------------------------------------
    */

    Route::get('/categories', [CategorieController::class, 'index']);

    Route::get('/annonces', [AnnonceController::class, 'index']);
    Route::get('/annonces/{id}', [AnnonceController::class, 'show']);

    Route::get('/prestataires/{id}', [PrestataireController::class, 'show']);

    Route::post('/auth/register', [AuthController::class, 'register']);
    Route::post('/auth/login', [AuthController::class, 'login']);
    Route::post('/auth/forgot-password', [AuthController::class, 'forgotPassword']);
    Route::post('/auth/reset-password', [AuthController::class, 'resetPassword']);

    // Webhook Stripe : public, car Stripe ne peut pas se connecter avec Sanctum
    Route::post('/stripe/webhook', [PaiementController::class, 'stripeWebhook']);

    /*
    |--------------------------------------------------------------------------
    | Routes protégées
    |--------------------------------------------------------------------------
    */

    Route::middleware('auth:sanctum')->group(function () {

        /*
        |--------------------------------------------------------------------------
        | Authentification
        |--------------------------------------------------------------------------
        */

        Route::get('/auth/me', [AuthController::class, 'me']);
        Route::post('/auth/logout', [AuthController::class, 'logout']);

        /*
        |--------------------------------------------------------------------------
        | Profil utilisateur
        |--------------------------------------------------------------------------
        */

        Route::post('/profile', [ProfileController::class, 'update']);
        Route::put('/profile', [ProfileController::class, 'update']);
        Route::delete('/profile', [ProfileController::class, 'destroy']);
        Route::patch('/profile/password', [ProfileController::class, 'updatePassword']);
        Route::patch('/devenir-prestataire', [ProfileController::class, 'devenirPrestataire']);

        /*
        |--------------------------------------------------------------------------
        | Réservations membre
        |--------------------------------------------------------------------------
        */

        Route::post('/reservations', [ReservationController::class, 'store']);
        Route::get('/mes-reservations', [ReservationController::class, 'mesReservations']);
        Route::get('/reservations/{id}', [ReservationController::class, 'show']);

        /*
        |--------------------------------------------------------------------------
        | Messages
        |--------------------------------------------------------------------------
        */

        Route::get('/messages', [MessageController::class, 'index']);
        Route::post('/messages', [MessageController::class, 'store']);
        Route::patch('/messages/mark-as-read', [MessageController::class, 'markAsRead']);
        Route::get('/support/admin-contact', [MessageController::class, 'adminContact']);

        /*
        |--------------------------------------------------------------------------
        | Notifications
        |--------------------------------------------------------------------------
        */

        Route::get('/notifications', [NotificationController::class, 'index']);
        Route::get('/notifications/summary', [NotificationController::class, 'summary']);
        Route::patch('/notifications/mark-as-read', [NotificationController::class, 'markAsRead']);

        /*
        |--------------------------------------------------------------------------
        | Likes / favoris
        |--------------------------------------------------------------------------
        */

        Route::get('/mes-likes', [LikeController::class, 'mesLikes']);
        Route::post('/likes', [LikeController::class, 'store']);
        Route::delete('/likes/{id}', [LikeController::class, 'destroy']);

        /*
        |--------------------------------------------------------------------------
        | Avis
        |--------------------------------------------------------------------------
        */

        Route::post('/avis', [AvisController::class, 'store']);

        /*
        |--------------------------------------------------------------------------
        | Espace prestataire - annonces
        |--------------------------------------------------------------------------
        */

        Route::get('/prestataire/annonces', [AnnonceController::class, 'mesAnnonces']);
        Route::get('/prestataire/annonces/{id}', [AnnonceController::class, 'showPrestataireAnnonce']);
        Route::post('/prestataire/annonces', [AnnonceController::class, 'store']);
        Route::put('/prestataire/annonces/{id}', [AnnonceController::class, 'update']);
        Route::delete('/prestataire/annonces/{id}', [AnnonceController::class, 'destroy']);


        Route::post('/prestataire/demandes-categories', [DemandeCategorieController::class, 'store']);

        Route::get('/admin/demandes-categories', [DemandeCategorieController::class, 'adminIndex']);
        Route::patch('/admin/demandes-categories/{id}/accepter', [DemandeCategorieController::class, 'accepter']);
        Route::patch('/admin/demandes-categories/{id}/refuser', [DemandeCategorieController::class, 'refuser']);
        /*
        |--------------------------------------------------------------------------
        | Espace prestataire - disponibilités
        |--------------------------------------------------------------------------
        */

        Route::get('/prestataire/disponibilites', [DisponibiliteController::class, 'index']);
        Route::post('/prestataire/disponibilites', [DisponibiliteController::class, 'store']);
        Route::delete('/prestataire/disponibilites/{id}', [DisponibiliteController::class, 'destroy']);

        /*
        |--------------------------------------------------------------------------
        | Espace prestataire - réservations, avis, dashboard, paiements
        |--------------------------------------------------------------------------
        */

        Route::get('/prestataire/reservations', [ReservationController::class, 'reservationsRecues']);
        Route::patch('/prestataire/reservations/{id}/statut', [ReservationController::class, 'modifierStatutPrestataire']);

        Route::get('/prestataire/avis', [AvisController::class, 'avisRecus']);
        Route::get('/prestataire/dashboard', [PrestataireController::class, 'dashboard']);
        Route::get('/prestataire/paiements', [PaiementController::class, 'paiementsPrestataire']);
        Route::patch('/reservations/{id}/alternative/accepter', [ReservationController::class, 'accepterAlternative']);
        Route::patch('/reservations/{id}/alternative/refuser', [ReservationController::class, 'refuserAlternative']);

        /*
        |--------------------------------------------------------------------------
        | Paiements
        |--------------------------------------------------------------------------
        */

        Route::post('/paiements', [PaiementController::class, 'store']);
        Route::get('/mes-paiements', [PaiementController::class, 'mesPaiements']);
        Route::get('/paiements/{id}', [PaiementController::class, 'show']);

        /*
        |--------------------------------------------------------------------------
        | Administration
        |--------------------------------------------------------------------------
        */

        Route::get('/admin/dashboard', [AdminController::class, 'dashboard']);

        Route::get('/admin/users', [AdminController::class, 'users']);
        Route::patch('/admin/users/{id}/statut', [AdminController::class, 'modifierStatutUser']);

        Route::get('/admin/annonces', [AdminController::class, 'annonces']);
        Route::patch('/admin/annonces/{id}/statut', [AdminController::class, 'modifierStatutAnnonce']);

        Route::get('/admin/categories', [AdminController::class, 'categories']);
        Route::post('/admin/categories', [AdminController::class, 'creerCategorie']);
        Route::put('/admin/categories/{id}', [AdminController::class, 'modifierCategorie']);
        Route::delete('/admin/categories/{id}', [AdminController::class, 'supprimerCategorie']);

        Route::get('/admin/avis', [AdminController::class, 'avis']);
        Route::patch('/admin/avis/{id}/visibilite', [AdminController::class, 'modifierVisibiliteAvis']);

        Route::get('/admin/messages', [AdminController::class, 'messages']);

        Route::get('/admin/paiements', [AdminController::class, 'paiements']);
        Route::patch('/admin/paiements/{id}/statut', [AdminController::class, 'modifierStatutPaiement']);
        Route::patch('/admin/users/{id}/demande-prestataire/accepter', [AdminController::class, 'accepterDemandePrestataire']);
        Route::patch('/admin/users/{id}/demande-prestataire/refuser', [AdminController::class, 'refuserDemandePrestataire']);
    });
});
