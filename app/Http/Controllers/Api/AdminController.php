<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Annonce;
use App\Models\Avis;
use App\Models\Categorie;
use App\Models\Like;
use App\Models\Message;
use App\Models\Paiement;
use App\Models\Reservation;
use App\Models\User;
use Illuminate\Http\Request;

class AdminController extends Controller
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

    public function dashboard(Request $request){
        $verification = $this->verifierAdmin($request->user());

        if($verification){
            return $verification;
        }
        return response()->json([
        'data' => [
            'nombre_utilisateurs' => User::count(),
            'nombre_membres' => User::where('role', 'membre')->count(),
            'nombre_prestataires' => User::where('role', 'prestataire')->count(),
            'nombre_administrateurs' => User::where('role', 'administrateur')->count(),

            'nombre_categories' => Categorie::count(),
            'nombre_annonces' => Annonce::count(),
            'nombre_annonces_en_attente' => Annonce::where('statut', 'en_attente')->count(),
            'nombre_annonces_publiees' => Annonce::where('statut', 'publiee')->count(),
            'nombre_annonces_suspendues' => Annonce::where('statut', 'suspendue')->count(),

            'nombre_reservations' => Reservation::count(),
            'nombre_messages' => Message::count(),
            'nombre_avis' => Avis::count(),
            'nombre_likes' => Like::count(),

            'nombre_paiements' => Paiement::count(),
            'nombre_paiements_acceptes' => Paiement::where('statut', 'accepte')->count(),
            'montant_total_paiements' => Paiement::where('statut', 'accepte')->sum('montant'),
        ]
        ]);
    }

    public function users(Request $request)
    {
        $verification = $this->verifierAdmin($request->user());

        if ($verification) {
            return $verification;
        }

        $search = trim($request->query('search', ''));

        $users = User::query()
            ->select([
                'id',
                'nom',
                'prenom',
                'email',
                'telephone',
                'role',
                'statut',
                'localisation',
                'created_at',
            ])
            ->when($search !== '', function ($query) use ($search) {
                $searchLower =strtolower($search);
                $query->where(function ($q) use ($search, $searchLower) {
                    $q->where('nom', 'like', '%' . $search . '%')
                        ->orWhere('prenom', 'like', '%' . $search . '%')
                        ->orWhere('email', 'like', '%' . $search . '%')
                        ->orWhere('telephone', 'like', '%' . $search . '%')
                        ->orWhere('localisation', 'like', '%' . $search . '%')
                        ->orWhereRaw(
                        "LOWER(CONCAT(COALESCE(prenom, ''), ' ', COALESCE(nom, ''))) LIKE ?",
                        ['%' . $searchLower . '%']
                    )
                        ->orWhereRaw(
                            "LOWER(CONCAT(COALESCE(nom, ''), ' ', COALESCE(prenom, ''))) LIKE ?",
                            ['%' . $searchLower . '%']
                        );
                });
            })
            ->latest()
            ->paginate(20)
            ->appends($request->only('search'));

        return response()->json($users);
    }

    public function modifierStatutUser(Request $request, $id)
    {
        $verification = $this->verifierAdmin($request->user());

        if ($verification) {
            return $verification;
        }

        $validated = $request->validate([
            'statut' => 'required|in:actif,desactive,suspendu',
        ]);

        $user = User::find($id);

        if (!$user) {
            return response()->json([
                'message' => 'Utilisateur introuvable.'
            ], 404);
        }

        if ($user->role === 'administrateur' && $user->id === $request->user()->id) {
            return response()->json([
                'message' => 'Vous ne pouvez pas modifier votre propre statut administrateur.'
            ], 422);
        }

        $user->update([
            'statut' => $validated['statut'],
        ]);

        return response()->json([
            'message' => 'Statut de l’utilisateur mis à jour.',
            'data' => [
                'id' => $user->id,
                'nom' => $user->nom,
                'prenom' => $user->prenom,
                'email' => $user->email,
                'role' => $user->role,
                'statut' => $user->statut,
            ]
        ]);
    }

    public function annonces(Request $request)
    {
        $verification = $this->verifierAdmin($request->user());

        if ($verification) {
            return $verification;
        }

        $search = trim($request->query('search', ''));

        $annonces = Annonce::with([
            'prestataire:id,nom,prenom,email,statut',
            'categorie:id,nom'
        ])
            ->when($search !== '', function ($query) use ($search) {
                $query->where(function ($q) use ($search) {
                    $q->where('titre', 'like', '%' . $search . '%')
                        ->orWhere('description', 'like', '%' . $search . '%')
                        ->orWhere('localisation', 'like', '%' . $search . '%')
                        ->orWhereHas('prestataire', function ($prestataireQuery) use ($search) {
                            $searchLower = strtolower($search);

                            $prestataireQuery->where('nom', 'like', '%' . $search . '%')
                                ->orWhere('prenom', 'like', '%' . $search . '%')
                                ->orWhere('email', 'like', '%' . $search . '%')
                                ->orWhereRaw(
                                    "LOWER(CONCAT(COALESCE(prenom, ''), ' ', COALESCE(nom, ''))) LIKE ?",
                                    ['%' . $searchLower . '%']
                                )
                                ->orWhereRaw(
                                    "LOWER(CONCAT(COALESCE(nom, ''), ' ', COALESCE(prenom, ''))) LIKE ?",
                                    ['%' . $searchLower . '%']
                                );
                        })
                        ->orWhereHas('categorie', function ($categorieQuery) use ($search) {
                            $categorieQuery->where('nom', 'like', '%' . $search . '%');
                        });
                });
            })
            ->latest()
            ->paginate(20)
            ->appends($request->only('search'));

        return response()->json($annonces);
    }

    public function modifierStatutAnnonce(Request $request, $id)
    {
        $verification = $this->verifierAdmin($request->user());

        if ($verification) {
            return $verification;
        }

        $validated = $request->validate([
            'statut' => 'required|in:brouillon,en_attente,publiee,suspendue,supprimee',
        ]);

        $annonce = Annonce::find($id);

        if (!$annonce) {
            return response()->json([
                'message' => 'Annonce introuvable.'
            ], 404);
        }

        $annonce->update([
            'statut' => $validated['statut'],
        ]);

        $annonce->load([
            'prestataire:id,nom,prenom,email,statut',
            'categorie:id,nom'
        ]);

        return response()->json([
            'message' => 'Statut de l’annonce mis à jour.',
            'data' => $annonce
        ]);
    }
    public function categories(Request $request)
    {
        $verification = $this->verifierAdmin($request->user());

        if ($verification) {
            return $verification;
        }

        $categories = Categorie::withCount('annonces')
            ->orderBy('nom')
            ->get();

        return response()->json([
            'data' => $categories
        ]);
    }

    public function creerCategorie(Request $request)
    {
        $verification = $this->verifierAdmin($request->user());

        if ($verification) {
            return $verification;
        }

        $validated = $request->validate([
            'nom' => 'required|string|max:100|unique:categories,nom',
            'description' => 'nullable|string',
            'active' => 'nullable|boolean',
        ]);

        $categorie = Categorie::create([
            'nom' => $validated['nom'],
            'description' => $validated['description'] ?? null,
            'active' => $validated['active'] ?? true,
        ]);

        return response()->json([
            'message' => 'Catégorie créée avec succès.',
            'data' => $categorie
        ], 201);
    }

    public function modifierCategorie(Request $request, $id)
    {
        $verification = $this->verifierAdmin($request->user());

        if ($verification) {
            return $verification;
        }

        $categorie = Categorie::find($id);

        if (!$categorie) {
            return response()->json([
                'message' => 'Catégorie introuvable.'
            ], 404);
        }

        $validated = $request->validate([
            'nom' => 'required|string|max:100|unique:categories,nom,' . $categorie->id,
            'description' => 'nullable|string',
            'active' => 'nullable|boolean',
        ]);

        $categorie->update([
            'nom' => $validated['nom'],
            'description' => $validated['description'] ?? null,
            'active' => $validated['active'] ?? $categorie->active,
        ]);

        return response()->json([
            'message' => 'Catégorie modifiée avec succès.',
            'data' => $categorie
        ]);
    }

    public function supprimerCategorie(Request $request, $id)
    {
        $verification = $this->verifierAdmin($request->user());

        if ($verification) {
            return $verification;
        }

        $categorie = Categorie::find($id);

        if (!$categorie) {
            return response()->json([
                'message' => 'Catégorie introuvable.'
            ], 404);
        }

        if ($categorie->annonces()->exists()) {
            $categorie->update([
                'active' => false,
            ]);

            return response()->json([
                'message' => 'Cette catégorie est liée à des annonces. Elle a donc été désactivée.'
            ]);
        }

        $categorie->delete();

        return response()->json([
            'message' => 'Catégorie supprimée avec succès.'
        ]);
    }

    public function avis(Request $request)
    {
        $verification = $this->verifierAdmin($request->user());

        if ($verification) {
            return $verification;
        }

        $search = trim($request->query('search', ''));

        $avis = Avis::with([
            'membre:id,nom,prenom,email,telephone',
            'prestataire:id,nom,prenom,email,telephone',
            'annonce:id,titre',
            'reservation:id,statut,date_service'
        ])
            ->when($search !== '', function ($query) use ($search) {
                $terms = preg_split('/\s+/', strtolower($search));

                $query->where(function ($q) use ($search, $terms) {
                    $q->where('commentaire', 'like', '%' . $search . '%')
                        ->orWhereHas('annonce', function ($annonceQuery) use ($search) {
                            $annonceQuery->where('titre', 'like', '%' . $search . '%');
                        })
                        ->orWhereHas('membre', function ($membreQuery) use ($search, $terms) {
                            $membreQuery->where('nom', 'like', '%' . $search . '%')
                                ->orWhere('prenom', 'like', '%' . $search . '%')
                                ->orWhere('email', 'like', '%' . $search . '%')
                                ->orWhere('telephone', 'like', '%' . $search . '%')
                                ->orWhere(function ($nameQuery) use ($terms) {
                                    foreach ($terms as $term) {
                                        $nameQuery->where(function ($subQuery) use ($term) {
                                            $subQuery->where('nom', 'like', '%' . $term . '%')
                                                ->orWhere('prenom', 'like', '%' . $term . '%');
                                        });
                                    }
                                });
                        })
                        ->orWhereHas('prestataire', function ($prestataireQuery) use ($search, $terms) {
                            $prestataireQuery->where('nom', 'like', '%' . $search . '%')
                                ->orWhere('prenom', 'like', '%' . $search . '%')
                                ->orWhere('email', 'like', '%' . $search . '%')
                                ->orWhere('telephone', 'like', '%' . $search . '%')
                                ->orWhere(function ($nameQuery) use ($terms) {
                                    foreach ($terms as $term) {
                                        $nameQuery->where(function ($subQuery) use ($term) {
                                            $subQuery->where('nom', 'like', '%' . $term . '%')
                                                ->orWhere('prenom', 'like', '%' . $term . '%');
                                        });
                                    }
                                });
                        });
                });
            })
            ->latest()
            ->paginate(20)
            ->appends($request->only('search'));

        return response()->json($avis);
    }

    public function modifierVisibiliteAvis(Request $request, $id)
    {
        $verification = $this->verifierAdmin($request->user());

        if ($verification) {
            return $verification;
        }

        $validated = $request->validate([
            'visible' => 'required|boolean',
        ]);

        $avis = Avis::find($id);

        if (!$avis) {
            return response()->json([
                'message' => 'Avis introuvable.'
            ], 404);
        }

        $avis->update([
            'visible' => $validated['visible'],
        ]);

        $avis->load([
            'membre:id,nom,prenom,email',
            'prestataire:id,nom,prenom,email',
            'annonce:id,titre'
        ]);

        return response()->json([
            'message' => 'Visibilité de l’avis mise à jour.',
            'data' => $avis
        ]);
    }

    public function paiements(Request $request)
{
    $verification = $this->verifierAdmin($request->user());

    if ($verification) {
        return $verification;
    }

    $search = trim($request->query('search', ''));
    $statut = $request->query('statut');

    $paiements = Paiement::with([
        'membre:id,nom,prenom,email,telephone',
        'reservation:id,annonce_id,membre_id,prestataire_id,statut,date_service',
        'reservation.annonce:id,titre,tarif,localisation',
        'reservation.prestataire:id,nom,prenom,email,telephone'
    ])
        ->when($statut !== null && $statut !== '', function ($query) use ($statut) {
            $query->where('statut', $statut);
        })
        ->when($search !== '', function ($query) use ($search) {
            $terms = preg_split('/\s+/', strtolower($search), -1, PREG_SPLIT_NO_EMPTY);

            $query->where(function ($q) use ($search, $terms) {
                $q->where('transaction_externe_id', 'like', '%' . $search . '%')
                    ->orWhere('methode', 'like', '%' . $search . '%')
                    ->orWhere('statut', 'like', '%' . $search . '%')
                    ->orWhere('montant', 'like', '%' . $search . '%')
                    ->orWhere('id', $search)
                    ->orWhere('reservation_id', $search)
                    ->orWhereHas('membre', function ($membreQuery) use ($search, $terms) {
                        $membreQuery->where('nom', 'like', '%' . $search . '%')
                            ->orWhere('prenom', 'like', '%' . $search . '%')
                            ->orWhere('email', 'like', '%' . $search . '%')
                            ->orWhere('telephone', 'like', '%' . $search . '%')
                            ->orWhere(function ($nameQuery) use ($terms) {
                                foreach ($terms as $term) {
                                    $nameQuery->where(function ($subQuery) use ($term) {
                                        $subQuery->where('nom', 'like', '%' . $term . '%')
                                            ->orWhere('prenom', 'like', '%' . $term . '%');
                                    });
                                }
                            });
                    })
                    ->orWhereHas('reservation.prestataire', function ($prestataireQuery) use ($search, $terms) {
                        $prestataireQuery->where('nom', 'like', '%' . $search . '%')
                            ->orWhere('prenom', 'like', '%' . $search . '%')
                            ->orWhere('email', 'like', '%' . $search . '%')
                            ->orWhere('telephone', 'like', '%' . $search . '%')
                            ->orWhere(function ($nameQuery) use ($terms) {
                                foreach ($terms as $term) {
                                    $nameQuery->where(function ($subQuery) use ($term) {
                                        $subQuery->where('nom', 'like', '%' . $term . '%')
                                            ->orWhere('prenom', 'like', '%' . $term . '%');
                                    });
                                }
                            });
                    })
                    ->orWhereHas('reservation.annonce', function ($annonceQuery) use ($search) {
                        $annonceQuery->where('titre', 'like', '%' . $search . '%')
                            ->orWhere('localisation', 'like', '%' . $search . '%');
                    });
            });
        })
        ->latest()
        ->paginate(20)
        ->appends($request->only('search', 'statut'));

    return response()->json($paiements);
}

    public function modifierStatutPaiement(Request $request, $id)
    {
        $verification = $this->verifierAdmin($request->user());

        if ($verification) {
            return $verification;
        }

        $validated = $request->validate([
            'statut' => 'required|in:en_attente,accepte,refuse,rembourse',
        ]);

        $paiement = Paiement::find($id);

        if (!$paiement) {
            return response()->json([
                'message' => 'Paiement introuvable.'
            ], 404);
        }

        $paiement->update([
            'statut' => $validated['statut'],
        ]);

        $paiement->load([
            'membre:id,nom,prenom,email',
            'reservation:id,annonce_id,membre_id,prestataire_id,statut,date_service',
            'reservation.annonce:id,titre,tarif,localisation'
        ]);

        return response()->json([
            'message' => 'Statut du paiement mis à jour.',
            'data' => $paiement
        ]);
    }


}
