<?php

namespace Tests\Unit;

use App\Models\Disponibilite;
use Tests\TestCase;

class DisponibiliteTest extends TestCase
{
    public function test_future_available_slot_is_reservable(): void
    {
        $disponibilite = new Disponibilite([
            'date_debut' => now()->addHour(),
            'date_fin' => now()->addHours(2),
            'disponible' => true,
        ]);

        $this->assertFalse($disponibilite->expiree);
        $this->assertTrue($disponibilite->reservable);
        $this->assertTrue($disponibilite->toArray()['reservable']);
    }

    public function test_past_slot_is_expired_and_not_reservable(): void
    {
        $disponibilite = new Disponibilite([
            'date_debut' => now()->subHour(),
            'date_fin' => now(),
            'disponible' => true,
        ]);

        $this->assertTrue($disponibilite->expiree);
        $this->assertFalse($disponibilite->reservable);
    }

    public function test_unavailable_future_slot_is_not_reservable(): void
    {
        $disponibilite = new Disponibilite([
            'date_debut' => now()->addHour(),
            'date_fin' => now()->addHours(2),
            'disponible' => false,
        ]);

        $this->assertFalse($disponibilite->expiree);
        $this->assertFalse($disponibilite->reservable);
    }
}
