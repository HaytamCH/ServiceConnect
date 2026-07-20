<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\User;
use App\Models\Annonce;
use App\Models\Reservation;
use App\Models\Avis;
use App\Models\Like;

class PrestataireController extends Controller
{
    public function show($id)
    {
        $prestataire = User::where('role', 'prestataire')
            ->where('statut', 'actif')
            ->with([
                'annonces' => function ($query) {
                    $query->where('statut', 'publiee')
                        ->latest()
                        ->with('categorie:id,nom')
                        ->select([
                            'id',
                            'prestataire_id',
                            'categorie_id',
                            'titre',
                            'description',
                            'tarif',
                            'localisation',
                            'statut',
                            'created_at',
                        ]);
                }
            ])
            ->find($id);

        if (!$prestataire) {
            return response()->json([
                'message' => 'Prestataire introuvable.'
            ], 404);
        }

        $noteMoyenne = $prestataire->avisRecus()
            ->where('visible', true)
            ->avg('note');

        $nombreAvis = $prestataire->avisRecus()
            ->where('visible', true)
            ->count();

        $nombreLikes = Like::where('type_cible', 'prestataire')
            ->where('prestataire_id', $prestataire->id)
            ->count();

        return response()->json([
            'data' => [
                'id' => $prestataire->id,
                'nom' => $prestataire->nom,
                'prenom' => $prestataire->prenom,
                'localisation' => $prestataire->localisation,
                'description_profil' => $prestataire->description_profil,
                'paiement_active' => $prestataire->paiement_active,
                'note_moyenne' => $noteMoyenne ? round($noteMoyenne, 1) : null,
                'nombre_avis' => $nombreAvis,
                'annonces' => $prestataire->annonces,
                'nombre_likes' => $nombreLikes,
            ]
        ]);
    }

    public function dashboard(Request $request)
    {
        $user = $request->user();

        if ($user->role !== 'prestataire') {
            return response()->json([
                'message' => 'Seuls les prestataires peuvent accéder au dashboard prestataire.'
            ], 403);
        }

        $annonceIds = Annonce::where('prestataire_id', $user->id)
            ->pluck('id');

        $nombreAnnonces = Annonce::where('prestataire_id', $user->id)
            ->count();

        $nombreAnnoncesPubliees = Annonce::where('prestataire_id', $user->id)
            ->where('statut', 'publiee')
            ->count();

        $nombreReservationsRecues = Reservation::where('prestataire_id', $user->id)
            ->count();

        $nombreReservationsEnAttente = Reservation::where('prestataire_id', $user->id)
            ->where('statut', 'en_attente')
            ->count();

        $nombreReservationsAcceptees = Reservation::where('prestataire_id', $user->id)
            ->where('statut', 'acceptee')
            ->count();

        $nombreReservationsTerminees = Reservation::where('prestataire_id', $user->id)
            ->where('statut', 'terminee')
            ->count();

        $nombreAvis = Avis::where('prestataire_id', $user->id)
            ->where('visible', true)
            ->count();

        $noteMoyenne = Avis::where('prestataire_id', $user->id)
            ->where('visible', true)
            ->avg('note');

        $nombreLikesPrestataire = Like::where('type_cible', 'prestataire')
            ->where('prestataire_id', $user->id)
            ->count();

        $nombreLikesAnnonces = Like::where('type_cible', 'annonce')
            ->whereIn('annonce_id', $annonceIds)
            ->count();

        return response()->json([
            'data' => [
                'nombre_annonces' => $nombreAnnonces,
                'nombre_annonces_publiees' => $nombreAnnoncesPubliees,
                'nombre_reservations_recues' => $nombreReservationsRecues,
                'nombre_reservations_en_attente' => $nombreReservationsEnAttente,
                'nombre_reservations_acceptees' => $nombreReservationsAcceptees,
                'nombre_reservations_terminees' => $nombreReservationsTerminees,
                'nombre_avis' => $nombreAvis,
                'note_moyenne' => $noteMoyenne ? round($noteMoyenne, 1) : null,
                'nombre_likes_prestataire' => $nombreLikesPrestataire,
                'nombre_likes_annonces' => $nombreLikesAnnonces,
            ]
        ]);
    }

}
