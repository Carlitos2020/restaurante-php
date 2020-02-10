<?php

use Illuminate\Http\Request;

/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
|
| Here is where you can register API routes for your application. These
| routes are loaded by the RouteServiceProvider within a group which
| is assigned the "api" middleware group. Enjoy building your API!
|
*/

Route::post('login', 'Auth\LoginController@login');
Route::post('register', 'Auth\RegisterController@register');

//protected routes
Route::group(['middleware' => 'auth:api'], function() {
    Route::post('usuario', 'Auth\LoginController@obtenerUsuario');
    Route::get('logout', 'Auth\LoginController@logout');
});

//Falta proteger las rutas, preguntar a Elvis sobre la creacion de un middleware que de 
//acuerdo a roles restrinja el acceso
Route::post('insumos/registrar', 'Insumos\InsumosController@registrarInsumo');
Route::post('insumos/editar', 'Insumos\InsumosController@editarInsumo');
Route::get('insumos', 'Insumos\InsumosController@verInsumos');
Route::get('insumos/mostrar/{id}', 'Insumos\InsumosController@obtenerInsumo');
Route::post('insumos/eliminar','Insumos\InsumosController@eliminarInsumo');

Route::get('roles/getAll','Roles\RolesController@getAll');
Route::post('roles/insert','Roles\RolesController@insert');


// PROVEEDORES
Route::get('proveedores','Proveedores\ProveedoresController@verProveedores');
Route::post('proveedores/registrar','Proveedores\ProveedoresController@registrarProveedor');
Route::post('proveedores/editar','Proveedores\ProveedoresController@editarProveedor');
Route::post('proveedores/eliminar','Proveedores\ProveedoresController@eliminarProveedor');
Route::get('proveedores/mostrar/{id}','Proveedores\ProveedoresController@obtenerProveedor');
Route::get('proveedores/mostrar/insumos/{id}', 'Proveedores\ProveedoresController@listarProveedor_Insumos');
Route::post('proveedores/agregar/insumo/{id}', 'Proveedores\ProveedoresController@agregarInsumoProveedor');



//PLATOS
Route::post('platos/registrar', 'Platos\PlatosController@registrarPlato');
Route::get('platos', 'Platos\PlatosController@listarPlatos');
Route::get('platos/mostrar/insumos/{id}', 'Platos\PlatosController@listarPlatos_Insumos');
Route::get('platos/insumos/agregar/{id}', 'Platos\PlatosController@listarInsumos');
