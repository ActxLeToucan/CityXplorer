<?php

namespace cityXplorer\models;

use Illuminate\Database\Eloquent\Model;


class Like extends Model {
    protected $table = 'aVotePour';
    protected $primaryKey = 'idUtilisateur';
    public $timestamps = false;
}