<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

class PrintersStatu extends Model
{

    protected $fillable = [
        'printer_id', 'status_id'
    ];

}
