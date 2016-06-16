<?php

namespace App\Http\Controllers;

use App\Model;
use App\Trademark;
use Illuminate\Http\Request;

use App\Http\Requests;
use Illuminate\Support\Facades\Input;
use Illuminate\Support\Facades\Response;

class ModelsController extends Controller
{
    public function index() {
        $models = Model::get();
        return Response::json($models, 200, [], JSON_NUMERIC_CHECK);
    }

    public function show($id) {
        $model = Model::find($id);
        return Response::json($model, 200, [], JSON_NUMERIC_CHECK);
    }

    public function store(Request $request) {
        $model = [];
        $name = $request->name;
        $trademark_id = $request->trademark_id;

        $model = Model::where(['name' => $name])->get();
        $trademark = Trademark::where(['id' => $trademark_id])->get();

        if($model->count() == 0 & $trademark->count() == 1){

            $model = Model::create([
                'name' => $name,
                'trademark_id' => $trademark_id
            ]);

        } elseif($model->count() == 0) {

            return Response::json("trademark not in database", 200, [], JSON_NUMERIC_CHECK);

        } elseif($trademark->count() == 1) {

            return Response::json("model name exists", 200, [], JSON_NUMERIC_CHECK);

        }

        return Response::json($model, 200, [], JSON_NUMERIC_CHECK);

    }

    public function update(Request $request, $id){
        $model = Model::find($id);

        $name = $request->name;
        $trademark_id = $request->trademark_id;

        $model_test = Model::where(['name' => $name])->get();
        $trademark = Trademark::where(['id' => $trademark_id])->get();

        if($model_test->count() == 0 & $trademark->count() == 1){

            $model->name = $name;
            $model->trademark_id = $trademark_id;
            $model->save();

        }

        return Response::json($color, 200, [], JSON_NUMERIC_CHECK);
    }
}
