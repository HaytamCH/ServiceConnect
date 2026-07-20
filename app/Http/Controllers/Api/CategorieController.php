<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Categorie;
use Illuminate\Http\Request;

class CategorieController extends Controller
{
    public function index()
    {
        $categories = Categorie::where('active', true)
            ->orderBy('nom')
            ->get([
                'id',
                'nom',
                'description',
                'active',
            ]);
        return response()->json([
            'data' => $categories
        ]);


    }



}
