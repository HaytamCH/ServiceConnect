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
        Schema::create('paiements', function (Blueprint $table) {
            $table->id();

            $table->foreignId('reservation_id')
                ->constrained('reservations')
                ->cascadeOnDelete();

            $table->foreignId('membre_id')
                ->constrained('users')
                ->cascadeOnDelete();

            $table->decimal('montant', 10, 2);
            $table->string('devise', 10)->default('EUR');

            $table->enum('methode', [
                'stripe',
                'paypal',
                'virement_bancaire'
            ]);

            $table->enum('statut', [
                'en_attente',
                'accepte',
                'refuse',
                'rembourse'
            ])->default('en_attente');

            $table->string('transaction_externe_id', 255)->nullable();

            $table->timestamps();

            $table->unique('reservation_id');
            $table->index('membre_id');
            $table->index('methode');
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
        Schema::dropIfExists('paiements');
    }
};
