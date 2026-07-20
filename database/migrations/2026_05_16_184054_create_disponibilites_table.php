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
        Schema::create('disponibilites', function (Blueprint $table) {
            $table->id();

            $table->foreignId('annonce_id')
                ->constrained('annonces')
                ->cascadeOnDelete();

            $table->dateTime('date_debut');
            $table->dateTime('date_fin');
            $table->boolean('disponible')->default(true);

            $table->timestamps();

            $table->index('annonce_id');
            $table->index('date_debut');
            $table->index('date_fin');
        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::dropIfExists('disponibilites');
    }
};
