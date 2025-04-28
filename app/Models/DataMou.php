<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class DataMou extends Model
{
    protected $fillable = ['nomormou', 'nama', 'judul', 'tanggal_mulai', 'tanggal_berakhir', 'file_mou', 'tujuan'];
    protected $table = 'data_mous';
}
