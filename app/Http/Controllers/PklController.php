<?php

use App\Models\pkl;
use Illuminate\Support\Facades\Auth;

class PklController extends Controller
{
    public function pklSaya(Request $request)
    {
        $user = $request->user();

        if (!user) {
            return response()->json(['message'=>'Unauthorized'], 401);
        }

        // Ambil progress milik user yang sedang login
        $data = pkl::where('user_id', $user->id)->get();

        return response()->json([
            'message' => 'Data PKL Anda',
            'data' => $data
        ]);
    }
}
