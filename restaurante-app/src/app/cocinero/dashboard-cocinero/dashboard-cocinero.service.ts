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

    listaPedidosCP(): Observable<any>
    {
        var url = this.apiUrl + "pedidos/obtenerpedidoscp";
        
        return this.http.get(url, this.httpOptions);
    }

      listaPedidosSP(): Observable<any>
    {
        var url = this.apiUrl + "pedidos/obtenerpedidossp";
        
        return this.http.get(url, this.httpOptions);
    }
        listaPedidosEnPreparacion(): Observable<any>
    {
        var url = this.apiUrl + "pedidos/obtenerpedidosep";
        
        return this.http.get(url, this.httpOptions);
    }
        listaPedidosListos(): Observable<any>
    {
        var url = this.apiUrl + "pedidos/obtenerpedidoslistos";
        
        return this.http.get(url, this.httpOptions);
    }

         pasarPeidoAEnPreparacion(id:number)
     {
        var url = this.apiUrl + "pedidos/pasarpedidoaenpreparacion";
        var data = {
            id_pedido:id
        };
        return this.http.post<any>(url, data, this.httpOptions);
     }

         pasarPedidoAListo(id:number)
     {
        var url = this.apiUrl + "pedidos/pasarpedidoalisto";
        var data = {
            id_pedido:id
        };
        return this.http.post<any>(url, data, this.httpOptions);
     }

  

}
