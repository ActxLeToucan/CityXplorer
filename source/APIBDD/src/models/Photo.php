<?php

namespace cityXplorer\models;

use cityXplorer\conf\Conf;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class Photo extends Model{
    protected $table = 'photo';
    protected $primaryKey='idPhoto';
    public $timestamps = false;

    public function post(): BelongsTo {
        return $this->belongsTo(Post::class, "idPost");
    }

    public function user(): BelongsTo {
        return $this->belongsTo(User::class, 'idUser');
    }

    public function deleteFile() {
        $url = $this->url;
        if ($url != "" && file_exists(Conf::PATH_IMAGE_POSTS . "/$url")) unlink(Conf::PATH_IMAGE_POSTS . "/$url");
    }
}