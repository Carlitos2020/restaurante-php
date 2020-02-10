import { Injectable } from '@angular/core';
import { HttpClient, HttpHeaders } from '@angular/common/http';
import { Observable } from 'rxjs/Observable';
import { environment } from '../../../environments/environment';
import { HeaderService } from '../../shared/services/header.service';


@Injectable()
export class ProveedoresService
{

	httpOptions:object;
    private apiUrl:string = environment.apiUrl;
    
    constructor(
		private http:HttpClient,
		private headerService:HeaderService
    )
    {
        let headers = new HttpHeaders();
        headers = headers.set("Content-Type", "application/json");
        
        this.httpOptions = { headers: headers };
    }

    listar(): Observable<any>
    {
        var url = this.apiUrl + "proveedores";
        
        return this.http.get(url, this.httpOptions);
    }

    mostrar(idProveedor: number): Observable<any>
    {
        var url = this.apiUrl + "proveedores/mostrar/"+idProveedor;
        
        return this.http.get(url, this.httpOptions);
    }

    registrar(nombre:string,direccion:string, descripcion:string): Observable<any>
     {
        var url = this.apiUrl + "proveedores/registrar";
        var data = { 
            nombre:nombre,
            descripcion:descripcion,
            direccion:direccion
        };
        
        return this.http.post<any>(url, data, this.httpOptions);
     }

     editar(id: number, nombre:string,direccion:string, descripcion:string): Observable<any>
     {
        var url = this.apiUrl + "proveedores/editar";
        var data = { 
            id:id,
            nombre:nombre,
            direccion:direccion,
            descripcion:descripcion
         };
        
        return this.http.post<any>(url, data, this.httpOptions);
     }

     eliminarProveedor(id:number)
     {
        var url = this.apiUrl + "proveedores/eliminar";
        var data = {
            id:id
        };
        return this.http.post<any>(url, data, this.httpOptions);
     }

      listarInsumosProveedor(id:number): Observable<any>
    {
        var url = this.apiUrl + "proveedores/mostrar/insumos/"+id;
        
        return this.http.get(url, this.httpOptions);
    }

    agregarInsumoProveedor(id:number, nombreInsumo:string, cantidadMinima:number): Observable<any>
    {
        var url = this.apiUrl + "proveedores/agregar/insumo/"+id;
        var data = { id:id , nombre: nombreInsumo, cantidad: cantidadMinima };
        
        return this.http.post<any>(url, data, this.httpOptions);
    }

    listarInsumos(id:number): Observable<any>
    {
        var url = this.apiUrl + "proveedores/insumos/agregar/"+id;
        
        return this.http.get(url, this.httpOptions);
    }

    registrarInsumo(nombreInsumo:string, cantidadMinima:number): Observable<any>
     {
        var url = this.apiUrl + "insumos/registrar";
        var data = { nombre_insumo: nombreInsumo, cantidad_minima: cantidadMinima };
        
        return this.http.post<any>(url, data, this.httpOptions);
     }

     registrarInsumoProveedor(id:number, idIn:number, nombre:string, cantidad:number){
        var url = this.apiUrl + "proveedores/insumo/editar"+id;
        var data = {
            id:id,
            idIn:idIn,
            nombre:nombre,
            cantidad:cantidad
        };
        return this.http.post<any>(url, data, this.httpOptions);
     }

     eliminarInsumo(id:number)
     {
        var url = this.apiUrl + "proveedores/insumo/eliminar/"+id;
        
        return this.http.post<any>(url, this.httpOptions);
     }
     
}
