<?php

use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class CreatePagesTable extends Migration
{
    /**
    * Run the migrations.
    *
    * @return void
    */
    public function up()
    {
        Schema::create('pages', function (Blueprint $table) {

            $table->engine = 'InnoDB';

            $table->increments('id');
            $table->integer('type_id')->unsigned();
            $table->integer('format_id')->unsigned();
            $table->integer('side_id')->unsigned();
            $table->integer('color_id')->unsigned();
            $table->timestamps();
        });

        Schema::table('pages', function ($table) {

            $table->engine = 'InnoDB';

            $table->foreign('type_id')->references('id')->on('types');
            $table->foreign('format_id')->references('id')->on('formats');
            $table->foreign('side_id')->references('id')->on('sides');
            $table->foreign('color_id')->references('id')->on('colors');
        });
    }

    /**
    * Reverse the migrations.
    *
    * @return void
    */
    public function down()
    {
        Schema::drop('pages');
    }
}
