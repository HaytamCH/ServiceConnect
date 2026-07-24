<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\UserNotification;
use Illuminate\Http\Request;

class NotificationController extends Controller
{
    public function summary(Request $request)
    {
        $user = $request->user();

        $nonLues = UserNotification::where('user_id', $user->id)
            ->where('lu', false);

        return response()->json([
            'data' => [
                'total' => (clone $nonLues)->count(),

                'messages' => [
                    'non_lus' => (clone $nonLues)->where('type', 'message')->count(),
                ],

                'reservations_membre' => [
                    'acceptees' => (clone $nonLues)->where('type', 'reservation_acceptee')->count(),
                    'refusees' => (clone $nonLues)->where('type', 'reservation_refusee')->count(),
                    'alternatives' => (clone $nonLues)->where('type', 'reservation_alternative')->count(),
                    'terminees' => (clone $nonLues)->where('type', 'reservation_terminee')->count(),
                ],

                'reservations_prestataire' => [
                    'en_attente' => (clone $nonLues)->where('type', 'reservation_recue')->count(),
                ],

                'annonces_prestataire' => [
                    'validees' => (clone $nonLues)->where('type', 'annonce_validee')->count(),
                ],

                'paiements' => [
                    'acceptes' => (clone $nonLues)->where('type', 'paiement_accepte')->count(),
                    'refuses' => (clone $nonLues)->where('type', 'paiement_refuse')->count(),
                    'recus' => (clone $nonLues)->where('type', 'paiement_recu')->count(),
                ],

                'avis_prestataire' => [
                    'recus' => (clone $nonLues)->where('type', 'avis_recu')->count(),
                ],

                'demande_prestataire' => [
                    'acceptee' => (clone $nonLues)->where('type', 'demande_prestataire_acceptee')->count(),
                    'refusee' => (clone $nonLues)->where('type', 'demande_prestataire_refusee')->count(),
                ],

                'demandes_categories' => [
                    'acceptees' => (clone $nonLues)->where('type', 'demande_categorie_acceptee')->count(),
                    'refusees' => (clone $nonLues)->where('type', 'demande_categorie_refusee')->count(),
                ],

                'admin' => [
                    'annonces_en_attente' => (clone $nonLues)->where('type', 'admin_annonce_en_attente')->count(),
                    'avis_a_moderer' => (clone $nonLues)->where('type', 'admin_avis_publie')->count(),
                    'messages_a_surveiller' => (clone $nonLues)->where('type', 'admin_message_echange')->count(),
                    'demandes_prestataires' => (clone $nonLues)->where('type', 'admin_demande_prestataire')->count(),
                    'categories_a_valider' => (clone $nonLues)->where('type', 'admin_demande_categorie')->count(),
                ],
            ],
        ]);
    }

    public function index(Request $request)
    {
        $notifications = UserNotification::where('user_id', $request->user()->id)
            ->latest()
            ->paginate(20);

        return response()->json($notifications);
    }

    public function markAsRead(Request $request)
    {
        $user = $request->user();
        $type = $request->query('type');

        $query = UserNotification::where('user_id', $user->id)
            ->where('lu', false);

        if ($type) {
            $query->where('type', $type);
        }

        $query->update([
            'lu' => true,
            'read_at' => now(),
        ]);

        return response()->json([
            'message' => 'Notifications marquées comme lues.'
        ]);
    }
}
