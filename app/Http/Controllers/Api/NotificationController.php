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

                'paiements' => [
                    'acceptes' => (clone $nonLues)->where('type', 'paiement_accepte')->count(),
                    'refuses' => (clone $nonLues)->where('type', 'paiement_refuse')->count(),
                    'recus' => (clone $nonLues)->where('type', 'paiement_recu')->count(),
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
