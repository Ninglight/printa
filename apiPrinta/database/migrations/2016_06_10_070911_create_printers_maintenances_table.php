<?php

use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class CreatePrintersMaintenancesTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('printers_maintenances', function (Blueprint $table) {
            $table->integer('printer_id');
            $table->integer('maintenance_id');
            $table->timestamp('created_at');
            $table->timestamp('finished_at')->nullable();
        });

        Schema::table('printers_maintenances', function ($table) {
            $table->primary(['printer_id', 'maintenance_id']);
            $table->foreign('maintenance_id')->references('id')->on('maintenances');
        });

    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::drop('printers_maintenances');
    }
}
