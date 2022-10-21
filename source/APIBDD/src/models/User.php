<?php

namespace cityXplorer\models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsToMany;
use Illuminate\Database\Eloquent\Relations\HasMany;

class User extends Model {
    protected $table = 'utilisateur';
    protected $primaryKey ='id';
    public $timestamps = false;

    public function posts(): HasMany {
        return $this->hasMany(Post::class, "idUser");
    }

    public function likes(): BelongsToMany {
        return $this->belongsToMany(
            Post::class,
            "avotepour",
            "idUtilisateur",
            "idPost"
        );
    }

    public function createdLists(): HasMany {
        return $this->hasMany(Liste::class, 'idCreateur');
    }

    public function listLikes(): BelongsToMany{
        return $this->belongsToMany(
            Liste::class,
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

    private function deletePosts(): void {
        foreach ($this->posts as $post) {
            $post->deleteAssociations();
            $post->delete();
        }
    }

    private function deleteLikes(): void {
        $this->likes()->detach();
    }

    private function deleteLists(): void {
        foreach ($this->createdLists as $list) {
            $list->deleteAssociations();
            $list->delete();
        }
    }

    private function deleteSavedLists(): void {
        $this->listLikes()->detach();
    }

    public function deleteAssociations(): void {
        $this->deletePosts();
        $this->deleteLikes();
        $this->deleteLists();
        $this->deleteSavedLists();
    }
}