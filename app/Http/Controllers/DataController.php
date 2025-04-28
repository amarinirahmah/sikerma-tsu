<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;

class DataController extends Controller
{
    public function uploadmou(Request $request)
    {
        $request->validate([
            'nomormou' => 'required',
            'nama' => 'required',
            'judul' => 'required',
            'tanggal_mulai' => 'required|date',
            'tanggal_berakhir' => 'required|date',
            'file_mou' => 'nullable|file|mimes:pdf,doc,docs,jpg,jpeg|max:5120',
        ]);

        $filePath = null;
        $fileType = null;

        if ($request->hasFile('file_mou')) {
            $file = $request->file('file_mou');
            $filePath = $file->store('mou_files', 'public');
            // $fileType = $file->getClientMimeType();
        }

        DataMou::create([
            'nomor' => $request->nomor,
            'nama' => $request->nama,
            'judul' => $request->judul,
            'tanggal_mulai' => $request->tanggal_mulai,
            'tanggal_berakhir' => $request->tanggal_berakhir,
            'file_mou' => $filePath,
            // 'file_type' => $fileType,
        ]);
    }

    public function uploadpks(Request $request)
    {
        $request->validate([
            'nomormou' => 'required',
            'nomorpks' => 'required',
            'judul' => 'required',
            'tanggal_mulai' => 'required|date',
            'tanggal_berakhir' => 'required|date',
            'namaunit' => 'required',
            'file_mou' => 'nullable|file|mimes:pdf,doc,docs,jpg,jpeg|max:5120',
            'tujuan' => 'required',
        ]);
    }
}
