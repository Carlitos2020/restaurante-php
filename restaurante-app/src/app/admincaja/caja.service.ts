import { Injectable } from '@angular/core';
import { HttpClient, HttpHeaders } from '@angular/common/http';
import { Observable } from 'rxjs/Observable';
import { environment } from '../../environments/environment';
import { HeaderService } from '../shared/services/header.service';

@Injectable()
export class CajaService {

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

    obtenerEstadoCaja(): Observable<any>
    {
        var url = this.apiUrl + "caja";
        
       return this.http.get(url, this.httpOptions);
    }

    obtenerOperacionesCaja(): Observable<any>
    {
        var url = this.apiUrl + "caja/operaciones";
        
       return this.http.get(url, this.httpOptions);
    }


    abrirCaja(monto_inicial:number): Observable<any>
    {
        var url = this.apiUrl + "caja/abrir";
        var data = {
        	"monto_inicial": monto_inicial
        }

       return this.http.post<any>(url, data, this.httpOptions);
    }

    cerrarCaja(monto_final_ingresado: number): Observable<any>
    {
        var url = this.apiUrl + "caja/cerrar";
		var data = {
        	"monto_final_ingresado": monto_final_ingresado
        }        
        
       return this.http.post<any>(url, data, this.httpOptions);
    }

    registrarOperacion(monto: number, descripcion: string): Observable<any>
    {
        var url = this.apiUrl + "caja/operaciones/registrar";
        var data = {
            "monto": monto,
            "descripcion": descripcion
        }        
        
       return this.http.post<any>(url, data, this.httpOptions);
    }    

    registrarPago(numMesa: number): Observable<any>
    {
        var url = this.apiUrl + "caja/pagos/registrar";
        var data = {
            "numMesa": numMesa
        }        
        
       return this.http.post<any>(url, data, this.httpOptions);
    }

    obtenerConsumosPorMesa(numMesa:number):Observable<any>
    {
        var url = this.apiUrl + "caja/verconsumopormeda";
        const data = {
            "numero_mesa":numMesa
        };
       return this.http.post(url,data ,this.httpOptions);

    }
}
