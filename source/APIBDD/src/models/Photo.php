<?php

namespace cityXplorer\models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class Photo extends Model{
    protected $table = 'photo';
    protected $primaryKey='idPhoto';
    public $timestamps = false;

    public function post(): BelongsTo {
        return $this->belongsTo('cityXplorer\models\Liste',"idPost");
    }
}