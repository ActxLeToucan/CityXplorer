<?php

namespace cityXplorer\models;

use Illuminate\Database\Eloquent\Model;


class Contient extends Model {
    protected $table = 'contient';
    protected $primaryKey = (['idListe','idPost']); // peut pas marcher ca
    public $timestamps = false;
}
