<?php

use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class CreatePrintersStatusTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('printers_status', function (Blueprint $table) {
            $table->integer('printer_id');
            $table->integer('status_id');
            $table->timestamp('created_at');
            $table->timestamp('finished_at')->nullable();
        });

        Schema::table('printers_status', function ($table) {
            $table->primary(['printer_id', 'status_id']);
            $table->foreign('status_id')->references('id')->on('status');
        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::drop('printers_status');
    }
}
