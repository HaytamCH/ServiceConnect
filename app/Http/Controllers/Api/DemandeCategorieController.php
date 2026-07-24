<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Categorie;
use App\Models\DemandeCategorie;
use App\Models\User;
use App\Models\UserNotification;
use Illuminate\Http\Request;
use Illuminate\Validation\Rule;

class DemandeCategorieController extends Controller
{
    private function verifierAdmin($user)
    {
        if ($user->role !== 'administrateur') {
            return response()->json([
                'message' => 'Accès réservé à l’administrateur.'
            ], 403);
        }

        if ($user->statut !== 'actif') {
            return response()->json([
                'message' => 'Votre compte n’est pas actif.'
            ], 403);
        }

        return null;
    }

    private function notifierAdmins(DemandeCategorie $demande)
    {
        $admins = User::where('role', 'administrateur')
            ->where('statut', 'actif')
            ->get();

        foreach ($admins as $admin) {
            UserNotification::create([
                'user_id' => $admin->id,
                'type' => 'admin_demande_categorie',
                'titre' => 'Nouvelle demande de catégorie',
                'message' => 'Un prestataire a proposé une nouvelle catégorie : ' . $demande->nom . '.',
                'lien' => '/admin/categories',
                'related_type' => 'demande_categorie',
                'related_id' => $demande->id,
                'lu' => false,
            ]);
        }
    }

    public function store(Request $request)
    {
        $user = $request->user();

        if ($user->role !== 'prestataire') {
            return response()->json([
                'message' => 'Seuls les prestataires peuvent proposer une nouvelle catégorie.'
            ], 403);
        }

        if ($user->statut !== 'actif') {
            return response()->json([
                'message' => 'Votre compte n’est pas actif.'
            ], 403);
        }

        $validated = $request->validate([
            'nom' => [
                'required',
                'string',
                'max:100',
                Rule::unique('categories', 'nom'),
            ],
            'description' => 'nullable|string|max:1000',
        ]);

        $demandeExistante = DemandeCategorie::where('prestataire_id', $user->id)
            ->where('statut', 'en_attente')
            ->whereRaw('LOWER(nom) = ?', [strtolower(trim($validated['nom']))])
            ->first();

        if ($demandeExistante) {
            return response()->json([
                'message' => 'Vous avez déjà une demande en attente pour cette catégorie.'
            ], 422);
        }

        $demande = DemandeCategorie::create([
            'prestataire_id' => $user->id,
            'nom' => trim($validated['nom']),
            'description' => $validated['description'] ?? null,
            'statut' => 'en_attente',
        ]);

        $this->notifierAdmins($demande);

        $demande->load('prestataire:id,nom,prenom,email,telephone');

        return response()->json([
            'message' => 'Votre demande de catégorie a été envoyée à l’administrateur.',
            'data' => $demande,
        ], 201);
    }

    public function adminIndex(Request $request)
    {
        $verification = $this->verifierAdmin($request->user());

        if ($verification) {
            return $verification;
        }

        $demandes = DemandeCategorie::with([
            'prestataire:id,nom,prenom,email,telephone',
            'categorie:id,nom',
        ])
            ->latest()
            ->get();

        return response()->json([
            'data' => $demandes,
        ]);
    }

    public function accepter(Request $request, $id)
    {
        $verification = $this->verifierAdmin($request->user());

        if ($verification) {
            return $verification;
        }

        $demande = DemandeCategorie::with('prestataire')->find($id);

        if (!$demande) {
            return response()->json([
                'message' => 'Demande de catégorie introuvable.'
            ], 404);
        }

        if (!in_array($demande->statut, ['en_attente', 'refusee'])) {
            return response()->json([
                'message' => 'Cette demande ne peut pas être acceptée.'
            ], 422);
        }

        $categorie = Categorie::firstOrCreate(
            [
                'nom' => $demande->nom,
            ],
            [
                'description' => $demande->description,
                'active' => true,
            ]
        );

        $demande->update([
            'statut' => 'acceptee',
            'categorie_id' => $categorie->id,
            'motif_refus' => null,
        ]);

        UserNotification::create([
            'user_id' => $demande->prestataire_id,
            'type' => 'demande_categorie_acceptee',
            'titre' => 'Catégorie acceptée',
            'message' => 'Votre demande de catégorie "' . $demande->nom . '" a été acceptée. Vous pouvez maintenant l’utiliser pour publier une annonce.',
            'lien' => '/prestataire/annonces/nouvelle',
            'related_type' => 'demande_categorie',
            'related_id' => $demande->id,
            'lu' => false,
        ]);

        $demande->load([
            'prestataire:id,nom,prenom,email,telephone',
            'categorie:id,nom',
        ]);

        return response()->json([
            'message' => 'Demande acceptée. La catégorie a été ajoutée.',
            'data' => $demande,
        ]);
    }

    public function refuser(Request $request, $id)
    {
        $verification = $this->verifierAdmin($request->user());

        if ($verification) {
            return $verification;
        }

        $validated = $request->validate([
            'motif_refus' => 'nullable|string|max:1000',
        ]);

        $demande = DemandeCategorie::with('prestataire')->find($id);

        if (!$demande) {
            return response()->json([
                'message' => 'Demande de catégorie introuvable.'
            ], 404);
        }

        if ($demande->statut === 'acceptee') {
            return response()->json([
                'message' => 'Une demande déjà acceptée ne peut pas être refusée.'
            ], 422);
        }

        $demande->update([
            'statut' => 'refusee',
            'motif_refus' => $validated['motif_refus'] ?? null,
        ]);

        UserNotification::create([
            'user_id' => $demande->prestataire_id,
            'type' => 'demande_categorie_refusee',
            'titre' => 'Catégorie refusée',
            'message' => 'Votre demande de catégorie "' . $demande->nom . '" a été refusée. Vous pouvez contacter le service client si vous souhaitez plus d’informations.',
            'lien' => '/mes-messages',
            'related_type' => 'demande_categorie',
            'related_id' => $demande->id,
            'lu' => false,
        ]);

        $demande->load([
            'prestataire:id,nom,prenom,email,telephone',
            'categorie:id,nom',
        ]);

        return response()->json([
            'message' => 'Demande refusée.',
            'data' => $demande,
        ]);
    }
}
