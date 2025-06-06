<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class DetailProgress extends Model
{
    protected $fillable = ['data_mou_id', 'tanggal', 'aktivitas'];

    public function mou()
    {
        return $this->belongsTo(DataMou::class, 'data_mou_id');
    }
}
