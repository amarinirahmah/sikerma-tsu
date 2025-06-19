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

    // public function handle(): void
    // {
    //     $today = Carbon::today();

    //     // Update MOU
    //     DataMou::all()->each(function ($mou) use ($today) {
    //         $status = ($mou->tanggal_mulai <= $today && $mou->tanggal_berakhir >= $today) ? 'Aktif' : 'Tidak Aktif';
    //         $mou->update(['status' => $status]);
    //     });

    //     // Update PKS
    //     DataPks::all()->each(function ($pks) use ($today) {
    //         $status = ($pks->tanggal_mulai <= $today && $pks->tanggal_berakhir >= $today) ? 'Aktif' : 'Tidak Aktif';
    //         $pks->update(['status' => $status]);
    //     });

    //     $this->info('Status MOU dan PKS berhasil diperbarui.');
    // }

    public function handle(): void
    {
        \Log::info('Command berhasil dijalankan pada ' . now());
        $today = Carbon::today();

        //Update MOU
        Datamou::all()->each(function ($mou) use ($today) {
            $status = $this->determineStatus($mou, $today);
            $mou->update(['status' => $status]);
        });
        //Update PKS
        DataPks::all()->each(function ($pks) use ($today) {
            $status = $this->determineStatus($pks, $today);
            $pks->update(['status' => $status]);
        });

        $this->info('Status MOU dan PKS berhasil diperbarui');
    }

    protected function determineStatus($document, Carbon $today): string
    {
        //Jika dibatalkan
        if ($document->keterangan === 'Dibatalkan') {
            return 'Tidak Aktif';
        }

        //Jika disetujui
        if ($document->keterangan === 'Disetujui') {
            if ($document->tanggal_mulai <= $today && $document->tanggal_berakhir >= $today) {
                return 'Aktif';
            }
            //Jika tanggal berakhir
            if ($document->tanggal_berakhir < $today) {
                return 'Kadaluarsa';
            }
        }
        //Default
        return 'Draft';
    }

    //Fungsi Auto Scheduling
    // public function schedule(Schedule $schedule): void
    // {
    //     $schedule->command(static::class)->daily();
    // }
}
