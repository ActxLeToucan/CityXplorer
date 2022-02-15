<?php

namespace cityXplorer\models;

use Illuminate\Database\Eloquent\Model;

class Photo extends Model{
    protected $table = 'photo';
    protected $primaryKey='idPhoto';
    public $timestamps = false;

    public function post(){
        return $this->belongsTo('cityXplorer\models\Liste',"idPost");
    }
}