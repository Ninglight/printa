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

$factory->define(App\Model::class, function (Faker\Generator $faker) {
    return [
        'name' => $faker->name
    ];
});

$factory->define(App\ModelsPrinter::class, function (Faker\Generator $faker) {
    return [
        'created_at' => $faker->dateTime,
        'finished_at' => $faker->dateTime
    ];
});

$factory->define(App\Printer::class, function (Faker\Generator $faker) {
    return [
        'name' => $faker->name,
        'serial_number' => $faker->uuid,
        'inventory_number' => $faker->uuid
    ];
});

$factory->define(App\Statu::class, function (Faker\Generator $faker) {
    return [
        'name' => $faker->name
    ];
});

$factory->define(App\Trademark::class, function (Faker\Generator $faker) {
    return [
        'name' => $faker->name
    ];
});
