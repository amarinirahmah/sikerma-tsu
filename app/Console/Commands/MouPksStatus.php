<?php

namespace App\Console\Commands;

use Illuminate\Console\Command;
use App\Models\Mou;
use App\Models\Pks;
use Carbon\Carbon;

class UpdateMouPksStatus extends Command
{
    protected $signature = 'status:update';
    protected $description = 'Update status MOU dan PKS berdasarkan tanggal mulai dan berakhir';

    public function handle(): void
    {
        $today = Carbon::today();

        // Update MOU
        Mou::all()->each(function ($mou) use ($today) {
            $status = ($mou->tanggal_mulai <= $today && $mou->tanggal_berakhir >= $today) ? 'aktif' : 'tidak aktif';
            $mou->update(['status' => $status]);
        });

        // Update PKS
        Pks::all()->each(function ($pks) use ($today) {
            $status = ($pks->tanggal_mulai <= $today && $pks->tanggal_berakhir >= $today) ? 'aktif' : 'tidak aktif';
            $pks->update(['status' => $status]);
        });

        $this->info('Status MOU dan PKS berhasil diperbarui.');
    }
}
