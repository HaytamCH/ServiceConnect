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
        Schema::create('likes', function (Blueprint $table) {
            $table->id();

            $table->foreignId('membre_id')
                ->constrained('users')
                ->cascadeOnDelete();

            $table->foreignId('annonce_id')
                ->nullable()
                ->constrained('annonces')
                ->cascadeOnDelete();

            $table->foreignId('prestataire_id')
                ->nullable()
                ->constrained('users')
                ->cascadeOnDelete();

            $table->enum('type_cible', [
                'annonce',
                'prestataire'
            ]);

            $table->timestamps();

            $table->index('membre_id');
            $table->index('annonce_id');
            $table->index('prestataire_id');
            $table->index('type_cible');

            $table->unique(['membre_id', 'annonce_id']);
            $table->unique(['membre_id', 'prestataire_id']);
        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::dropIfExists('likes');
    }
};
