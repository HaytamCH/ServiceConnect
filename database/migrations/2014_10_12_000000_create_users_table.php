<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('users', function (Blueprint $table) {
            $table->id();

            $table->string('nom', 100);
            $table->string('prenom', 100);
            $table->string('email', 150)->unique();
            $table->timestamp('email_verified_at')->nullable();
            $table->string('password');

            $table->string('telephone', 30)->nullable();

            $table->enum('role', [
                'membre',
                'prestataire',
                'administrateur'
            ])->default('membre');

            $table->enum('statut', [
                'actif',
                'desactive',
                'suspendu'
            ])->default('actif');

            $table->string('langue', 10)->default('fr');

            // Champs surtout utiles pour les prestataires
            $table->text('description_profil')->nullable();
            $table->string('localisation', 255)->nullable();
            $table->boolean('paiement_active')->default(false);

            $table->rememberToken();
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::dropIfExists('users');
    }
};
