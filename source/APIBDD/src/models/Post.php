<?php

namespace cityXplorer\models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;

class Post extends Model{
    protected $table = 'post';
    protected $primaryKey='idPost';
    public $timestamps = false;

    public function photos(): HasMany {
        return $this->hasMany('cityXplorer\models\Photo',"idPost");
    }

    public function user(): BelongsTo {
        return $this->belongsTo('cityXplorer\models\User', 'idUser');
    }

    public function toArray(): array {
        $tabPhotos = [];
        foreach ($this->photos as $photo) {
            $tabPhotos[] = $photo->url;
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
            "user-pseudo" => $this->user->pseudo,
            "adresse_courte" => $this->adresse_courte,
            "adresse_longue" => $this->adresse_longue
        ];
    }
}