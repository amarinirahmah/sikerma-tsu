<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;

class DataPks extends Model
{
    use HasFactory;

    protected $fillable = ['nomormou', 'nomorpks', 'judul', 'tanggal_mulai', 'tanggal_berakhir', 'namaunit', 'file_pks', 'tujuan'];
    protected $table = 'data_pks';

    public function mou()
    {
        return $this->belongsToMany(DataMou::class, 'mou_pks', 'pks_id', 'mou_id');
    }
}
