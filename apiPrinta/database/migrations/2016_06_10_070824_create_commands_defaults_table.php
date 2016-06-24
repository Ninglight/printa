<?php

use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class CreateCommandsDefaultsTable extends Migration
{
    /**
    * Run the migrations.
    *
    * @return void
    */
    public function up()
    {
        Schema::create('commands_defaults', function (Blueprint $table) {

            $table->engine = 'InnoDB';

            $table->increments('id');
            $table->integer('action_id')->unsigned();
            $table->integer('trademark_id')->nullable();
            $table->integer('model_id')->nullable();
            $table->integer('oid_id')->unsigned();
            $table->timestamps();
        });

        Schema::table('commands_defaults', function ($table) {
            $table->foreign('action_id')->references('id')->on('actions');
            $table->foreign('oid_id')->references('id')->on('oids');
        });
    }

    /**
    * Reverse the migrations.
    *
    * @return void
    */
    public function down()
    {
        Schema::drop('commands_defaults');
    }
}
