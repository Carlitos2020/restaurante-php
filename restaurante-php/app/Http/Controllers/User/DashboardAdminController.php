<?php

namespace App\Http\Controllers\User;

use Illuminate\Http\Request;
use App\Http\Controllers\Controller;
use Illuminate\Support\Str;

class DashboardAdminController extends Controller
{
	/*
    |--------------------------------------------------------------------------
    | UserController
    |--------------------------------------------------------------------------
    |
    | Este controlador es responsble de las operaciones CRUD para los usuarios.
    |
    */
	/**
     * Obtiene la lista de usuarios de la base de datos con sus respectivos detalles.
     *
     * @return json
     */
    public function ObtenerEstadisticas($Fecha){
        
        $parametros = [];
        $parametros[0] = $Fecha;
		
        try{
            //Llamo al procedimiento para obtener las estadisticas del dia
            $select = \DB::select('call ver_estadisticas(?)', $parametros);
            $ok = true;

        }catch(QueryException $ex){
            $select = null;
            $ok = false;
        }

        $rtn = [
            'ok' => $ok,
            'result' => $select
        ];
        //retorno el resultado en formato json y el HTTP status code 200
		return response()->json($rtn, 200);
	}


	/**
     * Registra un usuario 
     *
     * @param  Request $request
     * @return json
     */

}
