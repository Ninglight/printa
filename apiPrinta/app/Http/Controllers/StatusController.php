<?php

namespace App\Http\Controllers;

use App\Statu;
use Illuminate\Http\Request;

use App\Http\Requests;
use Illuminate\Support\Facades\Input;
use Illuminate\Support\Facades\Response;

class StatusController extends Controller
{
    public function index() {
        $status = Statu::get();
        return Response::json($status, 200, [], JSON_NUMERIC_CHECK);
    }

    public function show($id) {
        $statu = Statu::find($id);
        return Response::json($statu, 200, [], JSON_NUMERIC_CHECK);
    }

    public function store(Request $request) {

        $name = $request->name;

        $status_test = Statu::where(['name' => $name])->get();

        if($status_test->count() == 0) {

            $status = Statu::create([
                'name' => $name
            ]);

        } else {

            return Response::json("Status exists", 200, [], JSON_NUMERIC_CHECK);

        }

        return Response::json($status, 200, [], JSON_NUMERIC_CHECK);

    }

    public function update(Request $request, $id){
        $status = Statu::find($id);

        $name = $request->name;

        $status_test = Statu::where(['name' => $name])->get();

        if($status_test->count() == 0) {

            $status->name = $name;
            $status->save();

        } else {

            return Response::json("Status exists", 200, [], JSON_NUMERIC_CHECK);

        }

        return Response::json($status, 200, [], JSON_NUMERIC_CHECK);

    }
}
