<?php

namespace App\Http\Controllers;

use App\Maintenance;
use Illuminate\Http\Request;

use App\Http\Requests;
use Illuminate\Support\Facades\Input;
use Illuminate\Support\Facades\Response;

class MaintenancesController extends Controller
{
    public function index() {
        $maintenances = Maintenance::get();
        return Response::json($maintenances, 200, [], JSON_NUMERIC_CHECK);
    }

    public function show($id) {
        $maintenance = Maintenance::find($id);
        return Response::json($maintenance, 200, [], JSON_NUMERIC_CHECK);
    }

    public function store(Request $request) {
        $name = $request->name;

        $maintenance = Maintenance::where(['name' => $name])->get();

        if($maintenance->count() == 0){

            $maintenance = Maintenance::create([
                'name' => $name
            ]);
            
        }

        return Response::json($maintenance, 200, [], JSON_NUMERIC_CHECK);
    }

    public function update(Request $request, $id){
        $maintenance = Maintenance::find($id);

        $name = $request->name;

        $maintenance_test = Maintenance::where(['name' => $name])->get();

        if($maintenance_test->count() == 0){

            $maintenance->name = $name;
            $maintenance->save();

        }

        return Response::json($maintenance, 200, [], JSON_NUMERIC_CHECK);
    }
}
