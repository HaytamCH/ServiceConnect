<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Annonce;
use App\Models\Message;
use App\Models\Reservation;
use App\Models\User;
use App\Models\UserNotification;
use Illuminate\Http\Request;

class MessageController extends Controller
{
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

    public function index(Request $request)
    {
        $user = $request->user();

        $messages = Message::with([
            'expediteur:id,nom,prenom,role,photo_profil',
            'destinataire:id,nom,prenom,role,photo_profil',
            'annonce:id,titre,statut',
            'reservation:id,annonce_id,statut',
            'reservation.annonce:id,titre,statut',
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
            'annonce_id' => 'nullable|exists:annonces,id',
            'contenu' => 'required|string|max:2000',
        ]);

        if ((int) $validated['destinataire_id'] === (int) $user->id) {
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

        $reservation = null;

        if (!empty($validated['reservation_id'])) {
            $reservation = Reservation::find($validated['reservation_id']);

            if (
                (int) $reservation->membre_id !== (int) $user->id &&
                (int) $reservation->prestataire_id !== (int) $user->id &&
                $user->role !== 'administrateur'
            ) {
                return response()->json([
                    'message' => 'Accès interdit à cette réservation.'
                ], 403);
            }

            if (
                (int) $validated['destinataire_id'] !== (int) $reservation->membre_id &&
                (int) $validated['destinataire_id'] !== (int) $reservation->prestataire_id
            ) {
                return response()->json([
                    'message' => 'Le destinataire ne fait pas partie de cette réservation.'
                ], 422);
            }
        }

        $annonceId = $validated['annonce_id'] ?? ($reservation?->annonce_id ?? null);

        if ($annonceId) {
            $annonce = Annonce::where('id', $annonceId)
                ->where('statut', 'publiee')
                ->first();

            if (!$annonce) {
                return response()->json([
                    'message' => 'Cette annonce n’est plus disponible.'
                ], 422);
            }

            if ((int) $annonce->prestataire_id !== (int) $validated['destinataire_id']) {
                return response()->json([
                    'message' => 'Le destinataire ne correspond pas au prestataire de cette annonce.'
                ], 422);
            }
        }

        $message = Message::create([
            'expediteur_id' => $user->id,
            'destinataire_id' => $validated['destinataire_id'],
            'reservation_id' => $validated['reservation_id'] ?? null,
            'annonce_id' => $annonceId,
            'contenu' => $validated['contenu'],
            'lu' => false,
        ]);

        UserNotification::create([
            'user_id' => $validated['destinataire_id'],
            'type' => 'message',
            'titre' => 'Nouveau message',
            'message' => $user->prenom . ' ' . $user->nom . ' vous a envoyé un message.',
            'lien' => '/mes-messages',
            'related_type' => 'message',
            'related_id' => $message->id,
            'lu' => false,
        ]);

        if ($user->role !== 'administrateur' && $destinataire->role !== 'administrateur') {
            $this->notifierAdmins(
                'admin_message_echange',
                'Nouveau message échangé',
                'Un nouveau message a été échangé entre deux utilisateurs.',
                '/admin/messages',
                'message',
                $message->id
            );
        }

        $message->load([
            'expediteur:id,nom,prenom,role,photo_profil',
            'destinataire:id,nom,prenom,role,photo_profil',
            'annonce:id,titre,statut',
            'reservation:id,annonce_id,statut',
            'reservation.annonce:id,titre,statut',
        ]);

        return response()->json([
            'message' => 'Message envoyé avec succès.',
            'data' => $message
        ], 201);
    }

    public function markAsRead(Request $request)
    {
        $user = $request->user();

        Message::where('destinataire_id', $user->id)
            ->where('lu', false)
            ->update([
                'lu' => true,
            ]);

        return response()->json([
            'message' => 'Messages marqués comme lus.'
        ]);
    }
}
