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
        Schema::create('data_mous', function (Blueprint $table) {
            $table->id();
            $table->string('nomormou');
            $table->string('nomormou2');
            $table->string('nama');
            $table->string('judul');
            $table->date('tanggal_mulai');
            $table->date('tanggal_berakhir');
            $table->string('file_mou')->nullable();
            $table->string('ruanglingkup');
            $table->json('pihak1');
            $table->json('pihak2');
            $table->enum('status', ['Aktif', 'Tidak Aktif'])->default('Tidak Aktif');
            $table->enum('keterangan',['Diajukan','Disetujui','Dibatalkan'])->default('Diajukan');
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('data_mous');
    }
};
