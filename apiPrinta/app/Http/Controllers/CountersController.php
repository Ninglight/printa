<?php

namespace App\Http\Controllers;

use App\Counter;
use App\Page;
use Illuminate\Http\Request;

use App\Http\Requests;
use Illuminate\Support\Facades\Input;
use Illuminate\Support\Facades\Response;

class CountersController extends Controller
{
    public function index() {
        $counters = Counter::get();
        return Response::json($counters, 200, [], JSON_NUMERIC_CHECK);
    }

    public function show($id) {
        $counter = Counter::find($id);
        return Response::json($counter, 200, [], JSON_NUMERIC_CHECK);
    }

    public function store(Request $request) {
        $counter = [];
        $page_id = $request->page_id;

        $page = Page::where(['id' => $page_id])->get();

        if($page->count() == 1){
            $counter = Counter::create([
                'printer_id' => $request->printer_id,
                'quantity' => $request->quantity,
                'page_id' => $page_id,
                'created_at' => date("Y-m-d H:i:s")
            ]);
        } else {
            return Response::json("La page associée n'est pas valide", 200, [], JSON_NUMERIC_CHECK);
        }
        return Response::json($counter, 200, [], JSON_NUMERIC_CHECK);
    }

    public function destroy($id){
        $counter = Counter::find($id);

        $counter->delete();

        return Response::json($counter, 200, [], JSON_NUMERIC_CHECK);
    }
}
