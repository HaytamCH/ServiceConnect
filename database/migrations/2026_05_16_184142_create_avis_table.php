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
        Schema::create('avis', function (Blueprint $table) {
            $table->id();

            $table->foreignId('membre_id')
                ->constrained('users')
                ->cascadeOnDelete();

            $table->foreignId('prestataire_id')
                ->constrained('users')
                ->cascadeOnDelete();

            $table->foreignId('annonce_id')
                ->constrained('annonces')
                ->cascadeOnDelete();

            $table->foreignId('reservation_id')
                ->nullable()
                ->constrained('reservations')
                ->nullOnDelete();

            $table->unsignedTinyInteger('note');
            $table->text('commentaire')->nullable();
            $table->boolean('visible')->default(true);

            $table->timestamps();

            $table->index('membre_id');
            $table->index('prestataire_id');
            $table->index('annonce_id');
            $table->index('reservation_id');
            $table->index('visible');
        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::dropIfExists('avis');
    }
};
