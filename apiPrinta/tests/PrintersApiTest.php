<?php

use App\Model;
use App\ModelsPrinter;
use App\Printer;
use App\Trademark;
use App\Statu;

class PrintersApiTest extends TestCase {

    public function setUp(){
        parent::setUp();
        \Illuminate\Support\Facades\Artisan::call('migrate');
    }

    public function testGetPrinters() {

        $trademark = factory(Trademark::class)->create();
        $model = factory(Model::class)->create(['trademark_id' => $trademark->id]);

        $status = factory(Statu::class)->create();
        $printer = factory(Printer::class)->create(['status_id' => $status->id]);

        $model_printer = factory(ModelsPrinter::class)->create(['model_id' => $model->id, 'printer_id' => $printer->id]);

        $response = $this->call('GET', '/trademarks', ['id' => $trademark->id]);
        $response = $this->call('GET', '/models', ['id' => $model->id]);
        $response = $this->call('GET', '/status', ['id' => $status->id]);
        $response = $this->call('GET', '/printers', ['id' => $printer->id]);
        $response = $this->call('GET', '/models_printers', ['id' => $model_printer->id]);

        $this->assertEquals(1, Trademark::count());
        $this->assertEquals(1, Model::count());
        $this->assertEquals(1, Statu::count());
        $this->assertEquals(1, Printer::count());
        $this->assertEquals(1, ModelsPrinter::count());

    }

}
