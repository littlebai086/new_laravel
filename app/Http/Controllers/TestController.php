<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\DataEnable;

class TestController extends Controller
{
    //
    public function testsql(){
        // dd(env('GCP_MYSQL_SSL') && extension_loaded('pdo_mysql'));
        // dd(env('DB_PASSWORD', ''));
        // dd(base_path('config/cert/client-key.pem'));
        dd(DataEnable::get());
    }
}
