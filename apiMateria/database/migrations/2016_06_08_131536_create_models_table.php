<?php

use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class CreateModelsTable extends Migration
{
    /**
    * Run the migrations.
    *
    * @return void
    */
    public function up()
    {
        Schema::create('models', function (Blueprint $table) {

            $table->engine = 'InnoDB';

            $table->increments('id');
            $table->string('name');
            $table->integer('trademark_id')->unsigned();
            $table->timestamps();
        });

        Schema::table('models', function ($table) {

            $table->engine = 'InnoDB';

            $table->foreign('trademark_id')->references('id')->on('trademarks');
        });
    }

    /**
    * Reverse the migrations.
    *
    * @return void
    */
    public function down()
    {
        Schema::drop('models');
    }
}
