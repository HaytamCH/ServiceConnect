<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Paiement extends Model
{
    use HasFactory;

    protected $fillable = [
        'reservation_id',
        'membre_id',
        'montant',
        'devise',
        'methode',
        'statut',
        'transaction_externe_id',
    ];

    protected $casts = [
        'montant' => 'decimal:2',
    ];

    public function reservation()
    {
        return $this->belongsTo(Reservation::class, 'reservation_id');
    }

    public function membre()
    {
        return $this->belongsTo(User::class, 'membre_id')->withTrashed();
    }

    public function estEnAttente()
    {
        return $this->statut === 'en_attente';
    }

    public function estAccepte()
    {
        return $this->statut === 'accepte';
    }

    public function estRefuse()
    {
        return $this->statut === 'refuse';
    }

    public function estRembourse()
    {
        return $this->statut === 'rembourse';
    }
}
