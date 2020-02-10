<?php

namespace App\Http\Controllers\Roles;

use Illuminate\Http\Request;
use App\Http\Controllers\Controller;
use Illuminate\Database\QueryException;

class RolesController extends Controller
{

    /**
     * Insercion de un nuevo rol
     */
    public function insert(Request $request)
    {   
        $rol_name=$request['rol_name'];

        try
        {
            $data=\DB::select("call usp_roles_i_roles(?)",array($rol_name));
        }catch(QueryException $ex)
        {
            $data=null;
        }

        $rtn=[
            'ok'=>($data!=null),
            'result'=>$data
        ];

        return response()->json($rtn,200);
    }

    /**
     * Obtencion de todos los roles  registrados
     */
    public function getAll(Request $request)
    {
        $data=\DB::select("call usp_roles_s_roless()");

        $rtn=[
            "ok"=>($data!=null),
            "result"=>$data
        ];
        return response()->json($rtn,200);
    }

    public function edit(Request $request)
    {

    }

    public function delete(Request $request)
    {

    }
}
