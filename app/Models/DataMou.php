<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;

class DataMou extends Model
{
    use HasFactory;

    protected $fillable = ['nomormou', 'nama', 'judul', 'tanggal_mulai', 'tanggal_berakhir', 'file_mou', 'tujuan','status','keterangan'];
    protected $table = 'data_mous';

    public function pks()
    {
        return $this->belongsToMany(DataPks::class, 'mou_pks', 'mou_id', 'pks_id');
    }
}
