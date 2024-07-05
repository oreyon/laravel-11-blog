<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class Post extends Model
{
    use HasFactory;
    protected $fillable = ['title', 'slug', 'author_id', 'body', 'category_id'];

    // eager loading for relationships tables
    protected $with = ['author', 'category'];

    public static function find($slug)
    {
        return self::all()->firstWhere('slug', $slug);
    }

    // author relation
    public function author(): BelongsTo
    {
        return $this->belongsTo(User::class);
    }

    public function category(): BelongsTo
    {
        return $this->BelongsTo(Category::class);
    }
}
