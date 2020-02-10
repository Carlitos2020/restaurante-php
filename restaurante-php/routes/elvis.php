<?php


use Illuminate\Http\Request;

Route::get('elvis',function (){
    return response()->json([
        "nombre"=>"elvis"
    ],200);
});

Route::post('usuarios/edit','User\UserController@editarUsuario');
Route::post('usuarios/activar','User\UserController@activarUsuario');
Route::get('usuarios/mostrar/{id}','User\UserController@obtenerDatosUsuario');

/**
 * Valores de acceso
 * 1: Admin
 * 2: Mozo
 * 3: Cocinero
 * 4: Cajero
 * 5: Almacenero
 */


Route::group(['middleware' => 'auth:api'], function()
{

    Route::get('prueba',function(){
        return "Pudiste acceder normal";
    })->middleware('checkrole:1,2,3');

});


Route::get('deniedAccess',function(){
    return "No tienes los permisos necesarios";
})->name("deniedAccess");


Route::post('caja/verconsumopormeda','Caja\CajaController@verConsumoPorMesa');