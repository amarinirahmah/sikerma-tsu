<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\AuthController;
use App\Http\Controllers\DataController;
use Illuminate\Support\Facades\Auth;

// Route::get('/user', function (Request $request) {
//     return $request->user();
// })->middleware('auth:sanctum');

// Route::middleware('auth:sanctum', 'role:superadmin')->post('/registerbysuperadmin', [AuthController::class, 'registerbysuperadmin']);
Route::middleware('auth:sanctum', 'role:superadmin')->group(function () {
    Route::post('/registerbysuperadmin', [AuthController::class, 'registerbysuperadmin']);
    Route::put('/updateuser/{id}', [AuthController::class, 'updateuser']);
    Route::delete('/deleteuser/{id}', [AuthController::class, 'deleteuser']);
});
Route::post('/registeruser', [AuthController::class, 'registeruser']);
Route::post('/login', [AuthController::class, 'login']);
// Route::post('/uploadmou', [DataController::class, 'uploadmou']);
// Route::post('/uploadpks', [DataController::class, 'uploadpks']);
Route::middleware(['auth:sanctum', 'role:admin'])->group(function () {
    Route::post('/uploadmou', [DataController::class, 'uploadmou']);
    Route::post('/uploadpks', [DataController::class, 'uploadpks']);
    Route::put('/updatemou/{id}', [DataController::class, 'updatemou']);
    Route::put('/updatepks/{id}', [DataController::class, 'updatepks']);
    Route::delete('/deletemou/{id}', [DataController::class, 'deletemou']);
    Route::delete('/deletepks/{id}', [DataController::class, 'deletepks']);
});
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