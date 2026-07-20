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
        Schema::create('annonces', function (Blueprint $table) {
            $table->id();

            $table->foreignId('prestataire_id')
                ->constrained('users')
                ->cascadeOnDelete();

            $table->foreignId('categorie_id')
                ->constrained('categories')
                ->restrictOnDelete();

            $table->string('titre', 150);
            $table->text('description');
            $table->decimal('tarif', 10, 2)->nullable();
            $table->string('localisation', 255)->nullable();

            $table->enum('statut', [
                'brouillon',
                'en_attente',
                'publiee',
                'suspendue',
                'supprimee'
            ])->default('en_attente');

            $table->timestamps();

            $table->index('prestataire_id');
            $table->index('categorie_id');
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
        Schema::dropIfExists('annonces');
    }
};
