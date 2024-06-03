<?php

namespace Database\Seeders;

use App\Models\Category;
use Illuminate\Database\Seeder;
use Illuminate\Database\Console\Seeds\WithoutModelEvents;

class CategorySeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        // make 10 fake category
        // Category::factory()->create();

        // manual data input
        Category::create([
            'name' => 'PHP',
            'slug' => 'php',
        ]);

        Category::create([
            'name' => 'Laravel',
            'slug' => 'laravel',
        ]);

        Category::create([
            'name' => 'JavaScript',
            'slug' => 'javascript',
        ]);

        Category::create([
            'name' => 'Vue.js',
            'slug' => 'vue-js',
        ]);

        Category::create([
            'name' => 'React.js',
            'slug' => 'react-js',
        ]);
    }
}
