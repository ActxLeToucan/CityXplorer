<?php

namespace cityXplorer\models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;

class Partage extends Model{
    protected $table = 'partage';
    protected $primaryKey='idUtilisateur';
    public $timestamps = false;


}