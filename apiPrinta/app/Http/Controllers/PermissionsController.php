<?php

namespace App\Http\Controllers;

use App\Permission;
use Illuminate\Http\Request;

use App\Http\Requests;
use Illuminate\Support\Facades\Input;
use Illuminate\Support\Facades\Response;

class PermissionsController extends Controller
{
    public function index() {
        $permissions = Permission::get();
        return Response::json($permissions, 200, [], JSON_NUMERIC_CHECK);
    }

    public function show($id) {
        $permission = Permission::find($id);
        return Response::json($permission, 200, [], JSON_NUMERIC_CHECK);
    }

    public function store(Request $request) {

        $name = $request->name;

        $permission_test = Permission::where(['name' => $name])->get();

        if($permission_test->count() == 0) {

            $permission = Permission::create([
                'name' => $name
            ]);

        } else {

            return Response::json("Permission exists", 200, [], JSON_NUMERIC_CHECK);

        }

        return Response::json($permission, 200, [], JSON_NUMERIC_CHECK);

    }

    public function update(Request $request, $id){
        $permission = Permission::find($id);

        $name = $request->name;

        $permission_test = Permission::where(['name' => $name])->get();

        if($permission_test->count() == 0) {

            $permission->name = $name;
            $permission->save();

        } else {

            return Response::json("Permission exists", 200, [], JSON_NUMERIC_CHECK);

        }

        return Response::json($permission, 200, [], JSON_NUMERIC_CHECK);

    }
}
