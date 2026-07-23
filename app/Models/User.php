<?php

namespace App\Models;

use Illuminate\Contracts\Auth\MustVerifyEmail;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Foundation\Auth\User as Authenticatable;
use Illuminate\Notifications\Notifiable;
use Laravel\Sanctum\HasApiTokens;

class User extends Authenticatable
{
    use HasApiTokens, HasFactory, Notifiable;

    /**
     * The attributes that are mass assignable.
     *
     * @var array<int, string>
     */
    protected $fillable = [
        'nom',
        'prenom',
        'email',
        'password',
        'telephone',
        'role',
        'statut',
        'langue',
        'description_profil',
        'photo_profil',
        'localisation',
        'paiement_active',
    ];

    /**
     * The attributes that should be hidden for serialization.
     *
     * @var array<int, string>
     */
    protected $hidden = [
        'password',
        'remember_token',
    ];

    /**
     * The attributes that should be cast.
     *
     * @var array<string, string>
     */
    protected $casts = [
        'email_verified_at' => 'datetime',
        'paiement_active' => 'boolean',
    ];

    protected $appends = [
        'photo_profil_url',
    ];

    public function getPhotoProfilUrlAttribute()
    {
        if (!$this->photo_profil) {
            return null;
        }

        return asset('storage/' . $this->photo_profil);
    }
    /*
    |--------------------------------------------------------------------------
    | Relations liées au rôle prestataire
    |--------------------------------------------------------------------------
    */
    public function annonces(){
        return $this->hasMany(Annonce::class,'prestataire_id');
    }
    public function reservationsCommePrestataire(){
        return $this->hasMany(Reservation::class,'prestataire_id');
    }
    public function avisRecus(){
        return $this->hasMany(Avis::class,'prestataire_id');
    }
    /*
   |--------------------------------------------------------------------------
   | Relations liées au rôle membre
   |--------------------------------------------------------------------------
   */

    public function reservationsCommeMembre(){
        return $this->hasMany(Reservation::class,'membre_id');
    }

    public function avisDonnes(){
        return $this->hasMany(Avis::class,'membre_id');
    }

    public function likes(){
        return $this->hasMany(Like::class,'membre_id');
    }

    public function paiements(){
        return $this->hasMany(Paiement::class,'membre_id');
    }

    /*
      |--------------------------------------------------------------------------
      | Relations liées aux messages
      |--------------------------------------------------------------------------
      */

    public function messagesEnvoyes()
    {
        return $this->hasMany(Message::class, 'expediteur_id');
    }

    public function messagesRecus()
    {
        return $this->hasMany(Message::class, 'destinataire_id');
    }

    /*
    |--------------------------------------------------------------------------
    | Méthodes utiles pour les rôles
    |--------------------------------------------------------------------------
    */

    public function estMembre()
    {
        return $this->role === 'membre';
    }

    public function estPrestataire()
    {
        return $this->role === 'prestataire';
    }

    public function estAdministrateur()
    {
        return $this->role === 'administrateur';
    }

    public function estActif()
    {
        return $this->statut === 'actif';
    }














}
