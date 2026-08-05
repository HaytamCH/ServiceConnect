<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Avis extends Model
{
    use HasFactory;

    protected $fillable = [
        'membre_id',
        'prestataire_id',
        'annonce_id',
        'reservation_id',
        'note',
        'commentaire',
        'visible',
    ];

    protected $casts = [
        'visible' => 'boolean',
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

    public function reservation()
    {
        return $this->belongsTo(Reservation::class, 'reservation_id');
    }
}
