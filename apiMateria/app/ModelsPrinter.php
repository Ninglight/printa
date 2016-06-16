<?php

namespace App;

use Illuminate\Database\Eloquent;

class ModelsPrinter extends Eloquent\Model
{
    public $timestamps = false;

    protected $fillable = [
        'model_id', 'printer_id', 'created_at', 'finished_at'
    ];
}
