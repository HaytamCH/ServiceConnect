<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up()
    {
        Schema::table('messages', function (Blueprint $table) {
            $table->foreignId('annonce_id')
                ->nullable()
                ->after('reservation_id')
                ->constrained('annonces')
                ->nullOnDelete();

            $table->index('annonce_id');
        });
    }

    public function down()
    {
        Schema::table('messages', function (Blueprint $table) {
            $table->dropConstrainedForeignId('annonce_id');
        });
    }
};
