<?php

use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class CreateErrorsTable extends Migration
{
    /**
    * Run the migrations.
    *
    * @return void
    */
    public function up()
    {
        Schema::create('errors', function (Blueprint $table) {

            $table->engine = 'InnoDB';

            $table->increments('id');
            $table->integer('type_error_id')->unsigned();
            $table->string('target_table');
            $table->string('target_column')->nullable();
            $table->string('info')->nullable();
            $table->boolean('treated')->default(false);
            $table->timestamps();
        });

        Schema::table('errors', function ($table) {
            $table->foreign('type_error_id')->references('id')->on('types_errors');
        });
    }

    /**
    * Reverse the migrations.
    *
    * @return void
    */
    public function down()
    {
        Schema::drop('errors');
    }
}
