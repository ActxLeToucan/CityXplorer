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
        return $this->hasMany(Photo::class, "idPost");
    }

    public function user(): BelongsTo {
        return $this->belongsTo(User::class, 'idUser');
    }

    public function likedByUsers(): BelongsToMany {
        return $this->belongsToMany(
            User::class,
            "avotepour",
            "idPost",
            "idUtilisateur"
        );
    }

    public function lists(): BelongsToMany{
        return $this->belongsToMany(
            Liste::class,
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

    private function deletePhotos(): void {
        foreach ($this->photos as $photo) {
            $photo->deleteFile();
            $photo->delete();
        }
    }

    private function deleteFromLists(): void {
        $this->lists()->detach();
    }

    private function deleteFromLikes(): void {
        $this->likedByUsers()->detach();
    }

    public function deleteAssociations(): void {
        $this->deletePhotos();
        $this->deleteFromLists();
        $this->deleteFromLikes();
    }
}