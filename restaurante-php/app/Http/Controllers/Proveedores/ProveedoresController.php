<?php

namespace App\Http\Controllers\Proveedores;

use Illuminate\Http\Request;
use App\Http\Controllers\Controller;

class ProveedoresController extends Controller
{

	/*
    |--------------------------------------------------------------------------
    | ProveedoresController
    |--------------------------------------------------------------------------
    |
    | Este controlador es responsble de las operaciones CRUD para los proveedores.
    |
    */


    /**
     * Obtiene la lista de proveedores de la base de datos con sus respectivos detalles.
     *
     * @return json
     */
    public function verProveedores(){
		
        try{
            //Llamo al procedimiento para obtener los proveedores
            $proveedores = \DB::select('call usp_proveedores_s_proveedoress()');
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

    /**
     * Obtiene el proveedor del id dado de la base de datos con sus respectivos detalles.
     *
     * @return json
     */
    public function obtenerProveedor($id_proveedor){
        
        $parametros = [];
        $parametros[0] = $id_proveedor;
        try{
            //Llamo al procedimiento para obtener el proveedor. La funcion select
            //retorna un array así que tengo que solo tomo el primer elemento del array
            $proveedor = collect(\DB::select('call usp_proveedores_s_proveedores(?)', $parametros))
                            ->first();
            $ok = true;
        }catch(QueryException $ex){
            $proveedor = null;
            $ok = false;
        }

        $rtn = [
            'ok' => $ok,
            'result' => $proveedor
        ];
        //retorno los proveedores en formato json y el HTTP status code 200
        return response()->json($rtn, 200);
    }

	/**
     * Edita un proveedor
     *
     * @param  Request $request
     * @return json
     */
    public function editarProveedor(Request $request){
        //Obtengo los parametros del request
        $proveedor = [];
        $proveedor[0] = $request->input('id');
        $proveedor[1] = $request->input('nombre');
        $proveedor[2] = $request->input('direccion');
        $proveedor[3] = $request->input('descripcion');

        try{
            //Llamo al procedimiento
            \DB::select('call usp_proveedores_u_proveedores(?, ?, ?, ?)', $proveedor);
            $ok = true;
            $result = "Proveedor editado correctamente";
        }catch(QueryException $ex){
            $ok = false;
            $result = "Error al editar el Proveedor";
        }
        //retorno los proveedores en formato json y el HTTP status code 200
        $rtn = [
            'ok' => $ok,
            'result' => $result
        ];

        return response()->json($rtn, 200);
	}

	/**
     * Registra un proveedor 
     *
     * @param  Request $request
     * @return json
     */
    public function registrarProveedor(Request $request){
        $proveedor = [];
        //Obtengo los parametros del request
        $proveedor[0] = $request->input('nombre');
        $proveedor[1] = $request->input('direccion');
        $proveedor[2] = $request->input('descripcion');

        try{
            //Llamo al procedimiento
            \DB::select('call usp_proveedores_i_proveedores(?, ?, ?)', $proveedor);
            $ok = true;
            $result = "Proveedor registrado correctamente";
        }catch(QueryException $ex){
            $ok = false;
            $result = "Error al registrar el proveedor";
        }
        //retorno los proveedores en formato json y el HTTP status code 200
        $rtn = [
            'ok' => $ok,
            'result' => $result
        ];

        return response()->json($rtn, 200);
    }


    /**
     * Elimina proveedor por su id
     *
     * @return json
     */
    public function eliminarProveedor(Request $request){
        
        $proveedor = [];
        //Obtengo los parametros del request
        $proveedor[0] = $request->input('id');

        try{
            //Llamo al procedimiento
            \DB::select('call usp_proveedores_d_proveedores(?)', $proveedor);
            $ok = true;
            $result = "Proveedor eliminado correctamente";
        }catch(QueryException $ex){
            $ok = false;
            $result = "Error al eliminar el proveedor";
        }
        //retorno  en formato json y el HTTP status code 200
        $rtn = [
            'ok' => $ok,
            'result' => $result
        ];

        return response()->json($rtn, 200);
    }

    public function listarProveedor_Insumos($id_proveedor){
        $parametros = [];
        $parametros[0] = $id_proveedor;
         try{
            //Llamo al procedimiento para obtener la lista de insumos necesarios por plato
            $insumos = \DB::select('call usp_insumos_proveedores_s_insumos_proveedoress(?)', $parametros);              
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

    public function agregarInsumoProveedor (Request $request){
        $parametros = [];
        $parametros[0] = $request->input('id');
        $parametros[1] = $request->input('nombre');
        $parametros[2] = $request->input('cantidad');
         try{
            //Llamo al procedimiento para obtener la lista de insumos necesarios por plato
            \DB::select('call registrar_insumo_proveedor(?, ?, ?)', $parametros);              
            $ok = true;
            $result="Insumo agregado correctamente";
        }catch(QueryException $ex){
            $result = "Insumo no agregado";
            $ok = false;
        }

        $rtn = [
            'ok' => $ok,
            'result' => $result
        ];
        //retorno los insumos en formato json y el HTTP status code 200
        return response()->json($rtn, 200);

        
    }

    public function editarInsumoProveedor(Request $request){
        //Obtengo los parametros del request
        $parametros = [];
        
        $parametros[0] = $request->input('idIn');
        $parametros[1] = $request->input('nombre');
        $parametros[2] = $request->input('cantidad');
        
        try{
            //Llamo al procedimiento
            \DB::select('call editar_insumo(?, ?, ?)', $parametros);
            $ok = true;
            $result = "Proveedor editado correctamente";
        }catch(QueryException $ex){
            $ok = false;
            $result = "Error al editar el Proveedor";
        }
        //retorno los proveedores en formato json y el HTTP status code 200
        $rtn = [
            'ok' => $ok,
            'result' => $result
        ];

        return response()->json($rtn, 200);
    }

    public function eliminarInsumoProveedor($id_insumo){
        //Obtengo los parametros del request
        $parametros = [];
        
        $parametros[0] = $id_insumo;

        
        try{
            //Llamo al procedimiento
            \DB::select('call eliminar_insumo_proveedor(?)', $parametros);
            $ok = true;
            $result = "Proveedor eliminado correctamente";
        }catch(QueryException $ex){
            $ok = false;
            $result = "Error al editar el Proveedor";
        }
        //retorno los proveedores en formato json y el HTTP status code 200
        $rtn = [
            'ok' => $ok,
            'result' => $result
        ];

        return response()->json($rtn, 200);
    }
}
