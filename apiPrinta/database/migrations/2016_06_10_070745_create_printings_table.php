<?php

use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class CreatePrintingsTable extends Migration
{
    /**
    * Run the migrations.
    *
    * @return void
    */
    public function up()
    {
        Schema::create('printings', function (Blueprint $table) {

            $table->engine = 'InnoDB';

            $table->increments('id');
            $table->integer('user_id');
            $table->integer('printer_id');
            $table->timestamp('created_at');
            $table->integer('quantity');
            $table->integer('page_id')->unsigned();

        });

        Schema::table('printings', function ($table) {

            $table->engine = 'InnoDB';

            $table->foreign('page_id')->references('id')->on('pages');
        });
    }

    /**
    * Reverse the migrations.
    *
    * @return void
    */
    public function down()
    {
        Schema::drop('printings');
    }
}
