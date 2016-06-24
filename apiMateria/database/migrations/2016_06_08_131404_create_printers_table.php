<?php

use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class CreatePrintersTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('printers', function (Blueprint $table) {

            $table->engine = 'InnoDB';

            $table->increments('id');
            $table->string('name');
            $table->string('serial_number')->unique();
            $table->string('inventory_number')->unique();
            $table->integer('location_id')->unsigned();
            $table->timestamps();
        });

        Schema::table('printers', function ($table) {

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
        Schema::drop('printers');
    }
}
