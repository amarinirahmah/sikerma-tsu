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
        Schema::create('pkl', function (Blueprint $table) {
            $table->id();
            $table->foreignId('user_id')->constrained('user')->onDelete('cascade');
            $table->string('nisn')->unique();
            $table->string('sekolah');
            $table->string('nama');
            $table->enum('gender',['laki-laki', 'perempuan']);
            $table->date('tanggal_mulai');
            $table->date('tanggal_berakhir');
            $table->string('file_pkl')->nullable();
            $table->string('telpemail');
            $table->string('alamat');
            $table->enum('status',['Diproses','Disetujui','Ditolak'])->default('Diproses');
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('pkl');
    }
};
