<?php

namespace App\Http\Controllers\SalidasAlmacen;

use Illuminate\Http\Request;
use App\Http\Controllers\Controller;
use Illuminate\Support\Facades\Auth;

class SalidasAlmacenController extends Controller
{
    const CODIGOS_REGISTRO = [
    	'1' => 'Salida registrada correctamente',
    	'2' => 'El insumo no existe',
    	'3' => 'El almacenero no existe o está deshabilitado',
    	'4' => 'La cantidad ingresada es inválida',
        '5' => 'La cantidad excede a la cantidad del insumo existente'
    ];

    /**
     * Obtiene la lista de pedidos de una mesa.
     * 
     * @param integer $num_mesa El numero de mesa del cual se obtendran los pedidos
     * 
     * @return json
     */
    public function verSalidas(){
		
        try{
            $salidas = \DB::select('call listar_salidas_almacen()');
            $ok = true;
        }catch(QueryException $ex){
            $salidas = null;
            $ok = false;
        }

        $rtn = [
            'ok' => $ok,
            'result' => $salidas
        ];

        return response()->json($rtn, 200);
	}


    /**
     * Registra un nuevo pedido
     *
     * @param  Request $request
     * @return json
     */
    public function registrarSalida(Request $request){

        //Obtengo los parametros del request
        $salida = [];
        $salida[0] = $request->input('idInsumo');
        //OBTIENE EL USUARIO ACTUAL, SI NO HAY ENTONCES RETORNA 18. SE DEBE ELIMINAR
        //EL VALOR POR DEFECTO CUANDO TODAS LAS RUTAS ESTEN PROTEGIDAS
        $salida[1] = Auth::user() != null ? Auth::user()->id : 18;
		$salida[2] = $request->input('cantidad');
		$salida[3] = $request->input('descripcion');
        
        try{
            //Llamo al procedimiento para registrar el usuario. La funcion select
            //retorna un array así que solo tomo el primer elemento del array
            $select = collect(\DB::select(
            	'call registrar_salida_almacen(?, ?, ?, ?)', $salida))->first();

            $codigo_resultado = $select->resultado;
            $ok = $codigo_resultado == 1;
            $result = self::CODIGOS_REGISTRO[$codigo_resultado];

        }catch(QueryException $ex){
            $ok = false;
            $result = "Error al registrar salida";
        }

        $rtn = [
            'ok' => $ok,
            'result' => $result
        ];

        return response()->json($rtn, 200);
    }

    /**
     * Elimina una salida del almacen
     *
     * @param  Request $request
     * @return json
     */
    public function eliminarSalida(Request $request){
        $salida = [];
        $salida[0] = $request->input('idSalida');

        try{
           //Llamo al procedimiento para registrar el usuario. La funcion select
            //retorna un array así que solo tomo el primer elemento del array
            $select = collect(\DB::select(
                'call eliminar_historial_almacen(?)', $salida))->first();

            $ok = true;
            $result = "Salida eliminada correctamente";

        }catch(QueryException $ex){
            $ok = false;
            $result = "Error al registrar salida";
        }

        $rtn = [
            'ok' => $ok,
            'result' => $result
        ];

        return response()->json($rtn, 200);   
    }

}