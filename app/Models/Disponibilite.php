<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Disponibilite extends Model
{
    use HasFactory;

    protected $fillable = [
        'annonce_id',
        'date_debut',
        'date_fin',
        'disponible',
    ];

    protected $casts = [
        'date_debut' => 'datetime',
        'date_fin' => 'datetime',
        'disponible' => 'boolean',
    ];

    protected $appends = [
        'expiree',
        'reservable',
    ];

    public function getExpireeAttribute(): bool
    {
        return !$this->date_debut || $this->date_debut->lessThanOrEqualTo(now());
    }

    public function getReservableAttribute(): bool
    {
        return $this->disponible && !$this->expiree;
    }

    public function annonce()
    {
        return $this->belongsTo(Annonce::class, 'annonce_id');
    }

    public function reservations()
    {
        return $this->hasMany(Reservation::class, 'disponibilite_id');
    }
}
