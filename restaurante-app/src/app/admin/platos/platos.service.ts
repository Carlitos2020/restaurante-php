import { Injectable } from '@angular/core';
import { HttpClient, HttpHeaders } from '@angular/common/http';
import { Observable } from 'rxjs/Observable';
import { environment } from '../../../environments/environment';
import { HeaderService } from '../../shared/services/header.service';


@Injectable()
export class PlatosService
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
        var url = this.apiUrl + "platos";
        
        return this.http.get(url, this.httpOptions);
    }

    mostrar(idPlato: number): Observable<any>
    {
        var url = this.apiUrl + "platos/mostrar/"+idPlato;
        
        return this.http.get(url, this.httpOptions);
    }

    registrar(nombrePlato:string, precioPlato:number): Observable<any>
     {        
         

        var url = this.apiUrl + "platos/registrar";
        var data = { nombre_plato: nombrePlato, precio: precioPlato };
        
        return this.http.post<any>(url, data, this.httpOptions);
     }

     editar(id:number, nombrePlato:string, precioPlato:number): Observable<any>
     {
        var url = this.apiUrl + "platos/editar";
        var data = { id_plato: id, nombre_plato: nombrePlato, precio: precioPlato };
                
        return this.http.post<any>(url, data, this.httpOptions);
     }

      listarInsumosPlatos(id:number): Observable<any>
    {
        var url = this.apiUrl + "platos/mostrar/insumos/"+id;
        
        return this.http.get(url, this.httpOptions);
    }

    listarInsumos(id:number): Observable<any>
    {
        var url = this.apiUrl + "platos/insumos/agregar/"+id;
        
        return this.http.get(url, this.httpOptions);
    }

      eliminarInsumo(id_plato:number,id_insumo:number)
     {
        var url = this.apiUrl + "platos/insumos/eliminar/"+id_plato;
        var data = {
            idplato:id_plato,
            idinsumo:id_insumo
        };
        return this.http.post<any>(url, data, this.httpOptions);
     }

     eliminar(id:number)
     {
        var url = this.apiUrl + "platos/eliminar";
        var data = {
            id_plato:id
        };
        return this.http.post<any>(url, data, this.httpOptions);
     }

       habilitar(id:number)
     {
        var url = this.apiUrl + "platos/habilitar";
        var data = {
            id_plato:id
        };
        return this.http.post<any>(url, data, this.httpOptions);
     }

       deshabilitar(id:number)
     {
        var url = this.apiUrl + "platos/deshabilitar";
        var data = {
            id_plato:id
        };
        return this.http.post<any>(url, data, this.httpOptions);
     }

     registrarInsumoPlato(idplato:number, idinsumo:number,cantidad:number): Observable<any>
     {       
         

        var url = this.apiUrl + "platos/insumos/registrar/+idplato";
        var data = { id_plato: idplato, id_insumo: idinsumo,cantidad: cantidad };
        
        return this.http.post<any>(url, data, this.httpOptions);
     }




}