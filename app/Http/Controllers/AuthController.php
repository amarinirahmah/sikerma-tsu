<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\User;
use App\Models\ActivityLog;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Auth;
use Tymon\JWTAuth\Facades\JWTAuth;

class AuthController extends Controller
{
    public function registeruser(Request $request)
    {
        $request->validate([
            'name' => 'required',
            'email' => 'required|email|unique:users,email',
            'password' => 'required',
        ]);

        $user = User::create([
            'name' => $request->name,
            'email' => $request->email,
            'password' => Hash::make($request->password),
            'role' => 'userpkl',
        ]);

        return response()->json([
            'message' => 'Akun berhasil dibuat',
            'user' => $user
        ]);
    }

    public function registerbyadmin(Request $request)
    {
        $users = Auth::user();
        if (!$users) {
            return response()->json(['message' => 'Unauthorized'], 401);
        }

        $request->validate([
            'name' => 'required',
            'email' => 'required|email|unique:users,email',
            'password' => 'required',
            'role' => 'required|in:admin,user,userpkl',
        ]);

        $user = User::create([
            'name' => $request->name,
            'email' => $request->email,
            'password' => Hash::make($request->password),
            'role' => $request->role
        ]);

        ActivityLog::create([
            'user_id' => $users->id,
            'action' => 'Registrasi Akun',
            'description' => 'Berhasil melakukan registrasi dengan email ' . $request->email,
        ]);

        return response()->json([
            'message' => 'Akun berhasil dibuat oleh Admin',
            'user' => $user
        ]);
    }

    public function updateuser(Request $request, $id)
    {
        $users = Auth::user();
        if (!$users) {
            return response()->json(['message' => 'Unauthorized'], 401);
        }

        $request->validate([
            'name' => 'sometimes|required',
            'email' => 'sometimes|required|email|unique:users,email,' . $id,
            'password' => 'sometimes|required',
            'role' => 'sometimes|required|in:admin,user,userpkl',
        ]);

        $user = User::find($id);
        if (!$user) {
            return response()->json(['message' => 'Data user tidak ditemukan.']);
        }

        if ($request->has('name')) $user->name = $request->name;
        if ($request->has('email')) $user->email = $request->email;
        if ($request->has('role')) $user->role = $request->role;
        if ($request->has('password')) $user->password = Hash::make($request->password);

        $user->save();

        ActivityLog::create([
            'user_id' => $users->id,
            'action' => 'Perubahan Detail Akun',
            'description' => 'Melakukan perubahan detail dengan email ' . $request->email,
        ]);

        return response()->json([
            'message' => 'Data user berhasil diupdate.',
            'data' => $user
        ]);
    }

    public function login(Request $request)
    {
        \Log::info('Login API terpanggil');

        $credentials = $request->only('email', 'password');

        if (!$token = Auth::attempt($credentials)) {
            return response()->json([
                'message' => 'Email atau password salah!',
            ], 401);
        }

        $user = Auth::user();

        return response()->json([
            'message' => 'Login berhasil',
            'token' => $token,
            'token_type' => 'bearer',
            'expires_in' => Auth::factory()->getTTL() * 60,
            'user' => $user,
            'role' => $user->role,
        ]);
    }

    public function logout()
    {
        Auth::logout();

        return response()->json([
            'message' => 'Berhasil logout dan token dihapus'
        ]);
    }

    public function deleteuser(Request $request, $id)
    {
        $users = Auth::user();
        if (!$users) {
            return response()->json(['message' => 'Unauthorized'], 401);
        }

        $user = User::find($id);
        if (!$user) {
            return response()->json(['message' => 'Data User tidak ditemukan'], 404);
        }

        $user->delete();

        ActivityLog::create([
            'user_id' => $users->id,
            'action' => 'Penghapusan Akun',
            'description' => 'Melakukan penghapusan akun dengan email ' . $user->email,
        ]);

        return response()->json([
            'message' => 'Data User berhasil dihapus'
        ]);
    }

    public function getalluser()
    {
        $users = User::all();

        return response()->json([
            'message' => 'Data semua user berhasil ditampilkan',
            'data' => $users
        ]);
    }

    public function getuserid($id)
    {
        $user = User::find($id);

        if (!$user) {
            return response()->json([
                'message' => 'User tidak ditemukan'
            ], 404);
        }

        return response()->json([
            'message' => 'Data user berhasil ditampilkan',
            'data' => $user
        ]);
    }
}
