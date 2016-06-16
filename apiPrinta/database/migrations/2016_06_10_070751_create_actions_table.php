<?php

use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class CreateActionsTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
     public function up()
     {
         Schema::create('actions', function (Blueprint $table) {
             $table->increments('id');
             $table->string('name')->unique();
             $table->integer('page_id');
             $table->timestamps();
         });

         Schema::table('actions', function ($table) {
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
         Schema::drop('actions');
     }
}
