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
        Schema::create('messages', function (Blueprint $table) {
            $table->id();

            $table->foreignId('expediteur_id')
                ->constrained('users')
                ->cascadeOnDelete();

            $table->foreignId('destinataire_id')
                ->constrained('users')
                ->cascadeOnDelete();

            $table->foreignId('reservation_id')
                ->nullable()
                ->constrained('reservations')
                ->nullOnDelete();

            $table->text('contenu');
            $table->boolean('lu')->default(false);

            $table->timestamps();

            $table->index('expediteur_id');
            $table->index('destinataire_id');
            $table->index('reservation_id');
            $table->index('lu');
        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::dropIfExists('messages');
    }
};
