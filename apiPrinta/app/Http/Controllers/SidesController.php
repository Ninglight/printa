<?php

namespace App\Http\Controllers;

use App\Side;
use Illuminate\Http\Request;

use App\Http\Requests;
use Illuminate\Support\Facades\Input;
use Illuminate\Support\Facades\Response;

class SidesController extends Controller
{
    public function index() {
        $sides = Side::get();
        return Response::json($sides, 200, [], JSON_NUMERIC_CHECK);
    }

    public function show($id) {
        $side = Side::find($id);
        return Response::json($side, 200, [], JSON_NUMERIC_CHECK);
    }

    public function store(Request $request) {
        $name = $request->name;
        $side = Side::where(['name' => $name])->get();
        if($side->count() == 0){
            $side = Side::create([
                'name' => $name
            ]);
        }
        return Response::json($side, 200, [], JSON_NUMERIC_CHECK);
    }

    public function update(Request $request, $id){
        $side = Side::find($id);

        $name = $format->name;

        $side_test = Side::where(['name' => $name])->get();

        if($side_test->count() == 0){

            $side->name = $name;
            $side->save();

        }

        return Response::json($side, 200, [], JSON_NUMERIC_CHECK);
    }
}
