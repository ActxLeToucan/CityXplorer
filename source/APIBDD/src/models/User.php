<?php

namespace cityXplorer\models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\BelongsToMany;
use Illuminate\Database\Eloquent\Relations\HasMany;

class User extends Model {
    protected $table = 'utilisateur';
    protected $primaryKey ='id';
    public $timestamps = false;

    public function posts(): HasMany {
        return $this->hasMany('cityXplorer\models\Post',"idUser");
    }

    public function likes(): BelongsToMany {
        return $this->belongsToMany(
            "cityXplorer\models\Post",
            "avotepour",
            "idUtilisateur",
            "idPost"
        );
    }
    public function createdLists(): HasMany {
    return $this->hasMany('cityXplorer\models\Liste', 'idCreateur');
}
    public function listLikes(): BelongsToMany{
        return $this->belongsToMany(
            'cityXplorer\models\Liste',
            'listeEnregistrees',
            'idUtilisateur',
            'IdListe'
        );
    }

    public function toArray(bool $userConnected = false): array {
        $tabLikes = [];
        foreach ($this->likes as $like) {
            $tabLikes[] = $like->idPost;
        }

        if ($userConnected) return [
            "pseudo" => $this->pseudo,
            "token" => $this->token,
            "name" => $this->name,
            "avatar" => $this->avatar,
            "niveauAcces" => $this->niveauAcces,
            "description" => $this->description,
            "likes" => $tabLikes
        ];
        else return [
            "pseudo" => $this->pseudo,
            "name" => $this->name,
            "avatar" => $this->avatar,
            "niveauAcces" => $this->niveauAcces,
            "description" => $this->description,
            "likes" => $tabLikes
        ];
    }


}