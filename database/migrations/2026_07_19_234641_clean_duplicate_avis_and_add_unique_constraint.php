<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up()
    {
        $duplicates = DB::table('avis')
            ->select('membre_id', 'reservation_id', DB::raw('MIN(id) as keep_id'))
            ->whereNotNull('reservation_id')
            ->groupBy('membre_id', 'reservation_id')
            ->havingRaw('COUNT(*) > 1')
            ->get();

        foreach ($duplicates as $duplicate) {
            DB::table('avis')
                ->where('membre_id', $duplicate->membre_id)
                ->where('reservation_id', $duplicate->reservation_id)
                ->where('id', '!=', $duplicate->keep_id)
                ->delete();
        }

        Schema::table('avis', function (Blueprint $table) {
            $table->unique(['membre_id', 'reservation_id'], 'avis_membre_reservation_unique');
        });
    }

    public function down()
    {
        Schema::table('avis', function (Blueprint $table) {
            $table->dropUnique('avis_membre_reservation_unique');
        });
    }
};
