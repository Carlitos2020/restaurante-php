<?php

namespace App\Http\Controllers\Insumos;

use Illuminate\Http\Request;
use App\Http\Controllers\Controller;

class InsumosController extends Controller
{
	/*
    |--------------------------------------------------------------------------
    | InsumosController
    |--------------------------------------------------------------------------
    |
    | Este controlador es responsble de las operaciones CRUD para los insumos.
    |
    */


    /**
     * Obtiene la lista de insumos de la base de datos con sus respectivos detalles.
     *
     * @return json
     */
    public function verInsumos(){
		
        try{
            //Llamo al procedimiento para obtener los insumos
            $insumos = \DB::select('call ver_insumos()');
            $ok = true;
        }catch(QueryException $ex){
            $insumos = null;
            $ok = false;
        }

        $rtn = [
            'ok' => $ok,
            'result' => $insumos
        ];
        //retorno los insumos en formato json y el HTTP status code 200
		return response()->json($rtn, 200);
	}

    /**
     * Obtiene el insumo del id dado de la base de datos con sus respectivos detalles.
     *
     * @return json
     */
    public function obtenerInsumo($id_insumo){
        
        $parametros = [];
        $parametros[0] = $id_insumo;
        try{
            //Llamo al procedimiento para obtener el insumo. La funcion select
            //retorna un array así que solo tomo el primer elemento del array
            $insumo = collect(\DB::select('call obtener_insumo(?)', $parametros))
                            ->first();
            $ok = true;
        }catch(QueryException $ex){
            $insumo = null;
            $ok = false;
        }

        $rtn = [
            'ok' => $ok,
            'result' => $insumo
        ];
        //retorno los insumos en formato json y el HTTP status code 200
        return response()->json($rtn, 200);
    }

	/**
     * Edita un insumo
     *
     * @param  Request $request
     * @return json
     */
    public function editarInsumo(Request $request){
        //Obtengo los parametros del request
        $insumo = [];
        $insumo[0] = $request->input('id_insumo');
        $insumo[1] = $request->input('nombre_insumo');
        $insumo[2] = $request->input('cantidad_minima');

        try{
            //Llamo al procedimiento
            \DB::select('call editar_insumo(?, ?, ?)', $insumo);
            $ok = true;
            $result = "Insumo editado correctamente";
        }catch(QueryException $ex){
            $ok = false;
            $result = "Error al editar el insumo";
        }
        //retorno los insumos en formato json y el HTTP status code 200
        $rtn = [
            'ok' => $ok,
            'result' => $result
        ];

        return response()->json($rtn, 200);
	}

	/**
     * Registra un insumo 
     *
     * @param  Request $request
     * @return json
     */
    public function registrarInsumo(Request $request){
        $insumo = [];
        //Obtengo los parametros del request
        $insumo[0] = $request->input('nombre_insumo');
        $insumo[1] = $request->input('cantidad_minima');
        $insumo[2] = $request->input('unidades');

        try{
            //Llamo al procedimiento
            \DB::select('call registrar_insumo(?, ?, ?)', $insumo);
            $ok = true;
            $result = "Insumo registrado correctamente";
        }catch(QueryException $ex){
            $ok = false;
            $result = "Error al registrar el insumo";
        }
        //retorno los insumos en formato json y el HTTP status code 200
        $rtn = [
            'ok' => $ok,
            'result' => $result
        ];

        return response()->json($rtn, 200);
    }


     /**
     * Elimina insumo por su id
     *
     * @return json
     */
    public function eliminarInsumo(Request $request){
        
        $insumo = [];
        //Obtengo los parametros del request
        $insumo[0] = $request->input('id_insumo');

        try{
            //Llamo al procedimiento
            \DB::select('call eliminar_insumo(?)', $insumo);
            $ok = true;
            $result = "Insumo eliminado correctamente";
        }catch(QueryException $ex){
            $ok = false;
            $result = "Error al eliminar el insumo";
        }
        //retorno  en formato json y el HTTP status code 200
        $rtn = [
            'ok' => $ok,
            'result' => $result
        ];

        return response()->json($rtn, 200);
    }
}
