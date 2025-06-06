<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\Notifikasi;

class NotifController extends Controller
{
    public function index(Request $request)
    {
        $query = Notifikasi::query();

        if ($request->has('type')) {
            $query->where('type', $request->type);
        }

        if ($request->has('tanggal')) {
            $query->whereDate('tanggal_notif', $request->tanggal);
        }

        $data = $query->orderBy('tanggal_notif', 'desc')->get();

        return response()->json([
            'message' => 'Daftar notifikasi',
            'data' => $data
        ]);
    }
}
