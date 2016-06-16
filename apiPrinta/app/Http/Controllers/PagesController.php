<?php

namespace App\Http\Controllers;

use App\Page;
use App\Type;
use App\Color;
use App\Side;
use App\Format;
use Illuminate\Http\Request;

use App\Http\Requests;
use Illuminate\Support\Facades\Input;
use Illuminate\Support\Facades\Response;

class PagesController extends Controller
{
    public function index() {
        $pages = Page::get();
        return Response::json($pages, 200, [], JSON_NUMERIC_CHECK);
    }

    public function show($id) {
        $page = Page::find($id);
        return Response::json($page, 200, [], JSON_NUMERIC_CHECK);
    }

    public function store(Request $request) {
        $page = [];
        $type_id = $request->type_id;
        $format_id = $request->format_id;
        $side_id = $request->side_id;
        $color_id = $request->color_id;

        $type = Type::where(['id' => $type_id])->get();
        $color = Color::where(['id' => $color_id])->get();
        $side = Side::where(['id' => $side_id])->get();
        $format = Format::where(['id' => $format_id])->get();

         // On test si les références existents
        if($type->count() == 1 & $color->count() == 1 & $side->count() == 1 & $format->count() == 1){
            $page = Page::where([
                'type_id' => $type_id,
                'format_id' => $format_id,
                'side_id' => $side_id,
                'color_id' => $color_id
            ])->get();
             // On test si la page à déjà été ajouté
            if($page->count() == 0){
                $page = Page::create([
                    'type_id' => $type_id,
                    'format_id' => $format_id,
                    'side_id' => $side_id,
                    'color_id' => $color_id
                ]);
            } else {
                return Response::json($page, 200, [], JSON_NUMERIC_CHECK);
            }
        } else {
            return Response::json('Une ou des références sont erronées', 200, [], JSON_NUMERIC_CHECK);
        }
        return Response::json($page, 200, [], JSON_NUMERIC_CHECK);
    }

    public function destroy($id){
        $page = Page::find($id);

        $page->delete();

        return Response::json($page, 200, [], JSON_NUMERIC_CHECK);
    }
}
