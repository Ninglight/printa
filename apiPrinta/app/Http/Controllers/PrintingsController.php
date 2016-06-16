<?php

namespace App\Http\Controllers;

use App\Printing;
use App\Page;
use Illuminate\Http\Request;

use App\Http\Requests;
use Illuminate\Support\Facades\Input;
use Illuminate\Support\Facades\Response;

class PrintingsController extends Controller
{
    public function index() {
        $printings = Printing::get();
        return Response::json($printings, 200, [], JSON_NUMERIC_CHECK);
    }

    public function show($id) {
        $printing = Printing::find($id);
        return Response::json($printing, 200, [], JSON_NUMERIC_CHECK);
    }

    public function store(Request $request) {
        $printing = [];
        $page_id = $request->page_id;

        $page = Page::where(['id' => $page_id])->get();

        if($page->count() == 1){
            $printing = Printing::create([
                'user_id' => $request->user_id,
                'printer_id' => $request->printer_id,
                'quantity' => $request->quantity,
                'page_id' => $page_id,
                'created_at' => date("Y-m-d H:i:s")
            ]);
        } else {
            return Response::json("La page associée n'est pas valide", 200, [], JSON_NUMERIC_CHECK);
        }
        return Response::json($printing, 200, [], JSON_NUMERIC_CHECK);
    }

    public function destroy($id){
        $printing = Printing::find($id);

        $printing->delete();

        return Response::json($printing, 200, [], JSON_NUMERIC_CHECK);
    }
}
