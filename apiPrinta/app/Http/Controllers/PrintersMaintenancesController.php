<?php

namespace App\Http\Controllers;

use App\PrintersMaintenance;
use App\Maintenance;
use Illuminate\Http\Request;

use App\Http\Requests;
use Illuminate\Support\Facades\Input;
use Illuminate\Support\Facades\Response;

class PrintersMaintenancesController extends Controller
{
    public function index() {
        $maintenance_id = Input::get('maintenance_id');
        $printer_id = Input::get('printer_id');

        if($maintenance_id & $printer_id){

            $printers_maintenances = PrintersMaintenance::where(['maintenance_id' => $maintenance_id, 'printer_id' => $printer_id])->get();
            return Response::json($printers_maintenances, 200, [], JSON_NUMERIC_CHECK);

        } elseif($printer_id) {

            $printers_maintenances = PrintersMaintenance::where(['printer_id' => $printer_id])->get();
            return Response::json($printers_maintenances, 200, [], JSON_NUMERIC_CHECK);

        } elseif($maintenance_id) {

            $printers_maintenances = PrintersMaintenance::where(['model_id' => $maintenance_id])->get();
            return Response::json($printers_maintenances, 200, [], JSON_NUMERIC_CHECK);

        }

        $printers_maintenances = PrintersMaintenance::all();
        return Response::json($printers_maintenances, 200, [], JSON_NUMERIC_CHECK);
    }

    public function store(Request $request) {
        $printer_maintenance = [];

        $maintenance_id = $request->maintenance_id;

        $maintenance_test = Maintenance::where(['id' => $maintenance_id])->get();

        if($maintenance_test->count() == 1) {

            $printer_maintenance = PrintersMaintenance::create([
                'maintenance_id' => $maintenance_id,
                'printer_id' => $request->printer_id,
                'created_at' => date("Y-m-d H:i:s")
            ]);

        } else {

            return Response::json("Maintenance not exists", 200, [], JSON_NUMERIC_CHECK);

        }

        return Response::json($printer_maintenance, 200, [], JSON_NUMERIC_CHECK);
    }

    public function update(Request $request, $id){
        $printer_maintenance = PrintersMaintenance::find($id);

        $printer_maintenance->finished_at = date("Y-m-d H:i:s");

        $printer_maintenance->save();

        return Response::json($printer_maintenance, 200, [], JSON_NUMERIC_CHECK);
    }


}
