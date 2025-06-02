<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\AuthController;
use App\Http\Controllers\DataController;
use App\Http\Controllers\NotifController;
use App\Http\Controller\PklController;
use Illuminate\Support\Facades\Auth;

// Route::get('/user', function (Request $request) {
//     return $request->user();
// })->middleware('auth:sanctum');
Route::get('/users', [AuthController::class, 'getalluser']);
Route::post('/registeruser', [AuthController::class, 'registeruser']);
Route::post('/login', [AuthController::class, 'login']);
Route::get('/getmou', [DataController::class, 'getmou']);
Route::get('/getpks', [DataController::class, 'getpks']);
Route::get('/getmouid/{id}', [DataController::class, 'getmouid']);
Route::get('/getpksid/{id}', [DataController::class, 'getpksid']);
Route::middleware('auth:sanctum')->post('/logout', [AuthController::class, 'logout']);
Route::middleware(['auth:sanctum', 'role:admin,user'])->group(function () {
    Route::get('/getmou', [DataController::class, 'getmou']);
    Route::get('/getpks', [DataController::class, 'getpks']);
    Route::get('/getpkl', [DataController::class, 'getpkl']);
    Route::get('/getmouid/{id}', [DataController::class, 'getmouid']);
    Route::get('/getpksid/{id}', [DataController::class, 'getpksid']);
    Route::post('/uploadmou', [DataController::class, 'uploadmou']);
    Route::post('/uploadpks', [DataController::class, 'uploadpks']);
    Route::put('/updatemou/{id}', [DataController::class, 'updatemou']);
    Route::put('/updatepks/{id}', [DataController::class, 'updatepks']);
    Route::delete('/deletemou/{id}', [DataController::class, 'deletemou']);
    Route::delete('/deletepks/{id}', [DataController::class, 'deletepks']);
    Route::post('/uploadpkl', [DataController::class, 'uploadpkl']);
    Route::put('/updatepkl/{id}', [DataController::class, 'updatepkl']);
    Route::delete('/deletepkl/{id}', [DataController::class, 'deletepkl']);
    Route::get('/getpklid/{id}', [DataController::class, 'getpklid']);
});
Route::middleware(['auth:sanctum', 'role:userpkl'])->group(function() {
    Route::get('/pklSaya', [PklController::class, 'pklSaya']);
    Route::post('/uploadpkl', [DataController::class, 'uploadpkl']);
    Route::get('/getpklid/{id}', [DataController::class, 'getpklid']);
});
Route::middleware(['auth:sanctum', 'role:admin'])->group(function () {
    Route::post('/registerbyadmin', [AuthController::class, 'registerbyadmin']);
    Route::put('/updateuser/{id}', [AuthController::class, 'updateuser']);
    Route::delete('/deleteuser/{id}', [AuthController::class, 'deleteuser']);
    Route::delete('/logoutalltoken', [AuthController::class, 'logoutalltoken']);
    Route::get('/users', [AuthController::class, 'getalluser']);
    Route::get('/users/{id}', [AuthController::class, 'getuserid']);
    Route::get('/notifikasi', [NotifController::class, 'index']);
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