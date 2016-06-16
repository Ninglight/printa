<?php

/*
|--------------------------------------------------------------------------
| Model Factories
|--------------------------------------------------------------------------
|
| Here you may define all of your model factories. Model factories give
| you a convenient way to create models for testing and seeding your
| database. Just tell the factory how a default model should look.
|
*/

$factory->define(App\User::class, function (Faker\Generator $faker) {
    return [
        'first_name' => $faker->firstName,
        'name' => $faker->name,
        'num' => $faker->uuid,
        'login' => $faker->userName,
        'password' => bcrypt(str_random(10)),
        'remember_token' => str_random(10)
    ];
});

$factory->define(App\Structure::class, function (Faker\Generator $faker) {
    return [
        'acronym' => $faker->randomLetter,
        'name' => $faker->name,
        'type' => $faker->randomLetter
    ];
});

$factory->define(App\UsersStructure::class, function (Faker\Generator $faker) {
    return [
        'created_at' => $faker->dateTime,
        'finished_at' => $faker->dateTime
    ];
});
