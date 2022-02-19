<?php

namespace cityXplorer\models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class Partage extends Model{
    protected $table = 'partage';
    protected $primaryKey='idUtilisateur';
    public $timestamps = false;


}