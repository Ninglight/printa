<?php

namespace App\Http\Controllers;

use App\ModelsPrinter;
use App\Model;
use App\Printer;
use Illuminate\Http\Request;

use App\Http\Requests;
use Illuminate\Support\Facades\Input;
use Illuminate\Support\Facades\Response;

class ModelsPrintersController extends Controller
{
    public function index() {
        $model_id = Input::get('model_id');
        $printer_id = Input::get('printer_id');

        if($model_id & $printer_id){

            $models_printers = ModelsPrinter::where(['model_id' => $model_id, 'printer_id' => $printer_id])->get();
            return Response::json($models_printers, 200, [], JSON_NUMERIC_CHECK);

        } elseif($printer_id) {

            $models_printers = ModelsPrinter::where(['printer_id' => $printer_id])->get();
            return Response::json($models_printers, 200, [], JSON_NUMERIC_CHECK);

        } elseif($model_id) {

            $models_printers = ModelsPrinter::where(['model_id' => $model_id])->get();
            return Response::json($models_printers, 200, [], JSON_NUMERIC_CHECK);

        }

        $models_printers = ModelsPrinter::all();

        return Response::json($models_printers, 200, [], JSON_NUMERIC_CHECK);
    }

    public function store(Request $request) {
        $model_printer = [];

        $model_id = $request->model_id;
        $printer_id = $request->printer_id;

        $model_test = Model::where(['id' => $model_id])->get();
        $printer_test = Printer::where(['id' => $printer_id])->get();

        if($model_test->count() == 1 & $printer_test->count() == 1) {

            $model_printer = ModelsPrinter::create([
                'model_id' => $model_id,
                'printer_id' => $printer_id,
                'created_at' => date("Y-m-d H:i:s")
            ]);

        } elseif($model_test->count() == 1) {

            return Response::json("Printer not exists", 200, [], JSON_NUMERIC_CHECK);

        } elseif ($printer_test->count() == 1) {

            return Response::json("Model not exists", 200, [], JSON_NUMERIC_CHECK);

        }

        return Response::json($model_printer, 200, [], JSON_NUMERIC_CHECK);
    }

    public function update(Request $request, $id){
        $model_printer = ModelsPrinter::find($id);

        $model_printer->finished_at = date("Y-m-d H:i:s");

        $model_printer->save();

        return Response::json($model_printer, 200, [], JSON_NUMERIC_CHECK);
    }


}
