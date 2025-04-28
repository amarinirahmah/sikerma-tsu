<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class DataPks extends Model
{
    protected $fillable = ['nomormou', 'nomorpks', 'judul', 'tanggal_mulai', 'tanggal_berakhir', 'namaunit', 'file_pks', 'tujuan'];
    protected $table = 'data_pks';
}
