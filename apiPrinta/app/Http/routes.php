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

Route::get('/', function () {
    return view('welcome');
});

Route::group(['middleware' => ['web']], function() {
    Route::resource('printings', 'PrintingsController');
    Route::resource('counters', 'CountersController');
    Route::resource('formats', 'FormatsController');
    Route::resource('sides', 'SidesController');
    Route::resource('colors', 'ColorsController');
    Route::resource('types', 'TypesController');
    Route::resource('oids', 'OidsController');
    Route::resource('pages', 'PagesController');
    Route::resource('actions', 'ActionsController');
    Route::resource('costs', 'CostsController');
    Route::resource('costs_defaults', 'CostsDefaultsController');
    Route::resource('commands', 'CommandsController');
    Route::resource('commands_defaults', 'CommandsDefaultsController');
    Route::resource('errors', 'ErrorsController');
    Route::resource('types_errors', 'TypesErrorsController');
    Route::resource('status', 'StatusController');
    Route::resource('printers_status', 'PrintersStatusController');
    Route::resource('maintenances', 'MaintenancesController');
    Route::resource('printers_maintenances', 'PrintersMaintenancesController');
    Route::resource('permissions', 'PermissionsController');
    Route::resource('users_permissions', 'UsersPermissionsController');
});
