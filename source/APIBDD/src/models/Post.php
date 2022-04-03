<?php

namespace cityXplorer\models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\BelongsToMany;
use Illuminate\Database\Eloquent\Relations\HasMany;

class Post extends Model{
    protected $table = 'post';
    protected $primaryKey='idPost';
    public $timestamps = false;

    const ETAT_VALIDE = 1;
    const ETAT_EN_ATTENTE = 0;
    const ETAT_BLOQUE = -1;

    public function photos(): HasMany {
        return $this->hasMany('cityXplorer\models\Photo',"idPost");
    }

    public function user(): BelongsTo {
        return $this->belongsTo('cityXplorer\models\User', 'idUser');
    }

    public function likedByUsers(): BelongsToMany {
        return $this->belongsToMany(
            "cityXplorer\models\User",
            "avotepour",
            "idPost",
            "idUtilisateur"
        );
    }
    public function lists(): BelongsToMany{
        return $this->belongsToMany(
            "cityXplorer\models\Liste",
            "contient",
            "idPost",
            "idListe"
        );
    }
    public function toArray(): array {
        $tabPhotos = [];
        foreach ($this->photos as $photo) {
            $tabPhotos[] = $photo->url;
        }
        $tabLikedBy = [];
        foreach ($this->likedByUsers as $user) {
            $tabLikedBy[] = $user->pseudo;
        }

        return [
            "id" => $this->idPost,
            "titre" => $this->titre,
            "latitude"=>$this->latitude,
            "longitude" => $this->longitude,
            "description" => $this->description,
            "date" => $this->datePost,
            "etat" => $this->etat,
            "photos" => $tabPhotos,
            "likedBy" => $tabLikedBy,
            "user-pseudo" => $this->user->pseudo,
            "adresse_courte" => $this->adresse_courte,
            "adresse_longue" => $this->adresse_longue
        ];
    }

}