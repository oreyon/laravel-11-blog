<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Post extends Model
{
    protected $fillable = ['title', 'slug', 'author', 'body'];

    public static function find($slug)
    {
        return self::all()->firstWhere('slug', $slug);
    }
    use HasFactory;
}
