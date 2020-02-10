<?php

namespace App\Http\Controllers\Platos;

use Illuminate\Http\Request;
use App\Http\Controllers\Controller;

class PlatosController extends Controller
{
   /*
    |--------------------------------------------------------------------------
    | PlatosController
    |--------------------------------------------------------------------------
    |
    | Este controlador es responsble de las operaciones CRUD para los platos.
    |
    */
   

    /**
     * Obtiene la lista de platos de la base de datos con sus respectivos detalles.
     *
     * @return json
     */
    public function listarPlatos(){
		
        try{
            //Llamo al procedimiento para obtener la lista de platos
            $platos = \DB::select('call listar_platos()');
            $ok = true;
        }catch(QueryException $ex){
            $platos = null;
            $ok = false;
        }

        $rtn = [
            'ok' => $ok,
            'result' => $platos
        ];
        //retorno los insumos en formato json y el HTTP status code 200
		return response()->json($rtn, 200);
	}

	/**
     * Registra un plato
     *
     * @param  Request $request
     * @return json
     */
    public function registrarPlato(Request $request){
        $plato = [];
        //Obtengo los parametros del request
        $plato[0] = $request->input('nombre_plato');
        $plato[1] = $request->input('precio');      

        try{
            //Llamo al procedimiento
            \DB::select('call registrar_platos(?,?)', $plato);
            $ok = true;
            $result = "Plato registrado correctamente";
        }catch(QueryException $ex){
            $ok = false;
            $result = "Error al registrar el plato";
        }
        //retorno los platos en formato json y el HTTP status code 200
        $rtn = [
            'ok' => $ok,
            'result' => $result
        ];

        return response()->json($rtn, 200);
    }

        /**
     * Listar todos los insumos de un plato
     *
     * @param  Request $request
     * @return json
     */
    public function listarPlatos_Insumos($id_plato){
        $parametros = [];
        $parametros[0] = $id_plato;
         try{
            //Llamo al procedimiento para obtener la lista de insumos necesarios por plato
            $insumos = \DB::select('call listar_plato_insumos(?)', $parametros);              
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

    public function registrarPlato_Insumo(Request $request){
        $insumo = [];
        //Obtengo los parametros del request
        $insumo [0] = $request->input('id_plato');
        $insumo [1] = $request->input('id_insumo'); 
        $insumo [2] = $request->input('cantidad');   

        try{
            //Llamo al procedimiento
            \DB::select('call registrar_plato_insumo(?,?,?)', $insumo);
            $ok = true;
            $result = "Insumo registrado al plato correctamente";
        }catch(QueryException $ex){
            $ok = false;
            $result = "Error al registrar el plato";
        }
        //retorno los platos en formato json y el HTTP status code 200
        $rtn = [
            'ok' => $ok,
            'result' => $result
        ];

        return response()->json($rtn, 200);
    }

    public function listarInsumos($id_plato){
        $parametros = [];
        $parametros[0] = $id_plato;
         try{
            //Llamo al procedimiento para obtener la lista de insumos necesarios por plato
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

        public function eliminarPlatoInsumo(Request $request){
        
        $parametros  = [];
        //Obtengo los parametros del request
        $parametros [0] = $request->input('idplato');
        $parametros [1] = $request->input('idinsumo');
        try{
            //Llamo al procedimiento
            \DB::select('call eliminar_plato_insumo(?,?)', $parametros);
            $ok = true;
            $result = "Insumo del Plato eliminado correctamente";
        }catch(QueryException $ex){
            $ok = false;
            $result = "Error al eliminar el Insumo del plato";
        }
        //retorno  en formato json y el HTTP status code 200
        $rtn = [
            'ok' => $ok,
            'result' => $result
        ];

        return response()->json($rtn, 200);
    }

    public function eliminarPlato(Request $request){
        
        $plato = [];
        //Obtengo los parametros del request
        $plato[0] = $request->input('id_plato');

        try{
            //Llamo al procedimiento
            \DB::select('call eliminar_plato(?)', $plato);
            $ok = true;
            $result = "Plato eliminado correctamente";
        }catch(QueryException $ex){
            $ok = false;
            $result = "Error al eliminar el plato";
        }
        //retorno  en formato json y el HTTP status code 200
        $rtn = [
            'ok' => $ok,
            'result' => $result
        ];

        return response()->json($rtn, 200);
    }


    /**
     * Edita un plato
     *
     * @param  Request $request
     * @return json
     */
    public function editarPlato(Request $request){
        //Obtengo los parametros del request
        $plato= [];
        $plato[0] = $request->input('id_plato');
        $plato[1] = $request->input('nombre_plato');
        $plato[2] = $request->input('precio');

        try{
            //Llamo al procedimiento
            \DB::select('call editar_plato(?, ?, ?)', $plato);
            $ok = true;
            $result = "Plato editado correctamente";
        }catch(QueryException $ex){
            $ok = false;
            $result = "Error al editar el plato";
        }
        //retorno los insumos en formato json y el HTTP status code 200
        $rtn = [
            'ok' => $ok,
            'result' => $result
        ];

        return response()->json($rtn, 200);
    }


    public function obtenerPlato($id_plato){
        
        $parametros = [];
        $parametros[0] = $id_plato;
        try{
            //Llamo al procedimiento para obtener el plato. La funcion select
            //retorna un array así que solo tomo el primer elemento del array
            $plato = collect(\DB::select('call obtener_plato(?)', $parametros))
                            ->first();
            $ok = true;
        }catch(QueryException $ex){
            $plato = null;
            $ok = false;
        }

        $rtn = [
            'ok' => $ok,
            'result' => $plato
        ];
        //retorno los insumos en formato json y el HTTP status code 200
        return response()->json($rtn, 200);
    }

    public function habilitarPlato(Request $request){
        
        $plato = [];
        //Obtengo los parametros del request
        $plato[0] = $request->input('id_plato');
        try{
            //Llamo al procedimiento
            \DB::select('call habilitar_plato(?)', $plato);                           
            $ok = true;
            $result = "Plato habilitado correctamente";
        }catch(QueryException $ex){
            $plato = null;
            $ok = false;
            $result = "Error al habilitar el plato";
        }

        $rtn = [
            'ok' => $ok,
            'result' => $plato
        ];
        //retorno los insumos en formato json y el HTTP status code 200
        return response()->json($rtn, 200);
    }

    public function deshabilitarPlato(Request $request){
        
        $plato = [];
        //Obtengo los parametros del request
        $plato[0] = $request->input('id_plato');
        try{
            //Llamo al procedimiento
            \DB::select('call deshabilitar_plato(?)', $plato);
            $ok = true;
            $result = "Plato deshabilitado correctamente";
        }catch(QueryException $ex){            
            $ok = false;
            $result = "Error al deshabilitar el plato";
        }

        $rtn = [
            'ok' => $ok,
            'result' => $plato
        ];
        //retorno los insumos en formato json y el HTTP status code 200
        return response()->json($rtn, 200);
    }
}