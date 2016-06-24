<?php

use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class CreateLocationsTable extends Migration
{
    /**
    * Run the migrations.
    *
    * @return void
    */
    public function up()
    {
        Schema::create('locations', function (Blueprint $table) {

            $table->engine = 'InnoDB';

            $table->increments('id');
            $table->integer('name')->unique();
            $table->integer('location_id')->unsigned();
            $table->timestamps();
        });

        Schema::table('locations', function ($table) {

            $table->engine = 'InnoDB';

            $table->foreign('location_id')->references('id')->on('locations');
        });

    }

    /**
    * Reverse the migrations.
    *
    * @return void
    */
    public function down()
    {
        Schema::drop('locations');
    }
}
