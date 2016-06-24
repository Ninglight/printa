<?php

namespace App;

use Illuminate\Database\Eloquent;

class Printer extends Eloquent\Model
{

    protected $fillable = [
        'name', 'serial_number', 'inventory_number', 'location_id'
    ];

}
