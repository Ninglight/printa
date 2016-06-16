<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

class PrintersMaintenance extends Model
{

    protected $fillable = [
        'printer_id', 'maintenance_id', 'finished_at'
    ];

}
