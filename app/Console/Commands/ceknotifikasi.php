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
            $mulai = Carbon::parse($mou->tanggal_mulai);
            $berakhir = Carbon::parse($mou->tanggal_berakhir);
            $empatbulan = $berakhir->copy()->subMonths(4);
            $tigabulan = $berakhir->copy()->subMonths(3);
            $duabulan = $berakhir->copy()->subMonths(2);
            $satubulan = $berakhir->copy()->subMonths(1);

            if ($mulai->isSameDay($today)) {
                $this->simpanNotif("mou_start", "Mou {$mou->nomormou} dimulai hari ini.", $today);
            }
            if ($mulai->isSameDay($today)) {
                $this->simpanNotif("mou_end", "Mou {$mou->nomormou} berakhir hari ini.", $today);
            }
            if ($empatbulan->isSameDay($today)) {
                $this->simpanNotif("mou_reminder", "Mou {$mou->nomormou} akan berakhir 4 bulan lagi.", $today);
            }
            if ($tigabulan->isSameDay($today)) {
                $this->simpanNotif("mou_reminder", "Mou {$mou->nomormou} akan berakhir 3 bulan lagi.", $today);
            }
            if ($duabulan->isSameDay($today)) {
                $this->simpanNotif("mou_reminder", "Mou {$mou->nomormou} akan berakhir 2 bulan lagi.", $today);
            }
            if ($satubulan->isSameDay($today)) {
                $this->simpanNotif("mou_reminder", "Mou {$mou->nomormou} akan berakhir 1 bulan lagi.", $today);
            }
            
        }
        // $mous = DataMou::all();
        // foreach ($mous as $mou) {
        //     if (Carbon::parse($mou->tanggal_mulai)->isSameDay($today)) {
        //         $this->simpanNotif("mou_start", "MOU {$mou->nomormou} dimulai hari ini.", $today);
        //     }
        //     if (Carbon::parse($mou->tanggal_berakhir)->isSameDay($today)) {
        //         $this->simpanNotif("mou_end", "MOU {$mou->nomormou} berakhir hari ini.", $today);
        //     }
        // }

        // Cek data PKS

        $pkss = DataPks::all();
        foreach ($pkss as $pks) {
            $mulai = Carbon::parse($pks->tanggal_mulai);
            $berakhir = Carbon::parse($pks->tanggal_berakhir);
            $empatbulan = $berakhir->copy()->subMonths(4);
            $tigabulan = $berakhir->copy()->subMonths(3);
            $duabulan = $berakhir->copy()->subMonths(2);
            $satubulan = $berakhir->copy()->subMonths(1);

            if ($mulai->isSameDay($today)) {
                $this->simpanNotif("pks_start", "Pks {$pks->nomorpks} dimulai hari ini.", $today);
            }
            if ($mulai->isSameDay($today)) {
                $this->simpanNotif("pks_end", "Pks {$pks->nomorpks} berakhir hari ini.", $today);
            }
            if ($empatbulan->isSameDay($today)) {
                $this->simpanNotif("pks_reminder", "Pks {$pks->nomorpks} akan berakhir 4 bulan lagi.", $today);
            }
            if ($tigabulan->isSameDay($today)) {
                $this->simpanNotif("pks_reminder", "Pks {$pks->nomorpks} akan berakhir 3 bulan lagi.", $today);
            }
            if ($duabulan->isSameDay($today)) {
                $this->simpanNotif("pks_reminder", "Pks {$pks->nomorpks} akan berakhir 2 bulan lagi.", $today);
            }
            if ($satubulan->isSameDay($today)) {
                $this->simpanNotif("pks_reminder", "Pks {$pks->nomorpks} akan berakhir 1 bulan lagi.", $today);
            }
        }
        // $pksList = DataPks::all();
        // foreach ($pksList as $pks) {
        //     if (Carbon::parse($pks->tanggal_mulai)->isSameDay($today)) {
        //         $this->simpanNotif("pks_start", "PKS {$pks->nomorpks} dimulai hari ini.", $today);
        //     }
        //     if (Carbon::parse($pks->tanggal_berakhir)->isSameDay($today)) {
        //         $this->simpanNotif("pks_end", "PKS {$pks->nomorpks} berakhir hari ini.", $today);
        //     }
        // }

        return Command::SUCCESS;
    }

    protected function simpanNotif($type, $message, $tanggal)
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
