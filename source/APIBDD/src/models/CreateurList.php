<?php

namespace cityXplorer\models;

use Illuminate\Database\Eloquent\Model;


class CreateurList extends Model {
    protected $table = 'listecreateur';
    protected $primaryKey = 'idListe';
    public $timestamps = false;
}
