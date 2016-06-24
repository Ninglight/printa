<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

class UsersPermission extends Model
{

    protected $fillable = [
        'user_id', 'permission_id'
    ];

}
