<?php

use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class CreateCountersTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
     public function up()
     {
         Schema::create('counters', function (Blueprint $table) {
             $table->increments('id');
             $table->integer('printer_id');
             $table->timestamp('created_at');
             $table->integer('quantity');
             $table->integer('page_id');

         });

         Schema::table('counters', function ($table) {
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
         Schema::drop('counters');
     }
}
