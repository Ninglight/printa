<?php

namespace App\Http\Controllers;

use App\Oid;
use Illuminate\Http\Request;

use App\Http\Requests;
use Illuminate\Support\Facades\Input;
use Illuminate\Support\Facades\Response;

class OidsController extends Controller
{
    public function index() {
        $oids = Oid::get();
        return Response::json($oids, 200, [], JSON_NUMERIC_CHECK);
    }

    public function show($id) {
        $oid = Oid::find($id);
        return Response::json($oid, 200, [], JSON_NUMERIC_CHECK);
    }

    public function store(Request $request) {
        $value = $request->value;
        $oid = Oid::where(['value' => $value])->get();
        if($oid->count() == 0){
            $oid = Oid::create([
                'value' => $value
            ]);
        }
        return Response::json($oid, 200, [], JSON_NUMERIC_CHECK);
    }

    public function update(Request $request, $id){
        $oid = Oid::find($id);

        $value = $oid->value;

        $oid_test = Oid::where(['value' => $value])->get();

        if($oid_test->count() == 0){

            $oid->value = $value;
            $oid->save();

        }

        return Response::json($oid, 200, [], JSON_NUMERIC_CHECK);
    }
}
