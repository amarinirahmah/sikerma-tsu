<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\AuthController;
use App\Http\Controllers\DataController;
use Illuminate\Support\Facades\Auth;

// Route::get('/user', function (Request $request) {
//     return $request->user();
// })->middleware('auth:sanctum');

Route::post('/register', [AuthController::class, 'register']);
Route::post('/login', [AuthController::class, 'login']);
Route::post('/upload', [DataController::class, 'uploaddata']);

Route::middleware(['auth:sanctum'])->group(function () {
    Route::get('/user', function (Request $request) {
        return $request->user();
    });
    //admin
    Route::middleware('role:admin')->get('/admin/dashboard', function () {
        return response()->json([
            'message' => 'Selamat datang Admin!'
        ], 200, ['Content-Type' => 'application/json']);
    });
    //user
    Route::middleware('role:user')->get('/user/dashboard', function() {
        return response()->json([
            'message' => 'Selamat datang User!'
        ]);
    });
    //pimpinan
    Route::middleware('role:pimpinan')->get('/pimpinan/dashboard', function() {
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