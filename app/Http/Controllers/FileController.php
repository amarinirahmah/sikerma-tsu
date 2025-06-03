<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Storage;

class FileController extends Controller
{
    public function download($filename)
    {
        $filepath = 'public/' . $filename;

        if (!Storage::exists($filepath)) {
            return response()->json(['error' => 'File tidak ditemukan'], 404);
        }

        return Storage::download($filepath);
    }
}
