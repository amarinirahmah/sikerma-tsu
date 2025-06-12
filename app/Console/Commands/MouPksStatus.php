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
        $today = Carbon::today();

        //Update MOU
        Datamou::all()->each(function ($mou) use ($today) {
            if (
                $mou->keterangan === 'Disetujui' &&
                $mou->tanggal_mulai <= $today &&
                $mou->tanggal_berakhir >= $today
            ) {
                $status = 'Aktif';
            } else {
                $status = 'Tidak Aktif';
            }

            $mou->update(['status' => $status]);
        });
        //Update PKS
        DataPks::all()->each(function ($pks) use ($today) {
            if (
                $pks->keterangan === 'Disetujui' &&
                $pks->tanggal_mulai <= $today &&
                $pks->tanggal_berakhir >= $today
            ) {
                $status = 'Aktif';
            } else {
                $status = 'Tidak Aktif';
            }

            $pks->update(['status' => $status]);
        });

        $this->info('Status MOU dan PKS berhasil diperbarui berdasarkan tanggal dan keterangan');
    }

    //Fungsi Auto Scheduling
    public function schedule(Schedule $schedule): void
    {
        $schedule->command(static::class)->everyMinute();
    }
}
