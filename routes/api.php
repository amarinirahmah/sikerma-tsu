<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\AuthController;
use App\Http\Controllers\DataController;
use App\Http\Controllers\NotifController;
use App\Http\Controllers\PklController;
use App\Http\Controllers\FileController;
use App\Http\Controllers\ProgressController;
use Illuminate\Support\Facades\Auth;

// Route::get('/user', function (Request $request) {
//     return $request->user();
// })->middleware('auth:sanctum');
Route::get('/users', [AuthController::class, 'getalluser']);
Route::post('/registeruser', [AuthController::class, 'registeruser']);
Route::post('/login', [AuthController::class, 'login']);
Route::get('/getmou', [DataController::class, 'getmou']);
Route::get('/getpks', [DataController::class, 'getpks']);
// Route::get('/getmouid/{id}', [DataController::class, 'getmouid']);
// Route::get('/getpksid/{id}', [DataController::class, 'getpksid']);
Route::get('/download/{folder}/{filename}', [FileController::class, 'download']);
Route::middleware('auth:sanctum')->post('/logout', [AuthController::class, 'logout']);
Route::middleware(['auth:sanctum', 'role:admin,user'])->group(function () {
    Route::get('/getpkl', [DataController::class, 'getpkl']);
    Route::get('/getmouid/{id}', [DataController::class, 'getmouid']);
    Route::get('/getpksid/{id}', [DataController::class, 'getpksid']);
    Route::post('/uploadmou', [DataController::class, 'uploadmou']); 
    Route::post('/uploadpks', [DataController::class, 'uploadpks']);
    Route::put('/updatemou/{id}', [DataController::class, 'updatemou']);
    Route::patch('/ketmouupdate/{id}', [DataController::class, 'patchKeteranganMou']);
    Route::put('/updatepks/{id}', [DataController::class, 'updatepks']);
    Route::patch('/ketupdate/{id}', [DataController::class, 'updatepks']);
    Route::delete('/deletemou/{id}', [DataController::class, 'deletemou']);
    Route::delete('/deletepks/{id}', [DataController::class, 'deletepks']);
    Route::post('/uploadpkl', [DataController::class, 'uploadpkl']);
    Route::put('/updatepkl/{id}', [DataController::class, 'updatepkl']);
    Route::patch('/statupdate/{id}', [DataController::class, 'updatepkl']);
    Route::delete('/deletepkl/{id}', [DataController::class, 'deletepkl']);
    Route::get('/getpklid/{id}', [DataController::class, 'getpklid']);
    Route::post('/addprogress/{id}', [ProgressController::class, 'addProgress']);
    Route::get('/mou/{id}/progress', [ProgressController::class, 'getProgress']);
});
Route::middleware(['auth:sanctum', 'role:userpkl'])->group(function() {
    Route::get('/pklSaya', [PklController::class, 'pklSaya']);
    Route::post('/useruploadpkl', [DataController::class, 'uploadpkl']);
    //Route::get('/getpklid/{id}', [DataController::class, 'getpklid']);
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