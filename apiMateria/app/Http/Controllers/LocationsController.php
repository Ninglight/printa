<?php

namespace App\Http\Controllers;

use App\Location;
use Illuminate\Http\Request;

use App\Http\Requests;
use Illuminate\Support\Facades\Input;
use Illuminate\Support\Facades\Response;

class LocationsController extends Controller
{
    public function index() {
        $locations = Location::get();
        return Response::json($locations, 200, [], JSON_NUMERIC_CHECK);
    }

    public function show($id) {
        $location = Location::find($id);
        return Response::json($location, 200, [], JSON_NUMERIC_CHECK);
    }

    public function store(Request $request) {
        $location = [];
        $name = $request->name;
        $location_id = $request->location_id;

        $location_test_name = Location::where(['name' => $name])->get();

        if($location_test_name->count() == 0){

            $location = Location::create([
                'name' => $name,
                'location_id' => $location_id
            ]);

        } else {

            return Response::json("location name exists", 200, [], JSON_NUMERIC_CHECK);

        }

        return Response::json($location, 200, [], JSON_NUMERIC_CHECK);

    }

    public function update(Request $request, $id){
        $location = Location::find($id);

        $name = $request->name;
        $location_id = $request->location_id;

        $location_test_name = Location::where(['name' => $name])->get();

        if($location_test_name->count() == 0){

            $location->name = $name;
            $location->location_id = $location_id;
            $location->save();

        } else {

            return Response::json("location name exists", 200, [], JSON_NUMERIC_CHECK);

        }

        return Response::json($location, 200, [], JSON_NUMERIC_CHECK);
    }
}
