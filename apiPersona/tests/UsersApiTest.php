<?php

use App\User;
use App\Structure;
use App\UsersStructure;

class UsersApiTest extends TestCase {

    public function setUp(){
        parent::setUp();
        \Illuminate\Support\Facades\Artisan::call('migrate');
    }

    public function testGetUsers() {

        // Without Factory
        //$user = User::create(['first_name' => 'Valentin', 'name' => 'Bourreau', 'num' => '16882', 'login' => 'v.bourreau', 'password' => '123']);

        // With Factory
        $structure = factory(Structure::class)->create(['structure_id' => 0]);
        $user = factory(User::class)->create();
        $users_structure = factory(UsersStructure::class)->create(['user_id' => $user->id, 'structure_id' => $structure->id]);

        $response = $this->call('GET', '/users', ['id' => $user->id]);
        $response = $this->call('GET', '/structures', ['id' => $structure->id]);
        $this->assertEquals(1, Structure::count());
        $this->assertEquals(1, User::count());
        $this->assertEquals(1, UsersStructure::count());

    }
}
