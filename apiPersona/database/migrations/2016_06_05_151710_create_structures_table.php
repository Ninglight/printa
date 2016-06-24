<?php

use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class CreateStructuresTable extends Migration
{
    /**
    * Run the migrations.
    *
    * @return void
    */
    public function up()
    {
        Schema::create('structures', function (Blueprint $table) {

            $table->engine = 'InnoDB';

            $table->increments('id');
            $table->string('acronym')->unique();
            $table->string('name');
            $table->string('type');
            $table->integer('structure_id')->unsigned();
            $table->timestamps();
        });

        Schema::table('structures', function ($table) {

            $table->engine = 'InnoDB';

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
        Schema::drop('structures');
    }
}
