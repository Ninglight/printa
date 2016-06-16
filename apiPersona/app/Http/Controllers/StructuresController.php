<?php

namespace App\Http\Controllers;

use App\Structure;
use Illuminate\Http\Request;

use App\Http\Requests;
use Illuminate\Support\Facades\Input;
use Illuminate\Support\Facades\Response;

class StructuresController extends Controller
{
    public function index() {
        $structures = Structure::get();
        return Response::json($structures, 200, [], JSON_NUMERIC_CHECK);
    }

    public function show($id) {
        $structure = Structure::find($id);
        return Response::json($structure, 200, [], JSON_NUMERIC_CHECK);
    }
    
}
