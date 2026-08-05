<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Annonce extends Model
{
    use HasFactory;

    protected $fillable = [
        'prestataire_id',
        'categorie_id',
        'titre',
        'description',
        'tarif',
        'localisation',
        'statut',
    ];

    protected $casts = [
        'tarif' => 'decimal:2',
    ];

    public function prestataire()
    {
        return $this->belongsTo(User::class, 'prestataire_id')->withTrashed();
    }

    public function categorie()
    {
        return $this->belongsTo(Categorie::class, 'categorie_id');
    }

    public function disponibilites()
    {
        return $this->hasMany(Disponibilite::class, 'annonce_id');
    }

    public function reservations()
    {
        return $this->hasMany(Reservation::class, 'annonce_id');
    }

    public function avis()
    {
        return $this->hasMany(Avis::class, 'annonce_id');
    }

    public function likes()
    {
        return $this->hasMany(Like::class, 'annonce_id');
    }
}
