<?php

namespace cityXplorer\models;

use Illuminate\Database\Eloquent\Model;


class EnregistreListe extends Model {
    protected $table = 'listeenregistrées';
    protected $primaryKey = 'idListe';
    public $timestamps = false;
}
