<?php

namespace cityXplorer\models;

use Illuminate\Database\Eloquent\Model;

class Post extends Model{
    protected $table = 'poste';
    protected $primaryKey='idPoste';
    public $timestamps = false;

    public function photos() {
        return $this->hasMany('cityXplorer\models\Photo',"idPhoto");
    }
}