<?php

use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class CreateUsersStructuresTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('users_structures', function (Blueprint $table) {

            $table->engine = 'InnoDB';

            $table->integer('user_id')->unsigned();
            $table->integer('structure_id')->unsigned();
            $table->timestamp('created_at');
            $table->timestamp('finished_at')->nullable();
        });

        Schema::table('users_structures', function ($table) {

            $table->engine = 'InnoDB';

            $table->primary(['user_id', 'structure_id']);
            $table->foreign('user_id')->references('id')->on('users');
            $table->foreign('structure_id')->references('id')->on('structures');
        });

    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::drop('users_structures');
    }
}
