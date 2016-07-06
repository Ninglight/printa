<?php

use Illuminate\Database\Seeder;

class DatabaseSeeder extends Seeder
{
    /**
    * Run the database seeds.
    *
    * @return void
    */
    public function run()
    {

        $users = array(
            ['first_name' => 'Valentin',
            'name' => 'Bourreau',
            'num' => '16882',
            'login' => 'v.bourreau',
            'phone' => '0631914392',
            'email' => 'v.bourreau@maine-et-loire.fr',
            'password' => Hash::make('secret')],
            ['first_name' => 'Gérard',
            'name' => 'Phillipe',
            'num' => '124536',
            'login' => 'g.phillipe',
            'phone' => '0212457823',
            'email' => 'g.phillipe@maine-et-loire.fr',
            'password' => Hash::make('secret')],
            ['first_name' => 'Aline',
            'name' => 'Kensel',
            'num' => '457812',
            'login' => 'a.kensel',
            'phone' => '0245126587',
            'email' => 'a.kensel@maine-et-loire.fr',
            'password' => Hash::make('secret')],
            ['first_name' => 'Dominique',
            'name' => 'Veille',
            'num' => '478569',
            'login' => 'd.veille',
            'phone' => '0232548798',
            'email' => 'd.veille@maine-et-loire.fr',
            'password' => Hash::make('secret')],
        );

        // Loop through each user above and create the record for them in the database
        foreach ($users as $user)
        {
            DB::table('users')->insert($user);
        }

        $structures = array(
            ['acronym' => 'DLSI',
            'name' => 'Direction Logistique et Système Informatique',
            'type' => 'A',
            'structure_id' => NULL],
            ['acronym' => 'DRH',
            'name' => 'Direction des Ressources Humaines',
            'type' => 'A',
            'structure_id' => NULL]
        );

        // Loop through each user above and create the record for them in the database
        foreach ($structures as $structure)
        {
            DB::table('structures')->insert($structure);
        }


    }
}
