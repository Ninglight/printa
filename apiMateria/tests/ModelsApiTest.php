<?php

use App\Model;
use App\Trademark;


class ModelsApiTest extends TestCase {

    public function setUp(){
        parent::setUp();
        \Illuminate\Support\Facades\Artisan::call('migrate');
    }

    public function testGetModels() {

        // With Factory
        $trademark = factory(Trademark::class)->create();
        $model = factory(Model::class)->create(['trademark_id' => $trademark->id]);

        $response = $this->call('GET', '/models', ['id' => $model->id]);
        $response = $this->call('GET', '/trademarks', ['id' => $trademark->id]);
        $this->assertEquals(1, Trademark::count());
        $this->assertEquals(1, Model::count());

    }
}
