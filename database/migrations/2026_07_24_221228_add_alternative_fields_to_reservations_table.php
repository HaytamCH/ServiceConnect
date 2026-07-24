<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up()
    {
        Schema::table('reservations', function (Blueprint $table) {
            $table->dateTime('date_alternative_debut')->nullable()->after('date_service');
            $table->dateTime('date_alternative_fin')->nullable()->after('date_alternative_debut');
            $table->text('message_alternative')->nullable()->after('message_demande');
        });
    }

    public function down()
    {
        Schema::table('reservations', function (Blueprint $table) {
            $table->dropColumn([
                'date_alternative_debut',
                'date_alternative_fin',
                'message_alternative',
            ]);
        });
    }
};
