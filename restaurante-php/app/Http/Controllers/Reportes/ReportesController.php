<?php

namespace App\Http\Controllers\Reportes;

use Illuminate\Http\Request;
use App\Http\Controllers\Controller;

class ReportesController extends Controller
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
    public function verReporteVentas(Request $request){
        $parametros = [];
        $parametros[0] = $request->input('FECHA_INICIO');
        $parametros[1] = $request->input('FECHA_FIN');
		
        try{
            //Llamo al procedimiento para obtener los proveedores
            $reporte = \DB::select('call reporte_ventas(?,?)', $parametros);
            $ok = true;
        }catch(QueryException $ex){
            $reporte  = null;
            $ok = false;
        }

        $rtn = [
            'ok' => $ok,
            'result' => $reporte 
        ];
        //retorno los proveedores en formato json y el HTTP status code 200
		return response()->json($rtn, 200);
	}

    public function verReportePlatos(Request $request){
        $parametros = [];
        $parametros[0] = $request->input('FECHA_INICIO');
        $parametros[1] = $request->input('FECHA_FIN');
        
        try{
            //Llamo al procedimiento para obtener los proveedores
            $reporte = \DB::select('call reporte_platos(?,?)', $parametros);
            $ok = true;
        }catch(QueryException $ex){
            $reporte  = null;
            $ok = false;
        }

        $rtn = [
            'ok' => $ok,
            'result' => $reporte 
        ];
        //retorno los proveedores en formato json y el HTTP status code 200
        return response()->json($rtn, 200);
    }

    public function verReporteCierreCaja(Request $request){
        $parametros = [];
        $parametros[0] = $request->input('FECHA_INICIO');
        $parametros[1] = $request->input('FECHA_FIN');
        
        try{
            //Llamo al procedimiento para obtener los proveedores
            $reporte = \DB::select('call reporte_cierre_caja(?,?)', $parametros);
            $ok = true;
        }catch(QueryException $ex){
            $reporte  = null;
            $ok = false;
        }

        $rtn = [
            'ok' => $ok,
            'result' => $reporte 
        ];
        //retorno los proveedores en formato json y el HTTP status code 200
        return response()->json($rtn, 200);
    }
}
