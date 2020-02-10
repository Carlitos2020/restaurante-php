import { Injectable } from '@angular/core';
import { HttpClient, HttpHeaders } from '@angular/common/http';
import { Observable } from 'rxjs/Observable';
import { environment } from '../../../environments/environment';
import { HeaderService } from '../../shared/services/header.service';


@Injectable()
export class DashboardService
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

    graficar(Fecha:String): Observable<any> {
        var url = this.apiUrl + "estadistica/"+Fecha;
        console.log(Fecha+"   "+url);
        return this.http.get(url, this.httpOptions);
    }

    listar(): Observable<any>
    {
        var url = this.apiUrl + "almacenControl";
        
        return this.http.get(url, this.httpOptions);
    }

    /*listar(): Observable<any>
    {
        var url = this.apiUrl + "insumos";
        
        return this.http.get(url, this.httpOptions);
    }

    mostrar(idInsumo: number): Observable<any>
    {
        var url = this.apiUrl + "insumos/mostrar/"+idInsumo;
        
        return this.http.get(url, this.httpOptions);
    }

    registrar(nombreInsumo:string, cantidadMinima:number): Observable<any>
     {
        var url = this.apiUrl + "insumos/registrar";
        var data = { nombre_insumo: nombreInsumo, cantidad_minima: cantidadMinima };
        
        return this.http.post<any>(url, data, this.httpOptions);
     }

     editar(id: number, nombreInsumo:string, cantidadMinima:number): Observable<any>
     {
        var url = this.apiUrl + "insumos/editar";
        var data = { id_insumo: id, nombre_insumo: nombreInsumo, cantidad_minima: cantidadMinima };
        
        return this.http.post<any>(url, data, this.httpOptions);
     }

     eliminar(id:number)
     {
        var url = this.apiUrl + "insumos/eliminar";
        var data = {
            id_insumo:id
        };
        return this.http.post<any>(url, data, this.httpOptions);
     }*/


     reporteventas(FECHA_INICIO: Date,FECHA_FIN: Date): Observable<any>
    {
        
        var url = this.apiUrl + "reporte/ventas?FECHA_INICIO="+FECHA_INICIO+"&FECHA_FIN="+FECHA_FIN;
        console.log(url); 
        return this.http.get(url, this.httpOptions);
    }

     reporteplatos(FECHA_INICIO: Date,FECHA_FIN: Date): Observable<any>
    {
        
        var url = this.apiUrl + "reporte/platos?FECHA_INICIO="+FECHA_INICIO+"&FECHA_FIN="+FECHA_FIN;
        console.log(url); 
        return this.http.get(url, this.httpOptions);
    }

    reportecaja(FECHA_INICIO: Date, FECHA_FIN:Date): Observable<any>
    {
        
        var url = this.apiUrl + "reporte/cierrecaja?FECHA_INICIO="+FECHA_INICIO+"&FECHA_FIN="+FECHA_FIN;
        return this.http.get(url, this.httpOptions);
    }

}
