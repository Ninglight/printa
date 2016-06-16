<?php

use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class CreateCostsDefaultsTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
     public function up()
     {
         Schema::create('costs_defaults', function (Blueprint $table) {
             $table->increments('id');
             $table->integer('model_id');
             $table->integer('page_id');
             $table->float('amount');
             $table->timestamps();
             $table->timestamp('finished_at')->nullable();
         });

         Schema::table('costs_defaults', function ($table) {
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
         Schema::drop('costs_defaults');
     }
}
