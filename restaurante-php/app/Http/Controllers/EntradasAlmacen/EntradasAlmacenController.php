<?php

namespace App\Http\Controllers\EntradasAlmacen;

use Illuminate\Http\Request;
use App\Http\Controllers\Controller;
use Illuminate\Support\Facades\Auth;

class EntradasAlmacenController extends Controller
{
    const CODIGOS_REGISTRO = [
    	'1' => 'Entrada registrada correctamente',
    	'2' => 'El insumo no existe',
    	'3' => 'El almacenero no existe o está deshabilitado',
    	'4' => 'La cantidad ingresada es inválida'
    ];

    /**
     * Obtiene la lista de pedidos de una mesa.
     * 
     * @param integer $num_mesa El numero de mesa del cual se obtendran los pedidos
     * 
     * @return json
     */
    public function verEntradas(){
		
        try{
            $entradas = \DB::select('call listar_entradas_almacen()');
            $ok = true;
        }catch(QueryException $ex){
            $entradas = null;
            $ok = false;
        }

        $rtn = [
            'ok' => $ok,
            'result' => $entradas
        ];

        return response()->json($rtn, 200);
	}


    /**
     * Registra un nuevo pedido
     *
     * @param  Request $request
     * @return json
     */
    public function registrarEntrada(Request $request){

        //Obtengo los parametros del request
        $entrada = [];
        $entrada[0] = $request->input('idInsumo');
        //OBTIENE EL USUARIO ACTUAL, SI NO HAY ENTONCES RETORNA 18. SE DEBE ELIMINAR
        //EL VALOR POR DEFECTO CUANDO TODAS LAS RUTAS ESTEN PROTEGIDAS
        $entrada[1] = Auth::user() != null ? Auth::user()->id : 18;
		$entrada[2] = $request->input('cantidad');
		$entrada[3] = $request->input('descripcion');
        
        try{
            //Llamo al procedimiento para registrar el usuario. La funcion select
            //retorna un array así que solo tomo el primer elemento del array
            $select = collect(\DB::select(
            	'call registrar_entrada_almacen(?, ?, ?, ?)', $entrada))->first();

            $codigo_resultado = $select->resultado;
            $ok = $codigo_resultado == 1;
            $result = self::CODIGOS_REGISTRO[$codigo_resultado];

        }catch(QueryException $ex){
            $ok = false;
            $result = "Error al registrar el plato";
        }

        $rtn = [
            'ok' => $ok,
            'result' => $result
        ];

        return response()->json($rtn, 200);
    }

    public function verEntrada($idinsumo){

        //Obtengo los parametros del request
        $entrada = [];
        $entrada[0] = $idinsumo;
        //OBTIENE EL USUARIO ACTUAL, SI NO HAY ENTONCES RETORNA 18. SE DEBE ELIMINAR
        //EL VALOR POR DEFECTO CUANDO TODAS LAS RUTAS ESTEN PROTEGIDAS
               
        try{
            //Llamo al procedimiento para registrar el usuario. La funcion select
            //retorna un array así que solo tomo el primer elemento del array
            $select = collect(\DB::select(
                'call ver_entrada_almacen(?)', $entrada))->first();

            $ok = true;

        }catch(QueryException $ex){
            $ok = false;
            $result = "Error al obtener datos";
        }

        $rtn = [
            'ok' => $ok,
            'result' => $select
        ];

        return response()->json($rtn, 200);
    }
}
