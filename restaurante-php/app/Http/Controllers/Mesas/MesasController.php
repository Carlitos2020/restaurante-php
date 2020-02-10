<?php

namespace App\Http\Controllers\Mesas;

use Illuminate\Http\Request;
use App\Http\Controllers\Controller;

class MesasController extends Controller
{
    /*
    |--------------------------------------------------------------------------
    | MEsasController
    |--------------------------------------------------------------------------
    |
    | Este controlador es responsble de las operaciones CRUD para las mesas.
    |
    */


    /**
     * Obtiene la lista de mesas de la base de datos con sus respectivos detalles.
     *
     * @return json
     */

    public function verMesas(){
		
        try{
            //Llamo al procedimiento para obtener los proveedores
            $proveedores = \DB::select('call listar_mesas()');
            $ok = true;
        }catch(QueryException $ex){
            $proveedores = null;
            $ok = false;
        }

        $rtn = [
            'ok' => $ok,
            'result' => $proveedores
        ];
        //retorno los proveedores en formato json y el HTTP status code 200
		return response()->json($rtn, 200);
	}

	public function registrarMesa(Request $request){
        $parametros = [];
        //Obtengo los parametros del request
        $parametros[0] = $request->input('numero_mesa');
        
        try{
            //Llamo al procedimiento
            \DB::select('call registrar_mesa(?)', $parametros);
            $ok = true;
            $result = "Mesa registrada correctamente";
        }catch(QueryException $ex){
            $ok = false;
            $result = "Error al registrar mesa";
        }
        //retorno los proveedores en formato json y el HTTP status code 200
        $rtn = [
            'ok' => $ok,
            'result' => $result
        ];

        return response()->json($rtn, 200);
    }
}
