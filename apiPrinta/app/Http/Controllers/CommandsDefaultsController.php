<?php

namespace App\Http\Controllers;

use App\CommandsDefault;
use App\Action;
use App\Oid;
use Illuminate\Http\Request;

use App\Http\Requests;
use Illuminate\Support\Facades\Input;
use Illuminate\Support\Facades\Response;

class CommandsDefaultsController extends Controller
{
    public function index() {
        $commandsdefaults = CommandsDefault::get();
        return Response::json($commandsdefaults, 200, [], JSON_NUMERIC_CHECK);
    }

    public function show($id) {
        $commandsdefault = CommandsDefault::find($id);
        return Response::json($commandsdefault, 200, [], JSON_NUMERIC_CHECK);
    }

    public function store(Request $request) {
        $command_default = [];
        $action_id = $request->action_id;
        $oid_id = $request->oid_id;

        $action = Action::where(['id' => $action_id])->get();
        $oid = Oid::where(['id' => $oid_id])->get();

        // On resgarde si l'action et l'oid sont présent dans la base
        if($action->count() == 1 & $oid->count() == 1){
            $command_default = CommandsDefault::where([
                'action_id' => $action_id,
                'trademark_id' => $request->trademark_id,
                'model_id' => $request->model_id,
                'oid_id' => $oid_id
            ])->get();
             // On test si la page à déjà été ajouté
            if($command_default->count() == 0){
            $command_default = CommandsDefault::create([
                'action_id' => $action_id,
                'trademark_id' => $request->trademark_id,
                'model_id' => $request->model_id,
                'oid_id' => $oid_id
            ]);
            } else {
                return Response::json($command, 200, [], JSON_NUMERIC_CHECK);
            }
        } else {
            return Response::json("La page associée n'est pas valide", 200, [], JSON_NUMERIC_CHECK);
        }
        return Response::json($command_default, 200, [], JSON_NUMERIC_CHECK);
    }

    public function update(Request $request, $id){
        $command_default = CommandsDefault::find($id);
        $action_id = $request->action_id;
        $oid_id = $request->oid_id;

        $action = Action::where(['id' => $action_id])->get();
        $oid = Oid::where(['id' => $oid_id])->get();

        // On regarde si l'action et l'oid sont présent dans la base
        if($action->count() == 1 & $oid->count() == 1){

            $command_default->action_id = $action_id;
            $command_default->trademark_id = $request->trademark_id;
            $command_default->model_id = $request->model_id;
            $command_default->oid_id = $oid_id;

            $command_default->save();

            return Response::json($command_default, 200, [], JSON_NUMERIC_CHECK);

        } else {

            return Response::json("L'action ou l'OID associé n'est pas valide", 200, [], JSON_NUMERIC_CHECK);

        }

    }
}
