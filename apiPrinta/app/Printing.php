<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

class Printing extends Model
{

    public $timestamps = false;

    protected $fillable = [
        'user_id', 'printer_id', 'created_at', 'quantity', 'page_id'
    ];

}
