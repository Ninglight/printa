<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

class Counter extends Model
{

    public $timestamps = false;

    protected $fillable = [
        'printer_id', 'created_at', 'quantity', 'page_id'
    ];

}
