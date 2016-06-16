<?php

namespace App\Http\Controllers;

use App\Format;
use Illuminate\Http\Request;

use App\Http\Requests;
use Illuminate\Support\Facades\Input;
use Illuminate\Support\Facades\Response;

class FormatsController extends Controller
{
    public function index() {
        $formats = Format::get();
        return Response::json($formats, 200, [], JSON_NUMERIC_CHECK);
    }

    public function show($id) {
        $format = Format::find($id);
        return Response::json($format, 200, [], JSON_NUMERIC_CHECK);
    }

    public function store(Request $request) {
        $name = $request->name;
        $format = Format::where(['name' => $name])->get();
        if($format->count() == 0){
            $format = Format::create([
                'name' => $name
            ]);
        }
        return Response::json($format, 200, [], JSON_NUMERIC_CHECK);
    }

    public function update(Request $request, $id){
        $format = Format::find($id);

        $name = $format->name;

        $format_test = Format::where(['name' => $name])->get();

        if($format_test->count() == 0){

            $format->name = $name;
            $format->save();

        }

        return Response::json($format, 200, [], JSON_NUMERIC_CHECK);
    }
}
