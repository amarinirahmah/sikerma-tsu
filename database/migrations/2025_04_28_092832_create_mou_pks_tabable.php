<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('mou_pks', function (Blueprint $table) {
            $table->id();
            $table->foreignId('mou_id')->constrained('data_mous')->onDelete('cascade');
            $table->foreignId('pks_id')->constrained('data_pks')->onDelete('cascade');
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('mou_pks');
    }
};
