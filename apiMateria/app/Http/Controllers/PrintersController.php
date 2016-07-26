<?php

namespace App\Http\Controllers;

use App\Printer;
use App\Location;
use Illuminate\Http\Request;

use App\Http\Requests;
use Illuminate\Support\Facades\Input;
use Illuminate\Support\Facades\Response;

class PrintersController extends Controller
{
    public function index() {
        if(Input::get('location_id')){
            $printers = Printer::where(['location_id' => Input::get('location_id')])->get();
            return Response::json($printers, 200, [], JSON_NUMERIC_CHECK);
        }
        $printers = Printer::get();
        return Response::json($printers, 200, [], JSON_NUMERIC_CHECK);
    }

    public function show($id) {
        $printer = Printer::find($id);
        return Response::json($printer, 200, [], JSON_NUMERIC_CHECK);
    }

    public function store(Request $request) {
        $printer = [];
        $name = $request->name;
        $serial_number = $request->serial_number;
        $inventory_number = $request->inventory_number;
        $location_id = $request->location_id;

        $serial_number_test = Printer::where(['serial_number' => $serial_number])->get();
        $inventory_number_test = Printer::where(['inventory_number' => $inventory_number])->get();
        $location = Location::where(['id' => $location_id])->get();

        if($serial_number_test->count() == 0 & $inventory_number_test->count() == 0 & $location->count() == 1) {

            $printer = Printer::create([
                'name' => $name,
                'serial_number' => $serial_number,
                'inventory_number' => $inventory_number,
                'location_id' => $location_id
            ]);

        } elseif($serial_number_test->count() == 0 & $inventory_number_test->count() == 0){

            return Response::json("Location not in database", 200, [], JSON_NUMERIC_CHECK);

        } elseif($serial_number_test->count() == 0 & $location->count() == 1) {

            return Response::json("Inventory Number exists", 200, [], JSON_NUMERIC_CHECK);

        } elseif($location->count() == 1 & $inventory_number_test->count() == 0) {

            return Response::json("Serial Number exists", 200, [], JSON_NUMERIC_CHECK);

        }

        return Response::json($printer, 200, [], JSON_NUMERIC_CHECK);

    }

    public function update(Request $request, $id){
        $printer = Printer::find($id);

        $name = $request->name;
        $serial_number = $request->serial_number;
        $inventory_number = $request->inventory_number;
        $location_id = $request->location_id;

        $serial_number_test = Printer::where(['serial_number' => $serial_number])->get();
        $inventory_number_test = Printer::where(['inventory_number' => $inventory_number])->get();
        $location = Location::where(['id' => $location_id])->get();

        if($serial_number_test->count() == 0 & $inventory_number_test->count() == 0 & $location->count() == 1) {

            $printer = Printer::create([
                $printer->name = $name,
                $printer->serial_number = $serial_number,
                $printer->inventory_number = $inventory_number,
                $printer->location_id = $location_id
            ]);

        } elseif($serial_number_test->count() == 0 & $inventory_number_test->count() == 0){

            return Response::json("Location not in database", 200, [], JSON_NUMERIC_CHECK);

        } elseif($serial_number_test->count() == 0 & $location->count() == 1) {

            return Response::json("Inventory Number exists", 200, [], JSON_NUMERIC_CHECK);

        } elseif($location->count() == 1 & $inventory_number_test->count() == 0) {

            return Response::json("Serial Number exists", 200, [], JSON_NUMERIC_CHECK);

        }

        return Response::json($printer, 200, [], JSON_NUMERIC_CHECK);

    }

}
