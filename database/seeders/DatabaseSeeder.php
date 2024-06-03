<?php

namespace Database\Seeders;

// use Illuminate\Database\Console\Seeds\WithoutModelEvents;


use App\Models\Post;
use App\Models\User;
use App\Models\Category;
use function Pest\Laravel\call;
use Illuminate\Database\Seeder;

class DatabaseSeeder extends Seeder
{
    /**
     * Seed the application's database.
     */
    public function run(): void
    {
        // generate fake data using factory
        // User::factory(10)->create();

        // User::factory()->create([
        //     'name' => 'Test User',
        //     'email' => 'test@example.com',
        // ]);

        // manual data input
        // User::create([
        //     'name' => 'Test User',
        //     'email' => 'test@example.com',
        //     'password' => bcrypt('password'),
        // ]);

        // Post factory
        // self::call(PostSeeder::class);
        // or
        // $this->call(PostSeeder::class);

        $this->call([
            CategorySeeder::class,
            UserSeeder::class,
            PostSeeder::class,
        ]);
    }
}
