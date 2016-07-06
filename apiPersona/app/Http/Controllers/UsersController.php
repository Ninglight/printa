<?php

namespace App\Http\Controllers;

use App\User;
use App\UsersStructure;
use App\Structure;
use Illuminate\Http\Request;

use App\Http\Requests;
use Illuminate\Support\Facades\Input;
use Illuminate\Support\Facades\Response;


class UsersController extends Controller
{
    public function index() {
        if(Input::get('login')){
            $user = User::where(['login' => Input::get('login')])->get();
            return Response::json($user, 200, [], JSON_NUMERIC_CHECK);
        }
        $users = User::all();

        return Response::json($users, 200, [], JSON_NUMERIC_CHECK);
    }

    public function show() {
        $user_login = Input::get('login');
        $user = User::where(['login' => $user_login])->get();
        return Response::json($user, 200, [], JSON_NUMERIC_CHECK);
    }

}
