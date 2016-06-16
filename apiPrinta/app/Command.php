<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

class Command extends Model
{

    protected $fillable = [
        'action_id', 'model_id', 'oid_id'
    ];

}
