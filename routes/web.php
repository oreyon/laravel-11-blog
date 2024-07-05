<?php

use App\Models\Post;
use App\Models\User;
use App\Models\Category;
use Illuminate\Support\Arr;
use Illuminate\Support\Facades\Route;

// Route::get('/', function () {
//     return view('welcome');
// });

Route::get('/', function () {
    return view('home', [
        'title' => 'Home',
    ]);
});

Route::get('/about', function () {
    return view('about', [
        'title' => 'About',
        'name' => 'Oreyon',
    ]);
});

Route::get('/posts', function () {
    // make eager loading for relationships tables
    // $posts = Post::with(['author', 'category'])->latest()->get();

    return view('posts', [
        'title' => 'Blog',
        'posts' => Post::latest()->get(),
    ]);
});

Route::get('/posts/{post:slug}', function (Post $post) {
    return view('post', [
        'title' => 'Single Post',
        'post' => $post,
    ]);
});

Route::get('/authors/{user:username}', function (User $user) {
    // lazy eager loading
    // $posts = $user->posts->load(['category', 'author']);
    return view('posts', [
        'title' => count($user->posts) . ' Posts by ' . $user->username,
        'posts' => $user->posts,
    ]);
});

Route::get('/categories/{category:slug}', function (Category $category) {
    // lazy eager loading
    // $posts = $category->posts->load(['category', 'author']);
    return view('posts', [
        'title' => 'Categories with ' . $category->slug,
        'posts' => $category->posts,
    ]);
});

Route::get('/contact', function () {
    return view('contact', [
        'title' => 'Contact',
    ]);
});
