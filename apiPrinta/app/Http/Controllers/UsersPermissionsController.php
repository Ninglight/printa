<?php

namespace App\Http\Controllers;

use App\UsersPermission;
use App\Permission;
use Illuminate\Http\Request;

use App\Http\Requests;
use Illuminate\Support\Facades\Input;
use Illuminate\Support\Facades\Response;

class UsersPermissionsController extends Controller
{
    public function index() {
        $permission_id = Input::get('permission_id');
        $user_id = Input::get('user_id');

        if($permission_id){

            if($user_id){

                $users_permissions = UsersPermission::where(['permissions_id' => $permission_id, 'user_id' => $user_id])->get();
                return Response::json($users_permissions, 200, [], JSON_NUMERIC_CHECK);

            } else {

                $users_permissions = UsersPermission::where(['model_id' => $permission_id])->get();
                return Response::json($users_permissions, 200, [], JSON_NUMERIC_CHECK);

            }
        } elseif($user_id) {

            $users_permissions = UsersPermission::where(['user_id' => $user_id])->get();
            return Response::json($users_permissions, 200, [], JSON_NUMERIC_CHECK);

        }

        $users_permissions = UsersPermission::all();
        return Response::json($users_permissions, 200, [], JSON_NUMERIC_CHECK);

    }

    public function store(Request $request) {
        $user_permission = [];

        $permission_id = $request->permission_id;

        $permission_test = Permission::where(['id' => $permission_id])->get();

        if($permission_test->count() == 1) {

            $user_permission = UsersPermission::create([
                'permissions_id' => $permission_id,
                'user_id' => $request->user_id
            ]);

        } else {

            return Response::json("Permission not exists", 200, [], JSON_NUMERIC_CHECK);

        }

        return Response::json($user_permission, 200, [], JSON_NUMERIC_CHECK);

    }

    public function update(Request $request, $id){
        $user_permission = UsersPermission::find($id);

        $permission_id = $request->permission_id;

        $permission_test = Permission::where(['id' => $permission_id])->get();

        if($permission_test->count() == 1){

            $user_permission->permission_id = $permission_id;
            $user_permission->user_id = $user_id;
            $user_permission->save();

        }

        return Response::json($user_permission, 200, [], JSON_NUMERIC_CHECK);

    }


}
