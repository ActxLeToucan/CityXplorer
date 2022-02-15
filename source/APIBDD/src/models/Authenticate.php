<?php

namespace cityXplorer\models;

use Illuminate\Database\Eloquent\Model;

class Authenticate extends Model {
    protected $table = 'utilisateur';
    protected $primaryKey ='id';
    public $timestamps = false;
}