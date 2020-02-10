<?php

namespace App\Http\Controllers\User;

use Illuminate\Http\Request;
use App\Http\Controllers\Controller;
use Illuminate\Support\Str;

class UserController extends Controller
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
    public function verUsuarios(){
		
        try{
            //Llamo al procedimiento para obtener los proveedores
            $usuarios = \DB::select('call listar_usuarios()');
            $ok = true;
        }catch(QueryException $ex){
            $usuarios = null;
            $ok = false;
        }

        $rtn = [
            'ok' => $ok,
            'result' => $usuarios
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
    public function registrarUsuario(Request $request){
    	$usuario = [];
        //Obtengo los parametros del request
        $usuario[0] = $request->input('rol_id');
        $usuario[1] = $request->input('username');
        $usuario[2] = bcrypt($request->input('password')); 
		$usuario[3] = $request->input('firstname');
        $usuario[4] = $request->input('surname');
        $usuario[5] = $request->input('email');
        $usuario[6] = Str::random(60); //API_TOKEN

        try{
            //Llamo al procedimiento para registrar el usuario. La funcion select
            //retorna un array así que solo tomo el primer elemento del array
            $select = collect(
            			\DB::select(
            				'call registrar_usuario(?, ?, ?, ?, ?, ?, ?)',
            				$usuario)
            			)->first();

            $ok = $select->ok;
            $result = $select->result;
        }catch(QueryException $ex){
            $ok = false;
            $result = "Error al registrar al usuario";
        }
        //retorno el resultado en formato json y el HTTP status code 200
        $rtn = [
            'ok' => $ok,
            'result' => $result
        ];

		return response()->json($rtn, 200);
	}


	/**
     * Editar un usuario 
     *
     * @param  Request $request
     * @return json
     */
    public function editarUsuario(Request $request){
    	$usuario = [];
        //Obtengo los parametros del request
        $usuario[0] = $request->input('id');
        $usuario[1] = $request->input('rol_id');
        $usuario[2] = $request->input('username');
		$usuario[3] = $request->input('firstname');
        $usuario[4] = $request->input('surname');

        try{
            //Llamo al procedimiento para editar el usuario
            \DB::select('call usp_users_u_users(?, ?, ?, ?, ?)',$usuario);

            $ok = true;
            $result = $usuario[0];
        }catch(QueryException $ex){
            $ok = false;
            $result = "Error al editar al usuario";
        }
        //retorno el resultado en formato json y el HTTP status code 200
        $rtn = [
            'ok' => $ok,
            'result' => $result
        ];

		return response()->json($rtn, 200);
	}
	
	/**
     * Elimina un usuario
     *
     * @param  Request $request
     * @return json
     */
    public function elminarUsuario(Request $request){
    	$parametros = [];
    	$parametros[0] = $request['id'];

    	try{
            //Llamo al procedimiento para eliminar al usuario. La funcion select
            //retorna un array así que solo tomo el primer elemento del array
            $select = collect(
            			\DB::select(
            				'call eliminar_usuario(?)',
            				$parametros)
            			)->first();

            $ok = $select->ok;
            $result = $select->result;
        }catch(QueryException $ex){
            $ok = false;
            $result = "Error al registrar al usuario";
        }

        //retorno el resultado en formato json y el HTTP status code 200
        $rtn = [
            'ok' => $ok,
            'result' => $result
        ];

		return response()->json($rtn, 200);
	}	

	/**
     * Activar la cuenta de un usuario 
     *
     * @param  Request $request
     * @return json
     */
    public function activarUsuario(Request $request){
	    $parametros = [];
    	$parametros[0] = $request['id'];

    	try{
            //Llamo al procedimiento para activar al usuario
            \DB::select('call usp_users_activar_users(?)',$parametros);

            $ok = true;
            $result = $parametros[0];
        }catch(QueryException $ex){
            $ok = false;
            $result = "Error al activar al usuario";
        }

        //retorno el resultado en formato json y el HTTP status code 200
        $rtn = [
            'ok' => $ok,
            'result' => $result
        ];

		return response()->json($rtn, 200);
    }
    

	/**
     * Desactiva la cuenta de un usuario 
     *
     * @param  Request $request
     * @return json
     */
    public function desactivarUsuario(Request $request){
	    $parametros = [];
    	$parametros[0] = $request['id'];

    	try{
            //Llamo al procedimiento para desactivar al usuario. La funcion select
            //retorna un array así que solo tomo el primer elemento del array
            $select = collect(
            			\DB::select(
            				'call desactivar_usuario(?)',
            				$parametros)
            			)->first();

            $ok = true;
            $result = $parametros[0];
        }catch(QueryException $ex){
            $ok = false;
            $result = "Error al obtener datos del usuario";
        }

        //retorno el resultado en formato json y el HTTP status code 200
        $rtn = [
            'ok' => $ok,
            'result' => $result
        ];

		return response()->json($rtn, 200);
    }
    

	/**
     * Obtener un usuario
     *
     * @param  Request $request
     * @return json
     */
    public function obtenerDatosUsuario($id_usuario){
    	$parametros = [];
    	$parametros[0] = $id_usuario;

    	try{
            $select = collect(
            			\DB::select(
            				'call usp_users_s_users(?)',
            				$parametros)
            			)->first();

            $ok = true;
            $result = $select;
        }catch(QueryException $ex){
            $ok = false;
            $result = "Error al registrar al usuario";
        }

        //retorno el resultado en formato json y el HTTP status code 200
        $rtn = [
            'ok' => $ok,
            'result' => $result
        ];

		return response()->json($rtn, 200);
	}	
}
