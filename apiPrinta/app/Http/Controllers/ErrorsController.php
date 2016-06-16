<?php

namespace App\Http\Controllers;

use App\Error;
use App\TypesError;
use Illuminate\Http\Request;

use App\Http\Requests;
use Illuminate\Support\Facades\Input;
use Illuminate\Support\Facades\Response;

class ErrorsController extends Controller
{
    public function index() {
        $errors = Error::get();
        return Response::json($errors, 200, [], JSON_NUMERIC_CHECK);
    }

    public function show($id) {
        $error = Error::find($id);
        return Response::json($error, 200, [], JSON_NUMERIC_CHECK);
    }

    public function store(Request $request) {
        $error = [];
        $type_error_id = $request->type_error_id;

        $type_error = TypesError::where(['id' => $type_error_id])->get();

        // On verifie si le type erreur existe bien
        if($type_error->count() == 1){
            $error = Error::create([
                'type_error_id' => $type_error_id,
                'target_table' => $request->target_table,
                'target_column' => $request->target_column,
                'info' => $request->info,
                'treated' => false
            ]);
        } else {
            return Response::json("Le type erreur associé n'est pas valide", 200, [], JSON_NUMERIC_CHECK);
        }
        return Response::json($error, 200, [], JSON_NUMERIC_CHECK);
    }

    public function update(Request $request, $id){
        $error = Type::find($id);

        $error->treated = $request->treated;

        $error->save();

        return Response::json($type, 200, [], JSON_NUMERIC_CHECK);
    }
}
