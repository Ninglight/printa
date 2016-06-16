<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

class Page extends Model
{

    protected $fillable = [
        'type_id', 'format_id', 'side_id', 'color_id'
    ];

}
