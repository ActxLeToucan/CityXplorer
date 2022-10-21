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
        return $this->belongsTo(User::class, 'idCreateur');
    }

    public function likers(): BelongsToMany{
        return $this->belongsToMany(
            User::class,
            'listeEnregistrees',
            'IdListe',
            'idUtilisateur'
        );
    }

    public function posts(): BelongsToMany{
        return $this->belongsToMany(
            Post::class,
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

    private function deleteContent(): void {
        $this->posts()->detach();
    }

    private function deleteFromSavedLists(): void {
        $this->likers()->detach();
    }

    public function deleteAssociations(): void {
        $this->deleteContent();
        $this->deleteFromSavedLists();
    }
}

