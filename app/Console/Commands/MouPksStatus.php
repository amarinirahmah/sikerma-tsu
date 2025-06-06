<?php

namespace App\Console\Commands;

use Illuminate\Console\Command;
use App\Models\DataMou;
use App\Models\DataPks;
use Carbon\Carbon;

class MouPksStatus extends Command
{
    protected $signature = 'status:update';
    protected $description = 'Update status MOU dan PKS berdasarkan tanggal mulai dan berakhir';

    public function handle(): void
    {
        $today = Carbon::today();

        // Update MOU
        DataMou::all()->each(function ($mou) use ($today) {
            $status = ($mou->tanggal_mulai <= $today && $mou->tanggal_berakhir >= $today) ? 'aktif' : 'tidak aktif';
            $mou->update(['status' => $status]);
        });

        // Update PKS
        DataPks::all()->each(function ($pks) use ($today) {
            $status = ($pks->tanggal_mulai <= $today && $pks->tanggal_berakhir >= $today) ? 'aktif' : 'tidak aktif';
            $pks->update(['status' => $status]);
        });

        $this->info('Status MOU dan PKS berhasil diperbarui.');
    }

//     protected function schedule(Schedule $schedule)
//     {
//         // Jadwalkan tugas yang ingin kamu jalankan, contoh:
//         $schedule->command('status:update')->everyMinute();
//     }
}
