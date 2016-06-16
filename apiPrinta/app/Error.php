<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

class Error extends Model
{

    protected $fillable = [
        'type_error_id', 'target_table', 'target_column', 'info'
    ];

}
