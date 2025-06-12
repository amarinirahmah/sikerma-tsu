<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Storage;

class FileController extends Controller
{
    public function download($folder, $filename)
    {
        try {
            $allowedFolders = ['mou_files', 'pks_files', 'pkl_files'];

            if (!in_array($folder, $allowedFolders)) {
                return response()->json(['error' => 'Folder tidak diizinkan'], 403);
            }

            $filepath = "$folder/$filename";

            if (!Storage::disk('public')->exists($filepath)) {
                // return Storage::disk('public')->download($filepath);
                return response()->json(['error' => 'File tidak ditemukan'], 404);

            }

            $model = match ($folder) {
                'mou_files' => \App\Models\DataMou::class,
                'pks_files' => \App\Models\DataPks::class,
                'pkl_files' => \App\Models\pkl::class,
                default => null,
            };

            if (!$model) {
                return response()->json(['error' => 'Model tidak ditemukan'], 404);
            }

            $fileField = match ($folder) {
                'mou_files' => 'file_mou',
                'pks_files' => 'file_pks',
                'pkl_files' => 'file_pkl',
            };

            $record = $model::where($fileField, $filepath)->first();

            $realName = $record->file_name ?? $filename;
            
            return Storage::disk('public')->download($filepath, $realName);

        } catch (\Exception $e) {
            \Log::error('File download error: ' . $e->getMessage());
            return response()->json(['error' => 'Terjadi kesalahan server'], 500);
        }
    }
    // public function download($filename)
    // {
    //     try {
    //         $allowedFolders = ['mou_files', 'pks_files', 'pkl_files'];

    //         foreach ($allowedFolders as $folder) {
    //             $filepath = "{$folder}/{$filename}";

    //             if (Storage::disk('public')->exists($filepath)) {
    //                 return Storage::disk('public')->download($filepath);
    //             }
    //         }

    //         return response()->json(['error' => 'File tidak ditemukan'], 404);
    //     } catch (\Exception $e) {
    //         \Log::error('File download error: ' . $e->getMessage());
    //         return response()->json(['error' => 'Terjadi Kesalahan Server'], 500);
    //     }
    // }
    // public function download($filename)
    // {
    //     $filepath = "/{filename}";

    //     if (Storage::disk('public')->exists($filepath)) {
    //         return Storage::disk('public')->download($filepath);
    //     }
    //     return response()->json(['error' => 'File tidak ditemukan'], 404);
    // }
}
