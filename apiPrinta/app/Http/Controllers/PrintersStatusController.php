<?php

namespace App\Http\Controllers;

use App\PrintersStatu;
use App\Statu;
use App\Printer;
use Illuminate\Http\Request;

use App\Http\Requests;
use Illuminate\Support\Facades\Input;
use Illuminate\Support\Facades\Response;

class PrintersStatusController extends Controller
{
    public function index() {
        $status_id = $request->model_id;
        $printer_id = $request->printer_id;

        if($status_id){

            if($printer_id){

                $printers_status = PrintersStatu::where(['status_id' => $status_id, 'printer_id' => $printer_id])->get();
                return Response::json($printers_status, 200, [], JSON_NUMERIC_CHECK);

            } else {

                $printers_status = PrintersStatu::where(['model_id' => $status_id])->get();
                return Response::json($printers_status, 200, [], JSON_NUMERIC_CHECK);

            }
        } elseif($printer_id) {

            $printers_status = PrintersStatu::where(['printer_id' => $printer_id])->get();
            return Response::json($printers_status, 200, [], JSON_NUMERIC_CHECK);

        }

        $printers_status = PrintersStatu::all();
        return Response::json($printers_status, 200, [], JSON_NUMERIC_CHECK);

    }

    public function store(Request $request) {
        $printer_status = [];

        $status_id = $request->status_id;

        $status_test = PrintersStatu::where(['id' => $status_id])->get();

        if($status_test->count() == 1) {

            $printer_status = PrintersStatu::create([
                'status_id' => $status_id,
                'printer_id' => $request->printer_id,
                'created_at' => date("Y-m-d H:i:s")
            ]);

        } else {

            return Response::json("Status not exists", 200, [], JSON_NUMERIC_CHECK);

        }

        return Response::json($printer_status, 200, [], JSON_NUMERIC_CHECK);

    }

    public function update(Request $request, $id){
        $printer_status = PrintersStatu::find($id);

        $printer_status->finished_at = date("Y-m-d H:i:s");

        $printer_status->save();

        return Response::json($printer_status, 200, [], JSON_NUMERIC_CHECK);

    }


}
