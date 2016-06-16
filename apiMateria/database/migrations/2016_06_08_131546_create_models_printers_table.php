<?php

use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class CreateModelsPrintersTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
     public function up()
     {
         Schema::create('models_printers', function (Blueprint $table) {
             $table->integer('model_id');
             $table->integer('printer_id');
             $table->timestamp('created_at');
             $table->timestamp('finished_at')->nullable();
         });

         Schema::table('models_printers', function ($table) {
             $table->primary(['model_id', 'printer_id']);
             $table->foreign('model_id')->references('id')->on('models');
             $table->foreign('printer_id')->references('id')->on('printers');
         });

     }

     /**
      * Reverse the migrations.
      *
      * @return void
      */
     public function down()
     {
         Schema::drop('models_printers');
     }
}
