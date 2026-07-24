<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up()
    {
        Schema::create('demande_categories', function (Blueprint $table) {
            $table->id();

            $table->foreignId('prestataire_id')
                ->constrained('users')
                ->cascadeOnDelete();

            $table->string('nom', 100);
            $table->text('description')->nullable();

            $table->enum('statut', [
                'en_attente',
                'acceptee',
                'refusee',
            ])->default('en_attente');

            $table->foreignId('categorie_id')
                ->nullable()
                ->constrained('categories')
                ->nullOnDelete();

            $table->text('motif_refus')->nullable();

            $table->timestamps();

            $table->index('prestataire_id');
            $table->index('statut');
            $table->index('categorie_id');
        });
    }

    public function down()
    {
        Schema::dropIfExists('demande_categories');
    }
};
