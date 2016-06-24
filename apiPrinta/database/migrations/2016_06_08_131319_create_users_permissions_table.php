<?php

use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class CreateUsersPermissionsTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('users_permissions', function (Blueprint $table) {

            $table->engine = 'InnoDB';

            $table->integer('user_id');
            $table->integer('permission_id')->unsigned();
            $table->timestamps();
        });

        Schema::table('users_permissions', function ($table) {

            $table->engine = 'InnoDB';

            $table->primary(['user_id', 'permission_id']);
            $table->foreign('permission_id')->references('id')->on('permissions');
        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::drop('users_permissions');
    }
}
