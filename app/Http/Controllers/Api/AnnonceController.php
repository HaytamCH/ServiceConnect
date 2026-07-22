<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Annonce;
use App\Models\User;
use App\Models\UserNotification;
use Illuminate\Http\Request;

class AnnonceController extends Controller
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
        $query = Annonce::with([
            'categorie:id,nom',
            'prestataire:id,nom,prenom,localisation,description_profil'
        ])
            ->withCount('likes')
            ->where('statut', 'publiee');

        $categorieId = $request->query('categorie_id', $request->query('categorie'));

        if (!empty($categorieId)) {
            $query->where('categorie_id', $categorieId);
        }

        if ($request->filled('localisation')) {
            $query->where('localisation', 'like', '%' . trim($request->localisation) . '%');
        }

        if ($request->filled('tarif_min')) {
            $query->where('tarif', '>=', $request->tarif_min);
        }

        if ($request->filled('tarif_max')) {
            $query->where('tarif', '<=', $request->tarif_max);
        }

        $search = trim($request->query('search', $request->query('q', '')));

        if ($search !== '') {
            $searchLower = strtolower($search);

            $query->where(function ($q) use ($search, $searchLower) {
                $q->where('titre', 'like', '%' . $search . '%')
                    ->orWhere('description', 'like', '%' . $search . '%')
                    ->orWhere('localisation', 'like', '%' . $search . '%')
                    ->orWhereHas('categorie', function ($categorieQuery) use ($search) {
                        $categorieQuery->where('nom', 'like', '%' . $search . '%');
                    })
                    ->orWhereHas('prestataire', function ($prestataireQuery) use ($search, $searchLower) {
                        $prestataireQuery->where('nom', 'like', '%' . $search . '%')
                            ->orWhere('prenom', 'like', '%' . $search . '%')
                            ->orWhereRaw(
                                "LOWER(CONCAT(COALESCE(prenom, ''), ' ', COALESCE(nom, ''))) LIKE ?",
                                ['%' . $searchLower . '%']
                            )
                            ->orWhereRaw(
                                "LOWER(CONCAT(COALESCE(nom, ''), ' ', COALESCE(prenom, ''))) LIKE ?",
                                ['%' . $searchLower . '%']
                            );
                    });
            });
        }

        $annonces = $query
            ->latest()
            ->paginate(12);

        return response()->json($annonces);
    }


    public function show($id)
    {
        $annonce = Annonce::with([
            'categorie:id,nom,description',
            'prestataire:id,nom,prenom,localisation,description_profil',
            'disponibilites:id,annonce_id,date_debut,date_fin,disponible',
            'avis' => function ($query) {
                $query->where('visible', true)
                    ->latest()
                    ->take(5)
                    ->with('membre:id,nom,prenom');
            }
        ])
            ->where('statut', 'publiee')
            ->find($id);

        if (!$annonce) {
            return response()->json([
                'message' => 'Annonce introuvable.'
            ], 404);
        }

        $noteMoyenne = $annonce->avis()
            ->where('visible', true)
            ->avg('note');

        $nombreAvis = $annonce->avis()
            ->where('visible', true)
            ->count();
        $nombreLikes = $annonce->likes()->count();

        return response()->json([
            'data' => [
                'id' => $annonce->id,
                'titre' => $annonce->titre,
                'description' => $annonce->description,
                'tarif' => $annonce->tarif,
                'localisation' => $annonce->localisation,
                'categorie' => $annonce->categorie,
                'prestataire' => $annonce->prestataire,
                'disponibilites' => $annonce->disponibilites,
                'avis' => $annonce->avis,
                'note_moyenne' => $noteMoyenne ? round($noteMoyenne, 1) : null,
                'nombre_avis' => $nombreAvis,
                'nombre_likes' => $nombreLikes,
            ]
        ]);
    }
    public function store(Request $request)
    {
        $user = $request->user();

        if ($user->role !== 'prestataire') {
            return response()->json([
                'message' => 'Seuls les prestataires peuvent créer une annonce.'
            ], 403);
        }

        if ($user->statut !== 'actif') {
            return response()->json([
                'message' => 'Votre compte n’est pas actif.'
            ], 403);
        }

        $validated = $request->validate([
            'titre' => 'required|string|max:150',
            'description' => 'required|string|min:10',
            'categorie_id' => 'required|exists:categories,id',
            'tarif' => 'required|numeric|min:10',
            'localisation' => 'required|string|max:255',
        ]);

        $annonce = Annonce::create([
            'prestataire_id' => $user->id,
            'categorie_id' => $validated['categorie_id'],
            'titre' => $validated['titre'],
            'description' => $validated['description'],
            'tarif' => $validated['tarif'] ?? null,
            'localisation' => $validated['localisation'],
            'statut' => 'en_attente',
        ]);

        $annonce->load([
            'categorie:id,nom',
            'prestataire:id,nom,prenom,localisation'
        ]);
        $this->notifierAdmins(
            'admin_annonce_en_attente',
            'Nouvelle annonce à valider',
            'Une nouvelle annonce a été créée par ' . $user->prenom . ' ' . $user->nom . '.',
            '/admin/annonces',
            'annonce',
            $annonce->id
        );

        return response()->json([
            'message' => 'Annonce créée avec succès. Elle est en attente de validation.',
            'data' => $annonce
        ], 201);
    }

    public function update(Request $request, $id)
    {
        $user = $request->user();

        if ($user->role !== 'prestataire') {
            return response()->json([
                'message' => 'Seuls les prestataires peuvent modifier une annonce.'
            ], 403);
        }

        if ($user->statut !== 'actif') {
            return response()->json([
                'message' => 'Votre compte n’est pas actif.'
            ], 403);
        }

        $annonce = Annonce::where('id', $id)
            ->where('prestataire_id', $user->id)
            ->first();

        if (!$annonce) {
            return response()->json([
                'message' => 'Annonce introuvable ou accès interdit.'
            ], 404);
        }

        if ($annonce->statut === 'supprimee') {
            return response()->json([
                'message' => 'Une annonce supprimée ne peut plus être modifiée.'
            ], 422);
        }

        $validated = $request->validate([
            'titre' => 'required|string|max:150',
            'description' => 'required|string|min:10',
            'categorie_id' => 'required|exists:categories,id',
            'tarif' => 'required|numeric|min:10',
            'localisation' => 'required|string|max:255',
        ]);

        $annonce->update([
            'categorie_id' => $validated['categorie_id'],
            'titre' => $validated['titre'],
            'description' => $validated['description'],
            'tarif' => $validated['tarif'] ?? null,
            'localisation' => $validated['localisation'] ?? $user->localisation,
            'statut' => 'en_attente',
        ]);

        $annonce->load([
            'categorie:id,nom',
            'prestataire:id,nom,prenom,localisation'
        ]);

        $this->notifierAdmins(
            'admin_annonce_en_attente',
            'Annonce modifiée à valider',
            'Une annonce a été modifiée par ' . $user->prenom . ' ' . $user->nom . ' et repasse en attente de validation.',
            '/admin/annonces',
            'annonce',
            $annonce->id
        );

        return response()->json([
            'message' => 'Annonce modifiée avec succès. Elle repasse en attente de validation.',
            'data' => $annonce
        ]);
    }

    public function destroy(Request $request, $id)
    {
        $user = $request->user();

        if ($user->role !== 'prestataire') {
            return response()->json([
                'message' => 'Seuls les prestataires peuvent supprimer une annonce.'
            ], 403);
        }

        $annonce = Annonce::where('id', $id)
            ->where('prestataire_id', $user->id)
            ->first();

        if (!$annonce) {
            return response()->json([
                'message' => 'Annonce introuvable ou accès interdit.'
            ], 404);
        }

        $annonce->update([
            'statut' => 'supprimee',
        ]);

        return response()->json([
            'message' => 'Annonce supprimée avec succès.'
        ]);
    }


    public function mesAnnonces(Request $request)
    {
        $user = $request->user();

        if ($user->role !== 'prestataire') {
            return response()->json([
                'message' => 'Seuls les prestataires peuvent consulter leurs annonces.'
            ], 403);
        }

        $annonces = Annonce::with([
            'categorie:id,nom',
        ])
            ->where('prestataire_id', $user->id)
            ->latest()
            ->get();

        return response()->json([
            'data' => $annonces
        ]);
    }

    public function showPrestataireAnnonce(Request $request, $id)
    {
        $user = $request->user();

        if ($user->role !== 'prestataire') {
            return response()->json([
                'message' => 'Seuls les prestataires peuvent consulter cette annonce.'
            ], 403);
        }

        $annonce = Annonce::with([
            'categorie:id,nom,description',
            'disponibilites:id,annonce_id,date_debut,date_fin,disponible',
            'reservations:id,annonce_id,membre_id,statut,date_service,message_demande',
            'reservations.membre:id,nom,prenom'
        ])
            ->where('id', $id)
            ->where('prestataire_id', $user->id)
            ->first();

        if (!$annonce) {
            return response()->json([
                'message' => 'Annonce introuvable ou accès interdit.'
            ], 404);
        }

        return response()->json([
            'data' => $annonce
        ]);
    }
}
