<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

class Cost extends Model
{

    protected $fillable = [
        'printer_id', 'page_id', 'amount'
    ];

}
