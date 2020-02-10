<?php

namespace App\Http\Controllers\Almacen;

use Illuminate\Http\Request;
use App\Http\Controllers\Controller;

class AlmacenController extends Controller
{
    //

	 /**
     * Obtiene la lista de pedidos de una mesa.
     * 
     * 
     * @return json
     */
    public function verExistencias(){
    	try{
            $existencias = \DB::select('call listar_existencias_almacen()');
            $ok = true;
        }catch(QueryException $ex){
            $existencias = null;
            $ok = false;
        }

        $rtn = [
            'ok' => $ok,
            'result' => $existencias
        ];

        return response()->json($rtn, 200);
    }

    public function verExistencia($idinsumo){

    	$parametros = [];
        $parametros[0] = $idinsumo;
    	try{
            $existencia = collect(\DB::select('call ver_existencia_almacen(?)',$parametros))->first();
            $ok = true;
        }catch(QueryException $ex){
            $existencia = null;
            $ok = false;
        }

        $rtn = [
            'ok' => $ok,
            'result' => $existencia
        ];

        return response()->json($rtn, 200);
    }

    public function ajustarCantidad(Request $request){
    	$parametros = [];
        $parametros[0] = $request->input('idinsumo');
        $parametros[1] = $request->input('total');
        $parametros[2] = $request->input('cantidad_ajustada');

         try{
            //Llamo al procedimiento
            \DB::select('call ajustar_existencia_almacen(?, ?, ?)', $parametros);
            $ok = true;
            $result = "Insumo ajustado correctamente";
        }catch(QueryException $ex){
            $ok = false;
            $result = "Error al ajustar el insumo";
        }
        //retorno los insumos en formato json y el HTTP status code 200
        $rtn = [
            'ok' => $ok,
            'result' => $result
        ];

        return response()->json($rtn, 200);
    }

    public function editarEntrada(Request $request){
        //Obtengo los parametros del request
        $insumo = [];
        $insumo[0] = $request->input('idhistorial_almacen');
        
        $insumo[1] = $request->input('cantidad');

        try{
            //Llamo al procedimiento
            \DB::select('call editar_entrada_almacen(?, ?)', $insumo);
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

    public function eliminarEntrada(Request $request){
        
        $entrada = [];
        //Obtengo los parametros del request
        $entrada[0] = $request->input('id_entrada');

        try{
            //Llamo al procedimiento
            \DB::select('call eliminar_entrada(?)', $entrada);
            $ok = true;
            $result = "entrada eliminada correctamente";
        }catch(QueryException $ex){
            $ok = false;
            $result = "Error al eliminar la entrada";
        }
        //retorno  en formato json y el HTTP status code 200
        $rtn = [
            'ok' => $ok,
            'result' => $result
        ];

        return response()->json($rtn, 200);
    }
}
