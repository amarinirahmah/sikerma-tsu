<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\AuthController;

// Route::get('/user', function (Request $request) {
//     return $request->user();
// })->middleware('auth:sanctum');

Route::post('/register', [AuthController::class, 'register']);
Route::post('/login', [AuthController::class, 'login']);

Route::middleware(['auth:sanctum'])->group(function () {
    Route::get('/user', function (Request $request) {
        return $request->user();
    });
    //admin
    Route::middleware('auth:sanctum','role:admin')->get('/admin/dashboard', function () {
        return response()->json([
            'message' => 'Selamat datang Admin!'
        ]);
    });
    //user
    Route::middleware('auth:sanctum','role:user')->get('/user/dashboard', function() {
        return response()->json([
            'message' => 'Selamat datang User!'
        ]);
    });
    //pimpinan
    Route::middleware('auth:sanctum','role:pimpinan')->get('/pimpinan/dashboard', function() {
        return response()->json([
            'message' => 'Selamat datang Pimpinan!'
        ]);
    });
    //logout
    Route::post('/logout', function (Request $request) {
        $request->user()->currentAccessToken()->delete();
        return response()->json([
            'message' => 'Logout berhasil'
        ]);
    });
});