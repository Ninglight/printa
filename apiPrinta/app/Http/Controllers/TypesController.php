<?php

namespace App\Http\Controllers;

use App\Type;
use Illuminate\Http\Request;

use App\Http\Requests;
use Illuminate\Support\Facades\Input;
use Illuminate\Support\Facades\Response;

class TypesController extends Controller
{
    public function index() {
        $types = Type::get();
        return Response::json($types, 200, [], JSON_NUMERIC_CHECK);
    }

    public function show($id) {
        $type = Type::find($id);
        return Response::json($type, 200, [], JSON_NUMERIC_CHECK);
    }

    public function store(Request $request) {
        $name = $request->name;
        $type = Type::where(['name' => $name])->get();
        if($type->count() == 0){
            $type = Type::create([
                'name' => $name
            ]);
        }
        return Response::json($type, 200, [], JSON_NUMERIC_CHECK);
    }

    public function update(Request $request, $id){
        $type = Type::find($id);

        $name = $request->name;

        $type_test = Type::where(['name' => $name])->get();

        if($type_test->count() == 0){

            $type->name = $name;
            $type->save();

        }

        return Response::json($type, 200, [], JSON_NUMERIC_CHECK);
    }
}
