# Solo Elvis

>> php artisan migrate
>> php artisan passport:install --force

>>heroku run php artisan passport:install --force
>>heroku ps:exec -a your_app_name

# Solo iver, jhonatan, jose
clonar del repositorio

colocarse en la raiz del proyecto

crear el archivo .env y copiar dentro todo lo que contiene el archivo .env.example

ejecutar el comando 
>> php artisan key:generate


Rellenar los campos del .env  con
    DB_CONNECTION=mysql
    DB_HOST=remotemysql.com
    DB_PORT=3306
    DB_DATABASE=8zkTQS5uHD
    DB_USERNAME=8zkTQS5uHD
    DB_PASSWORD=AkF1qej4f3


ejecutar el comando para instalar las librerias
> composer install

correr el proyecto 
> php artisan serve 




# Pasos para generar la API

1.- Solo escribir codigo en el contrador asignado ejm PlatosController
    - cada funcion dentro del controlador representa la logica de una url

2.- Gerando la url
    - para acceder mediante una url, el controlador y el metodo se deben registrar en el
        archivo routes/api.php
        el registro de la funcion sigue la siguiente sintaxis

Route::metodo("parte de la url","nombre_carpeta\Nombre_Controlador@nombre_de_la_funcion")

ejemplo
Route::post('roles/insert','Roles\RolesController@insert');