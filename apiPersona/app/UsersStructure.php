<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

class UsersStructure extends Model
{

    public $timestamps = false;

    protected $fillable = [
        'user_id', 'structure_id', 'created_at', 'finished_at'
    ];
}
