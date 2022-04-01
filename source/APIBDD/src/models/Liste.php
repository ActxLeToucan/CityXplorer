<?php

namespace cityXplorer\models;

use Illuminate\Database\Eloquent\Model;


class Liste extends Model {
    protected $table = 'liste';
    protected $primaryKey = 'idListe';
    public $timestamps = false;
}