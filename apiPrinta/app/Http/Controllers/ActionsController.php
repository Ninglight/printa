<?php

namespace App\Http\Controllers;

use App\Action;
use App\Page;
use Illuminate\Http\Request;

use App\Http\Requests;
use Illuminate\Support\Facades\Input;
use Illuminate\Support\Facades\Response;

class ActionsController extends Controller
{
    public function index() {
        $actions = Action::get();
        return Response::json($actions, 200, [], JSON_NUMERIC_CHECK);
    }

    public function show($id) {
        $action = Action::find($id);
        return Response::json($action, 200, [], JSON_NUMERIC_CHECK);
    }

    public function store(Request $request) {
        $name = $request->name;
        $page_id = $request->page_id;

        $action = Action::where(['name' => $name])->get();
        $page = Page::where(['id' => $page_id])->get();

        if($action->count() == 0 & $page->count() == 1){
            $action = Action::create([
                'name' => $name,
                'page_id' => $page_id
            ]);
        } elseif ($action->count() == 0) {
            return Response::json("Le nom existe déjà", 200, [], JSON_NUMERIC_CHECK);
        } elseif ($page->count() > 1) {
            return Response::json("La page associée n'est pas valide", 200, [], JSON_NUMERIC_CHECK);
        }
        return Response::json($action, 200, [], JSON_NUMERIC_CHECK);
    }

    public function update(Request $request, $id){
        $action = Action::find($id);
        $page_id = $request->page_id;

        $page = Page::where(['id' => $page_id])->get();

        if($page->count() == 1){

            $action->name = $request->name;
            $action->page_id = $page_id;

            $action->save();
            return Response::json($action, 200, [], JSON_NUMERIC_CHECK);

        } else {

            return Response::json("La page associée n'est pas valide", 200, [], JSON_NUMERIC_CHECK);

        }

    }



}
