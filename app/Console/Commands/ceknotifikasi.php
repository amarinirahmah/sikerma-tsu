<?php

namespace App\Console\Commands;

use Illuminate\Console\Command;
use App\Models\DataMou;
use App\Models\DataPks;
use App\Models\Notifikasi;
use Carbon\Carbon;

class ceknotifikasi extends Command
{
    /**
     * The name and signature of the console command.
     *
     * @var string
     */
    protected $signature = 'cek:notifikasi';

    /**
     * The console command description.
     *
     * @var string
     */
    protected $description = 'Cek status MOU dan PKS';

    /**
     * Execute the console command.
     */
    public function handle()
    {
        $today = Carbon::today();

        // Cek data MOU
        $mous = DataMou::all();
        foreach ($mous as $mou) {
            if (Carbon::parse($mou->tanggal_mulai)->isSameDay($today)) {
                $this->simpanNotif("mou_start", "MOU {$mou->nomormou} dimulai hari ini.", $today);
            }
            if (Carbon::parse($mou->tanggal_berakhir)->isSameDay($today)) {
                $this->simpanNotif("mou_end", "MOU {$mou->nomormou} berakhir hari ini.", $today);
            }
        }

        // Cek data PKS
        $pksList = DataPks::all();
        foreach ($pksList as $pks) {
            if (Carbon::parse($pks->tanggal_mulai)->isSameDay($today)) {
                $this->simpanNotif("pks_start", "PKS {$pks->nomorpks} dimulai hari ini.", $today);
            }
            if (Carbon::parse($pks->tanggal_berakhir)->isSameDay($today)) {
                $this->simpanNotif("pks_end", "PKS {$pks->nomorpks} berakhir hari ini.", $today);
            }
        }

        return Command::SUCCESS;
    }

    protected function simpannotif($type, $message, $tanggal)
    {
        Notifikasi::firstOrCreate([
            'type' => $type,
            'message' => $message,
            'tanggal_notif' => $tanggal,
        ]);
    }

    protected function schedule(Schedule $schedule)
    {
        // Jadwalkan tugas yang ingin kamu jalankan, contoh:
        $schedule->command('cek:notifikasi')->everyMinute();
    }
}
