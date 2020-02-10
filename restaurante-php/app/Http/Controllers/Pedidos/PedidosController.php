<?php

namespace App\Http\Controllers\Pedidos;

use Illuminate\Http\Request;
use App\Http\Controllers\Controller;
use Illuminate\Support\Facades\Auth;

class PedidosController extends Controller
{
    const CODIGOS_REGISTRO = [
    	'1' => 'Pedido registrado correctamente',
    	'2' => 'El plato no existe o está desactivado',
    	'3' => 'La mesa no existe o está deshabilitada',
    	'4' => 'El mozo no existe o está deshabilitado'
    ];


    /**
     * Obtiene la lista de pedidos de una mesa.
     * 
     * @param integer $num_mesa El numero de mesa del cual se obtendran los pedidos
     * 
     * @return json
     */
    public function verPedidosDeMesa($num_mesa = null){
		
        $parametros = [];
        $parametros[0] = $num_mesa;
        
        try{
            $pedidos = \DB::select('call listar_pedidos_de_mesa(?)', $parametros);
            $ok = true;
        }catch(QueryException $ex){
            $pedidos = null;
            $ok = false;
        }

        $rtn = [
            'ok' => $ok,
            'result' => $pedidos
        ];

        return response()->json($rtn, 200);
	}

	/**
     * Registra un nuevo pedido
     *
     * @param  Request $request
     * @return json
     */
    public function registrarPedido(Request $request){
        $pedido = [];
        //Obtengo los parametros del request
        $pedido[0] = $request->input('idPlato');
        $pedido[1] = $request->input('numMesa');
        //OBTIENE EL USUARIO ACTUAL, SI NO HAY ENTONCES RETORNA 18. SE DEBE ELIMINAR
        //EL VALOR POR DEFECTO CUANDO TODAS LAS RUTAS ESTEN PROTEGIDAS
        $pedido[2] = Auth::user() != null ? Auth::user()->id : 18;

        try{
            //Llamo al procedimiento para registrar el usuario. La funcion select
            //retorna un array así que solo tomo el primer elemento del array
            $select = collect(\DB::select('call registrar_pedido(?, ?, ?)', $pedido))->first();

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

     public function listarPedidosSinPreparacion(){
        
        try{
            //Llamo al procedimiento para obtener los pedidos de los platos que no necesitan preparacion
            $pedidos = \DB::select('call listar_pedidos_platos_no_necesitanprepacion()');
            $ok = true;
        }catch(QueryException $ex){
            $pedidos = null;
            $ok = false;
        }

        $rtn = [
            'ok' => $ok,
            'result' => $pedidos
        ];
        //retorna los pedidos
        return response()->json($rtn, 200);
    }

     public function listarPedidosNecesitanPreparacion(){
        
        try{
            //Llamo al procedimiento para obtener los pedidos de los platos que necesitan prepación 
            $pedidos = \DB::select('call listar_pedidos_platos_necesitanprepacion()');
            $ok = true;
        }catch(QueryException $ex){
            $pedidos = null;
            $ok = false;
        }

        $rtn = [
            'ok' => $ok,
            'result' => $pedidos
        ];
        //retorno los pedidos
        return response()->json($rtn, 200);
    }

    public function listarPedidosEnPreparacion(){
        
        try{
            //Llamo al procedimiento para obtener los pedidos de los platos que necesitan prepación 
            $pedidos = \DB::select('call listar_pedidos_enpreparacion()');
            $ok = true;
        }catch(QueryException $ex){
            $pedidos = null;
            $ok = false;
        }

        $rtn = [
            'ok' => $ok,
            'result' => $pedidos
        ];
        //retorno los pedidos
        return response()->json($rtn, 200);
    }

    public function listarPedidoslistos(){
        
        try{
            //Llamo al procedimiento para obtener los pedidos de los platos que necesitan prepación 
            $pedidos = \DB::select('call listar_pedidos_listos()');
            $ok = true;
        }catch(QueryException $ex){
            $pedidos = null;
            $ok = false;
        }

        $rtn = [
            'ok' => $ok,
            'result' => $pedidos
        ];
        //retorno los pedidos
        return response()->json($rtn, 200);
    }

    public function pasarPedidoaEnPreracion(Request $request){
        
        $pedido = [];
        //Obtengo los parametros del request
        $pedido[0] = $request->input('id_pedido');
        try{
            //Llamo al procedimiento
            \DB::select('call pasar_pedido_a_preparacion(?)', $pedido);
            $ok = true;
            $result = "Cambio de estado pedido cambiado correctamente";
        }catch(QueryException $ex){            
            $ok = false;
            $result = "Error ";
        }

        $rtn = [
            'ok' => $ok,
            'result' =>  $pedido
        ];
        //retorno los pedidos en formato json y el HTTP status code 200
        return response()->json($rtn, 200);
    }

        public function pasarPedidoaListo(Request $request){
        
        $pedido = [];
        //Obtengo los parametros del request
        $pedido[0] = $request->input('id_pedido');
        try{
            //Llamo al procedimiento
            \DB::select('call pasar_pedido_a_listo(?)', $pedido);
            $ok = true;
            $result = "Cambio de estado pedido cambiado correctamente";
        }catch(QueryException $ex){            
            $ok = false;
            $result = "Error ";
        }

        $rtn = [
            'ok' => $ok,
            'result' =>  $pedido
        ];
        //retorno los pedidos en formato json y el HTTP status code 200
        return response()->json($rtn, 200);
    }

    /**
     * Obtiene el insumo del id dado de la base de datos con sus respectivos detalles.
     *
     * @return json
     */
    public function obtenerPedido($id_pedido){
        
        $parametros = [];
        $parametros[0] = $id_pedido;
        try{
            //Llamo al procedimiento para obtener el pedido. La funcion select
            //retorna un array así que solo tomo el primer elemento del array
            $pedido = collect(\DB::select('call obtener_pedido(?)', $parametros))
                            ->first();
            $ok = true;
        }catch(QueryException $ex){
            $pedido = null;
            $ok = false;
        }

        $rtn = [
            'ok' => $ok,
            'result' => $pedido
        ];
        
        return response()->json($rtn, 200);
    }

        public function editarPedido(Request $request){
        //Obtengo los parametros del request
        $pedido = [];
        $pedido[0] = $request->input('id_pedido');
        $pedido[1] = $request->input('idPlato');
        $pedido[2] = $request->input('numMesa');
        $pedido[3] = Auth::user() != null ? Auth::user()->id : 18;

        try{
            //Llamo al procedimiento
              $select = collect(\DB::select('call editar_pedido(?, ?, ?,?)', $pedido))->first();

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

     public function eliminarPedido(Request $request){
        
        $pedido= [];
        //Obtengo los parametros del request
        $pedido[0] = $request->input('id_pedido');

        try{
            //Llamo al procedimiento
            \DB::select('call eliminar_pedido(?)', $pedido);
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

    public function pasarPedidoAEntregado(Request $request){
        
        $pedido = [];
        //Obtengo los parametros del request
        $pedido[0] = $request->input('id_pedido');
        try{
            //Llamo al procedimiento
            \DB::select('call pasar_pedido_a_entregado(?)', $pedido);
            $ok = true;
            $result = "Cambio de estado pedido cambiado correctamente";
        }catch(QueryException $ex){            
            $ok = false;
            $result = "No se pudo cambiar el estado del pedido";
        }

        $rtn = [
            'ok' => $ok,
            'result' => $result
        ];
        //retorno los pedidos en formato json y el HTTP status code 200
        return response()->json($rtn, 200);
    }
}
