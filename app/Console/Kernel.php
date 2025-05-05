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
    ];

    /**
     * Tentukan jadwal tugas-tugas aplikasi.
     *
     * @param \Illuminate\Console\Scheduling\Schedule $schedule
     * @return void
     */
    protected function schedule(Schedule $schedule): void
    {
        // Jadwalkan tugas yang ingin kamu jalankan, contoh:
        $schedule->command('check:mou-pks-notification')->everyMinute();
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
