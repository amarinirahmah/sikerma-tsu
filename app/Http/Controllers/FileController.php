<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Storage;

class FileController extends Controller
{
    public function download($filename)
    {
        try {
            $allowedFolders = ['mou_files', 'pks_files', 'pkl_files'];

            if (!in_array($folder, $allowedFolders)) {
                return response()->json(['error' => 'Folder tidak diizinkan'], 403);
            }

            $filepath = "public/{$filename}";

            if (!Storage::exists($filepath)) {
                return response()->json(['error' => 'File tidak ditemukan'], 404);
            }

            return Storage::download($filepath);
        } catch (\Exception $e) {
            Log::error('File download error: ' . $e->getMessage());
            return response()->json(['error' => 'Terjadi kesalahan server'], 500);
        }
    }
}
