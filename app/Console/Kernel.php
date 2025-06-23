<?php

namespace App\Console;

use Illuminate\Console\Scheduling\Schedule;
use Illuminate\Foundation\Console\Kernel as ConsoleKernel;

class Kernel extends ConsoleKernel
{
    /**
     * Daftar perintah yang disediakan oleh aplikasi kamu.
     *
     * @var array
     */
    protected $commands = [
        // Tambahkan perintah artisan khusus di sini
        \App\Console\Commands\ceknotifikasi::class,
        \App\Console\Commands\MouPksStatus::class,
    ];

    /**
     * Tentukan jadwal tugas-tugas aplikasi.
     *
     * @param \Illuminate\Console\Scheduling\Schedule $schedule
     * @return void
     */
    protected function schedule(Schedule $schedule): void
    {
        $schedule->command('cek:notifikasi')->everyMinute();
        $schedule->command('status:update')->everyMinute();
        $schedule->call(function () {
            \Log::info('Tes jadwal closure berhasil: ' . now());
        })->everyMinute();
    }

    /**
     * Daftarkan perintah artisan untuk aplikasi.
     *
     * @return void
     */
    protected function commands()
    {
        $this->load(__DIR__.'/Commands');
    }
}
