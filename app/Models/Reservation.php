<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Reservation extends Model
{
    use HasFactory;

    protected $fillable = [
        'membre_id',
        'annonce_id',
        'prestataire_id',
        'disponibilite_id',
        'date_demande',
        'date_service',
        'message_demande',
        'statut',
        'date_alternative_debut',
        'date_alternative_fin',
        'message_alternative',
    ];

    protected $casts = [
        'date_demande' => 'datetime',
        'date_service' => 'datetime',
        'date_alternative_debut' => 'datetime',
        'date_alternative_fin' => 'datetime',
    ];

    public function membre()
    {
        return $this->belongsTo(User::class, 'membre_id')->withTrashed();
    }

    public function prestataire()
    {
        return $this->belongsTo(User::class, 'prestataire_id')->withTrashed();
    }

    public function annonce()
    {
        return $this->belongsTo(Annonce::class, 'annonce_id');
    }

    public function disponibilite()
    {
        return $this->belongsTo(Disponibilite::class, 'disponibilite_id');
    }

    public function messages()
    {
        return $this->hasMany(Message::class, 'reservation_id');
    }

    public function avis()
    {
        return $this->hasMany(Avis::class, 'reservation_id');
    }

    public function paiement()
    {
        return $this->hasOne(Paiement::class, 'reservation_id');
    }
}
