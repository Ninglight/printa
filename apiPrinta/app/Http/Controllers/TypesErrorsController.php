<?php

namespace App\Http\Controllers;

use App\TypesError;
use Illuminate\Http\Request;

use App\Http\Requests;
use Illuminate\Support\Facades\Input;
use Illuminate\Support\Facades\Response;

class TypesErrorsController extends Controller
{
    public function index() {
        $typeserrors = TypesError::get();
        return Response::json($typeserrors, 200, [], JSON_NUMERIC_CHECK);
    }

    public function show($id) {
        $typeserror = TypesError::find($id);
        return Response::json($typeserror, 200, [], JSON_NUMERIC_CHECK);
    }

    public function store(Request $request) {
        $type_error = [];
        $name = $request->name;
        $direction = $request->direction;

        $type_error = TypesError::where(['name' => $name, 'direction' => $direction])->get();

        if($type_error->count() == 0){
            $type_error = TypesError::create([
                'name' => $name,
                'direction' => $direction
            ]);
        }
        return Response::json($type_error, 200, [], JSON_NUMERIC_CHECK);
    }

    public function update(Request $request, $id){
        $type_error = TypesError::find($id);

        $name = $request->name;
        $direction = $request->direction;

        $type_error_test = TypesError::where(['name' => $name, 'direction' => $direction])->get();

        if($type_error_test->count() == 0){

            $type_error->name = $name;
            $type_error->direction = $direction;

            $type_error->save();

        }

        return Response::json($type_error, 200, [], JSON_NUMERIC_CHECK);
    }
}
