<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('posts', function (Blueprint $table) {
            $table->id();
            $table->string('title');
            $table->string('slug')->unique();
            // author_id is a foreign key that references the id column in the users table
            $table->foreignId('author_id')->constrained(
                table: 'users',
                indexName: 'posts_author_id_foreign',
            );
            $table->foreignId('category_id')->constrained(
                table: 'categories',
                indexName: 'posts_category_id_foreign',
            );
            $table->text('body');
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('posts');
    }
};
