<?php

namespace App\Http\Controllers;

use App\Printer;
use App\Statu;
use Illuminate\Http\Request;

use App\Http\Requests;
use Illuminate\Support\Facades\Input;
use Illuminate\Support\Facades\Response;

class PrintersController extends Controller
{
    public function index() {
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
        $status_id = $request->status_id;

        $inventory_number_test = Printer::where(['inventory_number' => $inventory_number])->get();
        $status = Statu::where(['id' => $trademark_id])->get();

        if($inventory_number_test->count() == 0 & $status->count() == 1) {

            $printer = Printer::create([
                'name' => $name,
                'trademark_id' => $trademark_id
            ]);

        } elseif($inventory_number_test->count() == 0){

            return Response::json("Status not in database", 200, [], JSON_NUMERIC_CHECK);

        } elseif($status->count() == 1) {

            return Response::json("Inventory Number exists", 200, [], JSON_NUMERIC_CHECK);

        }

        return Response::json($printer, 200, [], JSON_NUMERIC_CHECK);

    }

    public function update(Request $request, $id){
        $printer = Printer::find($id);

        $name = $request->name;
        $serial_number = $request->serial_number;
        $inventory_number = $request->inventory_number;
        $status_id = $request->status_id;

        $inventory_number_test = Printer::where(['inventory_number' => $inventory_number])->get();
        $status = Statu::where(['id' => $status_id])->get();

        if($inventory_number_test->count() == 0 & $status->count() == 1) {

            $printer->name = $name;
            $printer->serial_number = $serial_number;
            $printer->inventory_number = $inventory_number;
            $printer->status_id = $status_id;
            $printer->save();

        } elseif($inventory_number_test->count() == 0) {

            return Response::json("Statu not in database", 200, [], JSON_NUMERIC_CHECK);

        } elseif($status->count() == 1) {

            return Response::json("Inventory Number exists", 200, [], JSON_NUMERIC_CHECK);

        }

        return Response::json($printer, 200, [], JSON_NUMERIC_CHECK);

    }

}
