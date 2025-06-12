<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;

class DataMou extends Model
{
    use HasFactory;

    protected $fillable = ['nomormou', 'nomormou2', 'nama', 'judul', 'tanggal_mulai', 'tanggal_berakhir', 'file_mou','file_name','ruanglingkup','status','keterangan','pihak1','pihak2'];
    protected $casts = [
        'pihak1' => 'array',
        'pihak2' => 'array',
    ];
    protected $table = 'data_mous';

    public function pks()
    {
        return $this->belongsToMany(DataPks::class, 'mou_pks', 'mou_id', 'pks_id');
    }

    public function pihak()
    {
        return $this->hasMany(pihak::class);
    }

    public function progress()
    {
        return $this->hasMany(DetailProgress::class, 'data_mou_id');
    }
}
