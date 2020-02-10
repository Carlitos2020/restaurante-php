# RestauranteApp

This project was generated with [Angular CLI](https://github.com/angular/angular-cli) version 8.3.4.

## Development server

Run `ng serve` for a dev server. Navigate to `http://localhost:4200/`. The app will automatically reload if you change any of the source files.

## Code scaffolding

Run `ng generate component component-name` to generate a new component. You can also use `ng generate directive|pipe|service|class|guard|interface|enum|module`.

## Build

Run `ng build` to build the project. The build artifacts will be stored in the `dist/` directory. Use the `--prod` flag for a production build.

## Running unit tests

Run `ng test` to execute the unit tests via [Karma](https://karma-runner.github.io).

## Running end-to-end tests

Run `ng e2e` to execute the end-to-end tests via [Protractor](http://www.protractortest.org/).

## Further help

To get more help on the Angular CLI use `ng help` or go check out the [Angular CLI README](https://github.com/angular/angular-cli/blob/master/README.md).









## General

despues de clonar el proyecto ejeutar los comandos en la raiz del proyecto

>> npm install

Para correr el proyecto
>> npm start 


Crear compoenentes

>> ng generate component nombre_componente --module app-routing --spec false

Ejemplo:
>> ng generate component /security/login --module app-routing --spec false


dentro del  app-routing.module.ts  se registra el componente en ROUTING_COMPONENTS y se elimina lo que fue agregado en <declarations>








## Solo Elvis

Compilar el proyecto angular , ejectar el comando en la raiz del proyecto

>> ng build --prod

copiar los que contiene la carpeta dist  y pegar todos los archivos dentro de restauarante-php/public 

copiar el contenido del archivo index.html en el archivo /resources/views/welcome.blade.php
