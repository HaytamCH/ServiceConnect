<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up()
    {
        Schema::create('user_notifications', function (Blueprint $table) {
            $table->id();

            $table->foreignId('user_id')
                ->constrained('users')
                ->cascadeOnDelete();

            $table->string('type', 100);
            $table->string('titre', 255);
            $table->text('message')->nullable();
            $table->string('lien', 255)->nullable();

            $table->string('related_type', 100)->nullable();
            $table->unsignedBigInteger('related_id')->nullable();

            $table->boolean('lu')->default(false);
            $table->timestamp('read_at')->nullable();

            $table->json('data')->nullable();

            $table->timestamps();

            $table->index(['user_id', 'lu']);
            $table->index(['user_id', 'type']);
            $table->index(['related_type', 'related_id']);
        });
    }

    public function down()
    {
        Schema::dropIfExists('user_notifications');
    }
};
