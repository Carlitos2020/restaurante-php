<?php

namespace App\Http\Controllers\Caja;

use Illuminate\Http\Request;
use App\Http\Controllers\Controller;
use Illuminate\Support\Facades\Auth;

class CajaController extends Controller
{
    const CODIGOS_RESULTADO_ABRIRCAJA = [
    	'1' => 'Caja abierta correctamente',
    	'2' => 'La caja ya estaba abierta'
    ];

	const CODIGOS_RESULTADO_CERRARCAJA = [
    	'1' => 'Caja cerrada correctamente',
    	'2' => 'No hay una caja abierta'
    ];

    const CODIGOS_RESULTADO_REGISTRAROPERACION = [
        '1' => 'Operacion registrada correctamente',
        '2' => 'Monto no valido',
        '3' => 'Cajero no existe o esta deshabilitado',
        '4' => 'La caja todavía no está abierta'
    ];

    const CODIGOS_RESULTADO_REGISTRARPAGO = [
        '1' => 'Pago registrada correctamente',
        '2' => 'La mesa no tiene ningún pedido',
        '3' => 'Cajero no existe o esta deshabilitado',
        '4' => 'La caja todavía no está abierta'
    ];

    /**
     * Obtiene el estado actual de la caja. (El monto y si está abierta o no)
     *
     * @return json
     */
    public function obtenerEstadoCaja(){
        
        try{
            $result = collect(\DB::select('call obtener_estado_caja()'))->first();
            $ok = true;
        }catch(QueryException $ex){
            $result = null;
            $ok = false;
        }

        $rtn = [
            'ok' => $ok,
            'result' => $result
        ];
        //retorno los insumos en formato json y el HTTP status code 200
        return response()->json($rtn, 200);
    }

    /**
     * Abre la caja del restaurante con un monto inicial dado
     * 
     * @param Request $request
     * 
     * @return json
     */
    public function abrirCaja(Request $request){
		$parametros = [];
		$parametros[0] = $request->input('monto_inicial');

        try{
            $select = collect(\DB::select(
            	'call abrir_caja(?)', $parametros))->first();

            $codigo_resultado = $select->resultado;
            $ok = $codigo_resultado == 1;
            $result = self::CODIGOS_RESULTADO_ABRIRCAJA[$codigo_resultado];

        }catch(QueryException $ex){
            $ok = false;
            $result = "No se pudo abrir la caja";
        }

        $rtn = [
            'ok' => $ok,
            'result' => $result
        ];

        return response()->json($rtn, 200);
	}

	/**
     * Cierra la caja del restaurante con un monto final dado
     * 
     * @param Request $request
     * 
     * @return json
     */
    public function cerrarCaja(Request $request) {
		$parametros = [];
		$parametros[0] = $request->input('monto_final_ingresado');

        try{
            $select = collect(\DB::select(
            	'call cerrar_caja(?)', $parametros))->first();

            $codigo_resultado = $select->resultado;
            $ok = $codigo_resultado == 1;
            $result = self::CODIGOS_RESULTADO_CERRARCAJA[$codigo_resultado];

        }catch(QueryException $ex){
            $ok = false;
            $result = "No se pudo cerrar la caja";
        }

        $rtn = [
            'ok' => $ok,
            'result' => $result
        ];

        return response()->json($rtn, 200);
	}

    /**
     * Registra una operacion de la caja
     * 
     * @param Request $request
     * 
     * @return json
     */
    public function registrarOperacion(Request $request) {
        $operacion = [];
        $operacion[0] = $request->input('monto');
        $operacion[1] = $request->input('descripcion');
        $operacion[2] = Auth::user() != null ? Auth::user()->id : 18;

        try{
            $select = collect(\DB::select(
                'call registrar_operacion_caja(?, ?, ?)', $operacion))->first();

            $codigo_resultado = $select->resultado;
            $ok = $codigo_resultado == 1;
            $result = self::CODIGOS_RESULTADO_REGISTRAROPERACION[$codigo_resultado];

        }catch(QueryException $ex){
            $ok = false;
            $result = "No se pudo registrar la operación";
        }

        $rtn = [
            'ok' => $ok,
            'result' => $result
        ];

        return response()->json($rtn, 200);
    }

    /**
     * Registra el pago del consumo de una mesa
     * 
     * @param Request $request
     * 
     * @return json
     */
    public function registrarPagoDeMesa(Request $request) {
        $operacion = [];
        $operacion[0] = $request->input('numMesa');
        $operacion[1] = Auth::user() != null ? Auth::user()->id : 18;

        try{
            $select = collect(\DB::select(
                'call registrar_pago_de_mesa(?, ?)', $operacion))->first();

            $codigo_resultado = $select->resultado;
            $ok = $codigo_resultado == 1;
            $result = self::CODIGOS_RESULTADO_REGISTRARPAGO[$codigo_resultado];

        }catch(QueryException $ex){
            $ok = false;
            $result = "No se pudo registrar el pago";
        }

        $rtn = [
            'ok' => $ok,
            'result' => $result
        ];

        return response()->json($rtn, 200);
    }


    /**
     * Devuelve todas las operaciones registradas en la caja actual
     * 
     * @return json
     */
    public function verOperacionesCajaActual() {

        try{
            $select = \DB::select('call listar_operaciones_de_caja_actual()');

            $ok = true;
            $result = $select;

        }catch(QueryException $ex){
            $ok = false;
            $result = "No se pudo obtener las operaciones";
        }

        $rtn = [
            'ok' => $ok,
            'result' => $result
        ];

        return response()->json($rtn, 200);
    }



    /**
     * Devuelve el consumo de una mesa
     * 
     * @return json
     */
    public function verConsumoPorMesa(Request $request) {

        $parametros = [];
        //Obtengo los parametros del request
        $parametros[0] = $request->input('numero_mesa');

        try{
            $select = \DB::select('call usp_ver_consumo_de_mesas(?)',$parametros);

            $ok = true;
            $result = $select;

        }catch(QueryException $ex){
            $ok = false;
            $result = "No se pudo obtener el consumo de la mesa";
        }

        $rtn = [
            'ok' => $ok,
            'result' => $result
        ];

        return response()->json($rtn, 200);
    }

}
