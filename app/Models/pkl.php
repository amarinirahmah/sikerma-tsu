<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;

class pkl extends Model
{
    use HasFactory;

    protected $fillable = ['nisn','user_id','sekolah','nama','gender','tanggal_mulai','tanggal_berakhir','file_pkl','telpemail','alamat'];
    protected $table = 'pkl';

    // public function user()
    // {
    //     return $this->belongsTo(User::class);
    // }
}
