<?php

namespace cityXplorer\models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;

class Photo extends Model{
    protected $table = 'photo';
    protected $primaryKey='idPhoto';
    public $timestamps = false;

    public function post(): BelongsTo {
        return $this->belongsTo('cityXplorer\models\Post',"idPost");
    }

    public function user(): BelongsTo {
        return $this->belongsTo('cityXplorer\models\User', 'idUser');
    }
}