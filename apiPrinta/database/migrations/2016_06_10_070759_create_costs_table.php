<?php

use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class CreateCostsTable extends Migration
{
    /**
    * Run the migrations.
    *
    * @return void
    */
    public function up()
    {
        Schema::create('costs', function (Blueprint $table) {

            $table->engine = 'InnoDB';

            $table->increments('id');
            $table->integer('printer_id');
            $table->integer('page_id')->unsigned();
            $table->float('amount');
            $table->timestamps();
            $table->timestamp('finished_at')->nullable();
        });

        Schema::table('costs', function ($table) {

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
        Schema::drop('costs');
    }
}
