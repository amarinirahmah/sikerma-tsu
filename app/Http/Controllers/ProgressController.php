<?php

namespace App\Http\Controllers;

use App\Models\DataMou;
use Illuminate\Http\Request;

class ProgressController extends Controller
{
    public function addProgress(Request $request, $id)
    {
        $request->validate([
            'tanggal' => 'required|date',
            'proses' => 'required|in:PembuatanDraft,PengajuanDraft,PenyerahanMOU',
            'aktivitas' => 'required|string|max:255',
        ]);

        $mou = DataMou::findOrFail($id);

        $progress = $mou->progress()->create([
            'tanggal' => $request->tanggal,
            'proses' => $requrest->proses,
            'aktivitas' => $request->aktivitas,
        ]);

        return response()->json([
            'message' => 'progress berhasil ditambahkan',
            'data' => $progress,
        ]);
    }
}
