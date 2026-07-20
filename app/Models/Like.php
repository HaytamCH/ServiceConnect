<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Like extends Model
{
    use HasFactory;

    protected $fillable = [
        'membre_id',
        'annonce_id',
        'prestataire_id',
        'type_cible',
    ];

    public function membre()
    {
        return $this->belongsTo(User::class, 'membre_id');
    }

    public function annonce()
    {
        return $this->belongsTo(Annonce::class, 'annonce_id');
    }

    public function prestataire()
    {
        return $this->belongsTo(User::class, 'prestataire_id');
    }

    public function estLikeAnnonce()
    {
        return $this->type_cible === 'annonce';
    }

    public function estLikePrestataire()
    {
        return $this->type_cible === 'prestataire';
    }
}
