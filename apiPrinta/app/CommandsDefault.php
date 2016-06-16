<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

class CommandsDefault extends Model
{

    protected $fillable = [
        'action_id', 'model_id', 'trademark_id', 'oid_id'
    ];

}
