<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\User;
use Illuminate\Support\Facades\Hash;

class AuthController extends Controller
{
    public function register(Request $request)
    {
        $request->validate([
            'name' => 'required',
            'email' => 'required|email|unique:user',
            'password' => 'required',
            'role' => 'required|in:admin,user,pimpinan'
        ]);

        $user = User::create([
            'name' => $request->name,
            'email' => $request->email,
            'password' => Hash::make($request->password),
            'role' => $request->role
        ]);

        return response()->json([
            'message' => 'Akun berhasil dibuat',
            'user' => $user
        ]);
    }
    
    public function login (Request $request)
    {
        $request->validate([
            'email' => 'required|email',
            'password' => 'required'
        ]);

        $user = User::where('email', $request->email)->first();

        if ($user && Hash::check($request->password, $user->password)) {
            return response()->json([
                'message' => 'Berhasil login',
                'user' => $user,
                'role' => $user->role
            ]);
        }

        return response()->json([
            'message' => 'Data salah!'
        ],401);
    }
}
