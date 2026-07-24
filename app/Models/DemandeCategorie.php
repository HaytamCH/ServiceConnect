<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class DemandeCategorie extends Model
{
    use HasFactory;

    protected $fillable = [
        'prestataire_id',
        'nom',
        'description',
        'statut',
        'categorie_id',
        'motif_refus',
    ];

    public function prestataire()
    {
        return $this->belongsTo(User::class, 'prestataire_id');
    }

    public function categorie()
    {
        return $this->belongsTo(Categorie::class, 'categorie_id');
    }
}
