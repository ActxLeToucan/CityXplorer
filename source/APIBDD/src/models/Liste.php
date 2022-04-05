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
            'cityXplorer\models\User', 'idCreateur');
    }

    public function likers(): BelongsToMany{
        return $this->belongsToMany(
            'cityXplorer\models\User',
            'listeEnregistrees',
            'IdListe',
            'idUtilisateur'

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

    public function toArray(): array {
        return [
            "idListe" => $this->idListe,
            "nomListe" => $this->nomListe,
            "descrListe" => $this->descrListe,
            "pseudo" => $this->creator->pseudo
        ];
    }
}

