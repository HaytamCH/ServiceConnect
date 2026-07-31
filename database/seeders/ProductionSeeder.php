<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;

class ProductionSeeder extends Seeder
{
    /**
     * Create only the reference data required by the application.
     *
     * This seeder is deliberately idempotent: it never truncates a table and
     * never replaces the demonstration data imported from the SQL dump.
     */
    public function run(): void
    {
        $categories = [
            ['nom' => 'Bricolage', 'description' => 'Petits travaux, montage de meubles, réparations et fixations.'],
            ['nom' => 'Nettoyage', 'description' => 'Nettoyage à domicile, entretien régulier et nettoyage ponctuel.'],
            ['nom' => 'Jardinage', 'description' => 'Tonte, taille de haies, entretien de jardin et plantations.'],
            ['nom' => 'Baby-sitting', 'description' => 'Garde d’enfants à domicile et aide ponctuelle aux familles.'],
            ['nom' => 'Informatique', 'description' => 'Aide informatique, installation, dépannage et configuration.'],
            ['nom' => 'Plomberie', 'description' => 'Petites réparations, robinetterie et interventions sanitaires.'],
            ['nom' => 'Électricité', 'description' => 'Installation de luminaires, prises, interrupteurs et petits dépannages.'],
            ['nom' => 'Aide à domicile', 'description' => 'Aide quotidienne, accompagnement et petits services à la personne.'],
        ];

        if (DB::table('categories')->exists()) {
            return;
        }

        $now = now();

        DB::table('categories')->insert(array_map(
            fn (array $category): array => [
                ...$category,
                'active' => true,
                'created_at' => $now,
                'updated_at' => $now,
            ],
            $categories,
        ));
    }
}
