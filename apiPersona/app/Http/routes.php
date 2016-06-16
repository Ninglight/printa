<?php

/*
|--------------------------------------------------------------------------
| Application Routes
|--------------------------------------------------------------------------
|
| Here is where you can register all of the routes for an application.
| It's a breeze. Simply tell Laravel the URIs it should respond to
| and give it the controller to call when that URI is requested.
|
*/

// CORS
if( ! $this->app->environment('testing')) {
    header('Access-Control-Allow-Origin: ' . env('CORS_ORIGIN', '*') );
    header('Access-Control-Allow-Methods: GET, POST, OPTIONS, PUT, DELETE, PATCH');
    header('Access-Control-Allow-Headers: Origin, Content-Type, Accept, Authorization, X-Request-With');
    header('Access-Control-Allow-Credentials: true');
}

// CORS
//header('Access-Control-Allow-Origin: *');
//header('Access-Control-Allow-Credentials: true');

Route::get('/', function () {
    return view('welcome');

});

Route::group(['middleware' => ['web']], function() {
    Route::resource('users', 'UsersController');
    Route::resource('structures', 'StructuresController');
    Route::resource('users_structures', 'UsersStructuresController');
});
