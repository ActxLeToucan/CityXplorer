<?php

namespace cityXplorer\models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\BelongsToMany;


class Liste extends Model {
    protected $table = 'liste';
    protected $primaryKey = 'idListe';
    public $timestamps = false;

    public function creator():BelongsTo{
        return $this->belongsTo(
            'cityXplorer\models\User', 'id');
    }

    public function likers(): BelongsToMany{
        return $this->belongsToMany(
            'cityXplorer\models\User',
            'listeEnregistrees',
            'ListeId',
            'User_id'

        );
    }

    public function posts(): BelongsToMany{
        return $this->belongsToMany(
            'cityXplorer\models\Post',
            'contient',
            'idListe',
            'idPost'
        );
    }
}

