<?php

namespace App\Models;

use Laravel\Sanctum\HasApiTokens;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
// use Illuminate\Foundation\Auth\User as Authenticatable;
// use Illuminate\Notifications\Notifiable;

class User extends Model
{
    use HasApiTokens, HasFactory;

    protected $fillable = ['name','email','password','role'];
    protected $table = 'user';

    protected static function booted()
    {
        static::deleting(function ($user) {
            \Log::info("Deleting user ID: {$user->id}");
            $user->tokens()->delete();
        });
    }

    // public function tokens()
    // {
    //     return $this->hasMany(\Laravel\Sanctum\PersonalAccessToken::class, 'tokenable_id')
    //         ->where('tokenable_type', self::class);
    // }

    // public function pkl()
    // {
    //     return $this->hasMany(pkl::class);
    // }
}
