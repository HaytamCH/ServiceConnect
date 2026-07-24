<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Categorie extends Model
{
    use HasFactory;

    protected $fillable=[
        'nom',
        'description',
        'active',
        ];

    protected $casts =[
        'active'=>'boolean',
    ];

    public function annonces(){
        return $this->hasMany(Annonce::class,'categorie_id');
    }

    public function demandesCategories()
    {
        return $this->hasMany(DemandeCategorie::class, 'categorie_id');
    }

}
