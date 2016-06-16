<?php

namespace App\Http\Controllers;

use App\Trademark;
use Illuminate\Http\Request;

use App\Http\Requests;
use Illuminate\Support\Facades\Input;
use Illuminate\Support\Facades\Response;

class TrademarksController extends Controller
{
    public function index() {
        $trademarks = Trademark::get();
        return Response::json($trademarks, 200, [], JSON_NUMERIC_CHECK);
    }

    public function show($id) {
        $trademark = Trademark::find($id);
        return Response::json($trademark, 200, [], JSON_NUMERIC_CHECK);
    }

    public function store(Request $request) {

        $name = $request->name;

        $trademark_test = Trademark::where(['name' => $name])->get();

        if($trademark_test->count() == 0) {

            $trademark = Trademark::create([
                'name' => $name
            ]);

        } else {

            return Response::json("Trademark exists", 200, [], JSON_NUMERIC_CHECK);

        }

        return Response::json($trademark, 200, [], JSON_NUMERIC_CHECK);

    }

    public function update(Request $request, $id){
        $trademark = Trademark::find($id);

        $name = $request->name;

        $trademark_test = Statu::where(['name' => $name])->get();

        if($trademark_test->count() == 0) {

            $trademark->name = $name;
            $trademark->save();

        } else {

            return Response::json("Trademark exists", 200, [], JSON_NUMERIC_CHECK);

        }

        return Response::json($trademark, 200, [], JSON_NUMERIC_CHECK);

    }
}
