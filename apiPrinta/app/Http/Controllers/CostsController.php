<?php

namespace App\Http\Controllers;

use App\Cost;
use App\Page;
use Illuminate\Http\Request;

use App\Http\Requests;
use Illuminate\Support\Facades\Input;
use Illuminate\Support\Facades\Response;

class CostsController extends Controller
{
    public function index() {
        $costs = Cost::get();
        return Response::json($costs, 200, [], JSON_NUMERIC_CHECK);
    }

    public function show($id) {
        $cost = Cost::find($id);
        return Response::json($cost, 200, [], JSON_NUMERIC_CHECK);
    }

    public function store(Request $request) {
        $cost = [];
        $page_id = $request->page_id;

        $page = Page::where(['id' => $page_id])->get();

        // On verifie que la page existe
        if($page->count() == 1){
            $cost = Cost::where([
                'printer_id' => $request->printer_id,
                'page_id' => $page_id,
                'amount' => $request->amount
            ])->get();
             // On test si la page à déjà été ajouté
            if($cost->count() == 0){
                $cost = Cost::create([
                    'printer_id' => $request->printer_id,
                    'page_id' => $page_id,
                    'amount' => $request->amount
                ]);
            } else {
                return Response::json($cost, 200, [], JSON_NUMERIC_CHECK);
            }
        } else {
            return Response::json("La page associée n'est pas valide", 200, [], JSON_NUMERIC_CHECK);
        }
        return Response::json($cost, 200, [], JSON_NUMERIC_CHECK);
    }

    public function update(Request $request, $id){
        $cost = Cost::find($id);

        $cost->finished_at = date("Y-m-d H:i:s");

        $cost->save();

        return Response::json($cost, 200, [], JSON_NUMERIC_CHECK);
    }

    public function destroy($id){
        $cost = Cost::find($id);

        $cost->delete();

        return Response::json($cost, 200, [], JSON_NUMERIC_CHECK);
    }

}
