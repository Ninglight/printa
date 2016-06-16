<?php

namespace App\Http\Controllers;

use App\UsersStructure;
use App\User;
use App\Structure;
use Illuminate\Http\Request;

use App\Http\Requests;
use Illuminate\Support\Facades\Input;
use Illuminate\Support\Facades\Response;

class UsersStructuresController extends Controller
{
    public function index() {
        $user_id = Input::get('user_id');
        $structure_id = Input::get('structure_id');

        if($user_id){
            if($structure_id){
                $users_structures = UsersStructure::where(['user_id' => Input::get('user_id'), 'structure_id' => Input::get('structure_id')])->get();
                return Response::json($users_structures, 200, [], JSON_NUMERIC_CHECK);
            } else {
                $users_structures = UsersStructure::where(['user_id' => Input::get('user_id')])->get();
                return Response::json($users_structures, 200, [], JSON_NUMERIC_CHECK);
            }
        } elseif($structure_id) {
            $users_structures = UsersStructure::where(['structure_id' => Input::get('structure_id')])->get();
            return Response::json($users_structures, 200, [], JSON_NUMERIC_CHECK);return Response::json("Give arguments", 422);
        }

        $users_structures = UsersStructure::all();
        return Response::json($users_structures, 200, [], JSON_NUMERIC_CHECK);

    }

    public function store(Requests\StoreCommentRequest $request){
        $user_id = Input::get('user_id');
        $structure_id = Input::get('structure_id');
        if (User::where(['id' => $user_id])->exists()) {
            if (Structure::where(['id' => $structure_id])->exists()){
                $userstructure = UsersStructure::create([
                    'user_id' => $user_id,
                    'structure_id' => $structure_id,
                    'created_at' => date("Y-m-d H:i:s")
                ]);
                return Response::json($userstructure, 200, [], JSON_NUMERIC_CHECK);
            } else {
                return Response::json("Cette relation n'est pas possible (Structure inexistant)", 422);
            }
        } else {
            return Response::json("Cette relation n'est pas possible (Utilisateur inexistant)", 422);
        }
    }

}
