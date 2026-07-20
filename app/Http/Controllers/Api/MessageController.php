<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Message;
use App\Models\Reservation;
use App\Models\User;
use Illuminate\Http\Request;

class MessageController extends Controller
{
    public function index(Request $request)
    {
        $user = $request->user();

        $messages = Message::with([
            'expediteur:id,nom,prenom,role',
            'destinataire:id,nom,prenom,role',
            'reservation:id,annonce_id,statut'
        ])
            ->where(function ($query) use ($user) {
                $query->where('expediteur_id', $user->id)
                    ->orWhere('destinataire_id', $user->id);
            })
            ->latest()
            ->paginate(20);

        return response()->json($messages);
    }

    public function store(Request $request)
    {
        $user = $request->user();

        if ($user->statut !== 'actif') {
            return response()->json([
                'message' => 'Votre compte n’est pas actif.'
            ], 403);
        }

        $validated = $request->validate([
            'destinataire_id' => 'required|exists:users,id',
            'reservation_id' => 'nullable|exists:reservations,id',
            'contenu' => 'required|string|max:2000',
        ]);

        if ($validated['destinataire_id'] == $user->id) {
            return response()->json([
                'message' => 'Vous ne pouvez pas vous envoyer un message à vous-même.'
            ], 422);
        }

        $destinataire = User::where('id', $validated['destinataire_id'])
            ->where('statut', 'actif')
            ->first();

        if (!$destinataire) {
            return response()->json([
                'message' => 'Destinataire introuvable ou inactif.'
            ], 404);
        }

        if (!empty($validated['reservation_id'])) {
            $reservation = Reservation::find($validated['reservation_id']);

            if (
                $reservation->membre_id !== $user->id &&
                $reservation->prestataire_id !== $user->id &&
                $user->role !== 'administrateur'
            ) {
                return response()->json([
                    'message' => 'Accès interdit à cette réservation.'
                ], 403);
            }

            if (
                $validated['destinataire_id'] !== $reservation->membre_id &&
                $validated['destinataire_id'] !== $reservation->prestataire_id
            ) {
                return response()->json([
                    'message' => 'Le destinataire ne fait pas partie de cette réservation.'
                ], 422);
            }
        }

        $message = Message::create([
            'expediteur_id' => $user->id,
            'destinataire_id' => $validated['destinataire_id'],
            'reservation_id' => $validated['reservation_id'] ?? null,
            'contenu' => $validated['contenu'],
            'lu' => false,
        ]);

        $message->load([
            'expediteur:id,nom,prenom,role',
            'destinataire:id,nom,prenom,role',
            'reservation:id,annonce_id,statut'
        ]);

        return response()->json([
            'message' => 'Message envoyé avec succès.',
            'data' => $message
        ], 201);
    }
}
