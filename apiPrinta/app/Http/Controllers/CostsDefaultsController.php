<?php

namespace App\Http\Controllers;

use App\CostsDefault;
use App\Page;
use Illuminate\Http\Request;

use App\Http\Requests;
use Illuminate\Support\Facades\Input;
use Illuminate\Support\Facades\Response;

class CostsDefaultController extends Controller
{
    public function index() {
        $cost_defaults = CostsDefault::get();
        return Response::json($cost_defaults, 200, [], JSON_NUMERIC_CHECK);
    }

    public function show($id) {
        $cost_default = CostsDefault::find($id);
        return Response::json($cost_default, 200, [], JSON_NUMERIC_CHECK);
    }

    public function store(Request $request) {
        $cost_default = [];
        $page_id = $request->page_id;

        $page = Page::where(['id' => $page_id])->get();

        // On verifie que la page existe
        if($page->count() == 1){

            $cost_default = CostsDefault::where([
                'model_id' => $request->model_id,
                'page_id' => $page_id,
                'amount' => $request->amount
            ])->get();

             // On test si le cout a déjà été ajouté
            if($cost_default->count() == 0){

                $cost_default = CostsDefault::create([
                    'model_id' => $request->model_id,
                    'page_id' => $page_id,
                    'amount' => $request->amount
                ]);

            } else {

                return Response::json($cost_default, 200, [], JSON_NUMERIC_CHECK);

            }
        } else {

            return Response::json("La page associée n'est pas valide", 200, [], JSON_NUMERIC_CHECK);

        }

        return Response::json($cost_default, 200, [], JSON_NUMERIC_CHECK);

    }

    public function update(Request $request, $id){
        $cost_default = CostsDefault::find($id);

        $cost_default->finished_at = date("Y-m-d H:i:s");

        $cost_default->save();

        return Response::json($cost_default, 200, [], JSON_NUMERIC_CHECK);
    }

    public function destroy($id){
        $cost_default = CostsDefault::find($id);

        $cost_default->delete();

        return Response::json($cost_default, 200, [], JSON_NUMERIC_CHECK);
    }

}
