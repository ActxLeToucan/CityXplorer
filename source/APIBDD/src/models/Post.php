<?php

namespace cityXplorer\models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\HasMany;

class Post extends Model{
    protected $table = 'post';
    protected $primaryKey='idPost';
    public $timestamps = false;

    public function photos(): HasMany {
        return $this->hasMany('cityXplorer\models\Photo',"idPhoto");
    }
}