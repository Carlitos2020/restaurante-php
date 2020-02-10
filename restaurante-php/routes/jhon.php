<?php

use Illuminate\Http\Request;

Route::get('mesas','Mesas\MesasController@verMesas');
Route::post('mesas/registrar','Mesas\MesasController@registrarMesa');
Route::get('almacenControl','Almacen\AlmacenController@verExistencias');
Route::get('almacen/ajuste/mostrar/{id}', 'Almacen\AlmacenController@verExistencia');
Route::post('almacen/ajustar/{id}', 'Almacen\AlmacenController@ajustarCantidad');
Route::get('entrada/mostrar/{id}', 'EntradasAlmacen\EntradasAlmacenController@verEntrada');
Route::post('/entrada/editar/{id}', 'Almacen\AlmacenController@editarEntrada');
Route::post('/entradas/eliminar', 'Almacen\AlmacenController@eliminarEntrada');

Route::get('/estadistica/{Fecha}', 'User\DashboardAdminController@obtenerEstadisticas');

Route::get('reporte/cierrecaja', 'Reportes\ReportesController@verReporteCierreCaja');

Route::post('/proveedores/insumo/eliminar/{id}', 'Proveedores\ProveedoresController@eliminarInsumoProveedor');


Route::get('jhon',function (){
    return response()->json([
        "nombre"=>"jhon"
    ],200);
});