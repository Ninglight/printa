<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

class CostsDefault extends Model
{

    protected $fillable = [
        'model_id', 'page_id', 'amount', 'finished_at'
    ];

}
