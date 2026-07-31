<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Hash;
use Faker\Factory as Faker;

class ServiceConnectSeeder extends Seeder
{
    public function run()
    {
        if (app()->environment('production')) {
            throw new \LogicException(
                'ServiceConnectSeeder réinitialise toutes les données et ne peut pas être exécuté en production.'
            );
        }

        $faker = Faker::create('fr_BE');
        $now = now();

        DB::statement('SET FOREIGN_KEY_CHECKS=0;');

        DB::table('paiements')->truncate();
        DB::table('likes')->truncate();
        DB::table('avis')->truncate();
        DB::table('messages')->truncate();
        DB::table('reservations')->truncate();
        DB::table('disponibilites')->truncate();
        DB::table('annonces')->truncate();
        DB::table('categories')->truncate();
        DB::table('users')->truncate();

        DB::statement('SET FOREIGN_KEY_CHECKS=1;');

        /*
        |--------------------------------------------------------------------------
        | 1. Catégories
        |--------------------------------------------------------------------------
        */

        $categories = [
            ['nom' => 'Bricolage', 'description' => 'Petits travaux, montage de meubles, réparations et fixations.', 'active' => true],
            ['nom' => 'Nettoyage', 'description' => 'Nettoyage à domicile, entretien régulier et nettoyage ponctuel.', 'active' => true],
            ['nom' => 'Jardinage', 'description' => 'Tonte, taille de haies, entretien de jardin et plantations.', 'active' => true],
            ['nom' => 'Baby-sitting', 'description' => 'Garde d’enfants à domicile et aide ponctuelle aux familles.', 'active' => true],
            ['nom' => 'Informatique', 'description' => 'Aide informatique, installation, dépannage et configuration.', 'active' => true],
            ['nom' => 'Plomberie', 'description' => 'Petites réparations, robinetterie et interventions sanitaires.', 'active' => true],
            ['nom' => 'Électricité', 'description' => 'Installation de luminaires, prises, interrupteurs et petits dépannages.', 'active' => true],
            ['nom' => 'Aide à domicile', 'description' => 'Aide quotidienne, accompagnement et petits services à la personne.', 'active' => true],
        ];

        foreach ($categories as $categorie) {
            DB::table('categories')->insert(array_merge($categorie, [
                'created_at' => $now,
                'updated_at' => $now,
            ]));
        }

        /*
        |--------------------------------------------------------------------------
        | 2. Utilisateurs : membres, prestataires, administrateurs
        |--------------------------------------------------------------------------
        */

        $users = [];

        // Administrateurs
        $users[] = [
            'nom' => 'Admin',
            'prenom' => 'ServiceConnect',
            'email' => 'admin@serviceconnect.be',
            'password' => Hash::make('Password123!'),
            'telephone' => '+32 470 11 22 33',
            'role' => 'administrateur',
            'statut' => 'actif',
            'langue' => 'fr',
            'description_profil' => null,
            'localisation' => 'Bruxelles',
            'paiement_active' => false,
            'created_at' => $now,
            'updated_at' => $now,
        ];

        // Membres
        for ($i = 1; $i <= 70; $i++) {
            $users[] = [
                'nom' => $faker->lastName(),
                'prenom' => $faker->firstName(),
                'email' => 'membre' . $i . '@serviceconnect.test',
                'password' => Hash::make('Password123!'),
                'telephone' => '+32 4' . $faker->numerify('## ## ## ##'),
                'role' => 'membre',
                'statut' => $faker->randomElement(['actif', 'actif', 'actif', 'suspendu']),
                'langue' => 'fr',
                'description_profil' => null,
                'localisation' => $faker->randomElement(['Bruxelles', 'Ixelles', 'Schaerbeek', 'Anderlecht', 'Molenbeek-Saint-Jean', 'Uccle']),
                'paiement_active' => false,
                'created_at' => $now,
                'updated_at' => $now,
            ];
        }

        // Prestataires
        $metiers = [
            'bricoleur polyvalent',
            'technicien informatique',
            'jardinier',
            'aide ménagère',
            'plombier',
            'électricien',
            'baby-sitter',
            'aide à domicile',
        ];

        for ($i = 1; $i <= 40; $i++) {
            $metier = $faker->randomElement($metiers);

            $users[] = [
                'nom' => $faker->lastName(),
                'prenom' => $faker->firstName(),
                'email' => 'prestataire' . $i . '@serviceconnect.test',
                'password' => Hash::make('Password123!'),
                'telephone' => '+32 4' . $faker->numerify('## ## ## ##'),
                'role' => 'prestataire',
                'statut' => 'actif',
                'langue' => 'fr',
                'description_profil' => 'Prestataire spécialisé comme ' . $metier . ', disponible pour des interventions locales à Bruxelles et dans les communes voisines.',
                'localisation' => $faker->randomElement(['Bruxelles', 'Ixelles', 'Schaerbeek', 'Anderlecht', 'Uccle', 'Forest', 'Etterbeek']),
                'paiement_active' => $faker->boolean(70),
                'created_at' => $now,
                'updated_at' => $now,
            ];
        }

        DB::table('users')->insert($users);

        $membreIds = DB::table('users')->where('role', 'membre')->pluck('id')->toArray();
        $prestataireIds = DB::table('users')->where('role', 'prestataire')->pluck('id')->toArray();
        $categorieIds = DB::table('categories')->pluck('id')->toArray();

        /*
        |--------------------------------------------------------------------------
        | 3. Annonces
        |--------------------------------------------------------------------------
        */

        $titresParCategorie = [
            'Bricolage' => [
                'Montage de meuble à domicile',
                'Fixation d’étagères murales',
                'Petits travaux de réparation',
                'Installation de tringles et rideaux',
            ],
            'Nettoyage' => [
                'Nettoyage complet d’appartement',
                'Entretien régulier du logement',
                'Nettoyage après déménagement',
                'Nettoyage de vitres',
            ],
            'Jardinage' => [
                'Tonte de pelouse',
                'Taille de haies',
                'Entretien complet du jardin',
                'Nettoyage de terrasse',
            ],
            'Baby-sitting' => [
                'Garde d’enfants en soirée',
                'Baby-sitting après l’école',
                'Garde ponctuelle le week-end',
                'Accompagnement enfant à domicile',
            ],
            'Informatique' => [
                'Installation ordinateur et imprimante',
                'Dépannage informatique à domicile',
                'Configuration Wi-Fi',
                'Aide à l’utilisation du PC',
            ],
            'Plomberie' => [
                'Réparation de robinet',
                'Débouchage évier simple',
                'Remplacement flexible douche',
                'Petite intervention sanitaire',
            ],
            'Électricité' => [
                'Installation de luminaire',
                'Remplacement interrupteur',
                'Pose de prise électrique',
                'Petit dépannage électrique',
            ],
            'Aide à domicile' => [
                'Aide aux courses',
                'Accompagnement rendez-vous',
                'Aide administrative simple',
                'Petits services quotidiens',
            ],
        ];

        $categoriesDb = DB::table('categories')->get();

        for ($i = 1; $i <= 120; $i++) {
            $categorie = $categoriesDb->random();
            $titre = $faker->randomElement($titresParCategorie[$categorie->nom]);

            DB::table('annonces')->insert([
                'prestataire_id' => $faker->randomElement($prestataireIds),
                'categorie_id' => $categorie->id,
                'titre' => $titre,
                'description' => $titre . '. Service proposé à domicile avec soin, ponctualité et matériel adapté selon la demande du client.',
                'tarif' => $faker->randomFloat(2, 18, 55),
                'localisation' => $faker->randomElement(['Bruxelles', 'Ixelles', 'Schaerbeek', 'Anderlecht', 'Uccle', 'Forest', 'Etterbeek']),
                'statut' => $faker->randomElement(['publiee', 'publiee', 'publiee', 'en_attente', 'suspendue']),
                'created_at' => $now,
                'updated_at' => $now,
            ]);
        }

        $annonces = DB::table('annonces')->get();
        $annonceIds = $annonces->pluck('id')->toArray();

        /*
        |--------------------------------------------------------------------------
        | 4. Disponibilités
        |--------------------------------------------------------------------------
        */

        foreach ($annonceIds as $annonceId) {
            for ($i = 1; $i <= 2; $i++) {
                $dateDebut = $faker->dateTimeBetween('+1 day', '+45 days');
                $dateFin = (clone $dateDebut)->modify('+2 hours');

                DB::table('disponibilites')->insert([
                    'annonce_id' => $annonceId,
                    'date_debut' => $dateDebut,
                    'date_fin' => $dateFin,
                    'disponible' => $faker->boolean(80),
                    'created_at' => $now,
                    'updated_at' => $now,
                ]);
            }
        }

        $disponibilites = DB::table('disponibilites')->get();

        /*
        |--------------------------------------------------------------------------
        | 5. Réservations
        |--------------------------------------------------------------------------
        */

        for ($i = 1; $i <= 120; $i++) {
            $disponibilite = $disponibilites->random();
            $annonce = DB::table('annonces')->where('id', $disponibilite->annonce_id)->first();

            DB::table('reservations')->insert([
                'membre_id' => $faker->randomElement($membreIds),
                'annonce_id' => $annonce->id,
                'prestataire_id' => $annonce->prestataire_id,
                'disponibilite_id' => $disponibilite->id,
                'date_demande' => $faker->dateTimeBetween('-30 days', 'now'),
                'date_service' => $disponibilite->date_debut,
                'message_demande' => $faker->randomElement([
                    'Bonjour, je souhaite réserver ce service pour le créneau indiqué.',
                    'Pouvez-vous confirmer votre disponibilité pour cette intervention ?',
                    'J’aurais besoin de ce service à domicile. Merci d’avance.',
                    'La demande concerne une intervention simple à Bruxelles.',
                ]),
                'statut' => $faker->randomElement([
                    'en_attente',
                    'acceptee',
                    'refusee',
                    'alternative_proposee',
                    'annulee',
                    'terminee',
                ]),
                'created_at' => $now,
                'updated_at' => $now,
            ]);
        }

        $reservations = DB::table('reservations')->get();
        $reservationIds = $reservations->pluck('id')->toArray();

        /*
        |--------------------------------------------------------------------------
        | 6. Messages
        |--------------------------------------------------------------------------
        */

        for ($i = 1; $i <= 150; $i++) {
            $reservation = $reservations->random();

            $expediteurId = $faker->randomElement([$reservation->membre_id, $reservation->prestataire_id]);
            $destinataireId = $expediteurId == $reservation->membre_id
                ? $reservation->prestataire_id
                : $reservation->membre_id;

            DB::table('messages')->insert([
                'expediteur_id' => $expediteurId,
                'destinataire_id' => $destinataireId,
                'reservation_id' => $reservation->id,
                'contenu' => $faker->randomElement([
                    'Bonjour, pouvez-vous me confirmer le créneau prévu ?',
                    'Je vous confirme ma disponibilité pour cette intervention.',
                    'Pouvez-vous préciser l’adresse exacte de l’intervention ?',
                    'Merci pour votre retour, cela me convient.',
                    'Je vous propose un autre créneau si nécessaire.',
                ]),
                'lu' => $faker->boolean(70),
                'created_at' => $now,
                'updated_at' => $now,
            ]);
        }

        /*
        |--------------------------------------------------------------------------
        | 7. Avis
        |--------------------------------------------------------------------------
        */

        $reservationsTerminees = DB::table('reservations')
            ->whereIn('statut', ['terminee', 'acceptee'])
            ->get();

        for ($i = 1; $i <= 100; $i++) {
            $reservation = $reservationsTerminees->count() > 0
                ? $reservationsTerminees->random()
                : $reservations->random();

            DB::table('avis')->insert([
                'membre_id' => $reservation->membre_id,
                'prestataire_id' => $reservation->prestataire_id,
                'annonce_id' => $reservation->annonce_id,
                'reservation_id' => $reservation->id,
                'note' => $faker->numberBetween(3, 5),
                'commentaire' => $faker->randomElement([
                    'Service sérieux et intervention rapide.',
                    'Prestataire ponctuel et travail bien réalisé.',
                    'Bonne communication et résultat conforme à la demande.',
                    'Je recommande ce prestataire pour ce type de service.',
                    'Intervention correcte et professionnelle.',
                ]),
                'visible' => $faker->boolean(90),
                'created_at' => $now,
                'updated_at' => $now,
            ]);
        }

        /*
        |--------------------------------------------------------------------------
        | 8. Likes
        |--------------------------------------------------------------------------
        */

        $pairsAnnonce = [];
        $pairsPrestataire = [];

        while (count($pairsAnnonce) < 80) {
            $membreId = $faker->randomElement($membreIds);
            $annonceId = $faker->randomElement($annonceIds);
            $key = $membreId . '-' . $annonceId;

            if (!isset($pairsAnnonce[$key])) {
                $pairsAnnonce[$key] = true;

                DB::table('likes')->insert([
                    'membre_id' => $membreId,
                    'annonce_id' => $annonceId,
                    'prestataire_id' => null,
                    'type_cible' => 'annonce',
                    'created_at' => $now,
                    'updated_at' => $now,
                ]);
            }
        }

        while (count($pairsPrestataire) < 70) {
            $membreId = $faker->randomElement($membreIds);
            $prestataireId = $faker->randomElement($prestataireIds);
            $key = $membreId . '-' . $prestataireId;

            if (!isset($pairsPrestataire[$key])) {
                $pairsPrestataire[$key] = true;

                DB::table('likes')->insert([
                    'membre_id' => $membreId,
                    'annonce_id' => null,
                    'prestataire_id' => $prestataireId,
                    'type_cible' => 'prestataire',
                    'created_at' => $now,
                    'updated_at' => $now,
                ]);
            }
        }

        /*
        |--------------------------------------------------------------------------
        | 9. Paiements
        |--------------------------------------------------------------------------
        */

        $reservationsPourPaiement = $reservations->take(100);

        foreach ($reservationsPourPaiement as $reservation) {
            $annonce = DB::table('annonces')->where('id', $reservation->annonce_id)->first();

            DB::table('paiements')->insert([
                'reservation_id' => $reservation->id,
                'membre_id' => $reservation->membre_id,
                'montant' => $annonce->tarif ?? $faker->randomFloat(2, 20, 80),
                'devise' => 'EUR',
                'methode' => $faker->randomElement(['stripe', 'paypal', 'virement_bancaire']),
                'statut' => $faker->randomElement(['en_attente', 'accepte', 'refuse', 'rembourse']),
                'transaction_externe_id' => 'TX-SC-' . strtoupper($faker->bothify('####??##')),
                'created_at' => $now,
                'updated_at' => $now,
            ]);
        }
    }
}
