<?php

use App\Structure;

class StructuresApiTest extends TestCase {

    public function setUp(){
        parent::setUp();
        \Illuminate\Support\Facades\Artisan::call('migrate');
    }

    public function testGetStructures() {
        $structure = factory(Structure::class)->create(['structure_id' => 0]);
        $this->assertEquals(1, Structure::count());
    }
}
