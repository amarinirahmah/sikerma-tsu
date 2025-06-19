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
        Schema::create('detail_progress', function (Blueprint $table) {
            $table->id();
            $table->foreignId('data_mou_id')->constrained()->onDelete('cascade');
            $table->date('tanggal');
            $table->enum('proses',['DraftBiro','PembuatanDraft', 'PengajuanPihak1', 'PengajuanPihak2', 'PenyerahanMOU'])->defualt('Pembuatan Draft');
            $table->string('aktivitas');
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('detail_progress');
    }
};
