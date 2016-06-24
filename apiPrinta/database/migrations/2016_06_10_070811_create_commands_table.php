<?php

use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class CreateCommandsTable extends Migration
{
    /**
    * Run the migrations.
    *
    * @return void
    */
    public function up()
    {
        Schema::create('commands', function (Blueprint $table) {

            $table->engine = 'InnoDB';

            $table->increments('id');
            $table->integer('action_id')->unsigned();
            $table->integer('model_id')->nullable();
            $table->integer('oid_id')->unsigned();
            $table->timestamps();
        });

        Schema::table('commands', function ($table) {

            $table->engine = 'InnoDB';

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
        Schema::drop('commands');
    }
}
