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
        Schema::create('reservations', function (Blueprint $table) {
            $table->id();

            $table->foreignId('membre_id')
                ->constrained('users')
                ->cascadeOnDelete();

            $table->foreignId('annonce_id')
                ->constrained('annonces')
                ->cascadeOnDelete();

            $table->foreignId('prestataire_id')
                ->constrained('users')
                ->cascadeOnDelete();

            $table->foreignId('disponibilite_id')
                ->nullable()
                ->constrained('disponibilites')
                ->nullOnDelete();

            $table->dateTime('date_demande');
            $table->dateTime('date_service')->nullable();
            $table->text('message_demande')->nullable();

            $table->enum('statut', [
                'en_attente',
                'acceptee',
                'refusee',
                'alternative_proposee',
                'annulee',
                'terminee'
            ])->default('en_attente');

            $table->timestamps();

            $table->index('membre_id');
            $table->index('prestataire_id');
            $table->index('annonce_id');
            $table->index('statut');
        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::dropIfExists('reservations');
    }
};
