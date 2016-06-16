<?php

namespace App\Http\Controllers;

use App\Color;
use Illuminate\Http\Request;

use App\Http\Requests;
use Illuminate\Support\Facades\Input;
use Illuminate\Support\Facades\Response;

class ColorsController extends Controller
{
    public function index() {
        $colors = Color::get();
        return Response::json($colors, 200, [], JSON_NUMERIC_CHECK);
    }

    public function show($id) {
        $color = Color::find($id);
        return Response::json($color, 200, [], JSON_NUMERIC_CHECK);
    }

    public function store(Request $request) {
        $name = $request->name;

        $color = Color::where(['name' => $name])->get();
        
        if($color->count() == 0){
            $color = Color::create([
                'name' => $name
            ]);
        }
        return Response::json($color, 200, [], JSON_NUMERIC_CHECK);
    }

    public function update(Request $request, $id){
        $color = Color::find($id);

        $name = $request->name;

        $color_test = Color::where(['name' => $name])->get();

        if($color_test->count() == 0){

            $color->name = $name;
            $color->save();

        }

        return Response::json($color, 200, [], JSON_NUMERIC_CHECK);
    }
}
