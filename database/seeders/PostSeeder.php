<?php

namespace Database\Seeders;

use App\Models\Post;
use App\Models\User;
use App\Models\Category;
use Illuminate\Database\Seeder;
use Illuminate\Database\Console\Seeds\WithoutModelEvents;

class PostSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        // generate fake data using factory
        // Post::factory(100)
        //     ->recycle(User::factory(5)->create())
        //     ->recycle(Category::factory(5)->create())
        //     ->create();

        // or

        Post::factory(100)
            ->recycle([
                User::all(),
                Category::all(),
            ])->create();
    }
}
