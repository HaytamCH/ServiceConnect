<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up()
    {
        Schema::table('users', function (Blueprint $table) {
            $table->enum('demande_prestataire_statut', [
                'aucune',
                'en_attente',
                'acceptee',
                'refusee'
            ])->default('aucune')->after('paiement_active');

            $table->text('demande_prestataire_description')->nullable()->after('demande_prestataire_statut');
            $table->string('demande_prestataire_localisation', 255)->nullable()->after('demande_prestataire_description');
            $table->string('demande_prestataire_telephone', 30)->nullable()->after('demande_prestataire_localisation');
            $table->timestamp('demande_prestataire_date')->nullable()->after('demande_prestataire_telephone');
            $table->timestamp('demande_prestataire_decision_at')->nullable()->after('demande_prestataire_date');
        });
    }

    public function down()
    {
        Schema::table('users', function (Blueprint $table) {
            $table->dropColumn([
                'demande_prestataire_statut',
                'demande_prestataire_description',
                'demande_prestataire_localisation',
                'demande_prestataire_telephone',
                'demande_prestataire_date',
                'demande_prestataire_decision_at',
            ]);
        });
    }
};
