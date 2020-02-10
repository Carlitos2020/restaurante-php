import { Injectable } from '@angular/core';
import { HttpClient, HttpHeaders } from '@angular/common/http';
import { Observable } from 'rxjs/Observable';
import { environment } from '../../../environments/environment';
import { HeaderService } from '../../shared/services/header.service';


@Injectable()
export class MesasServiceAdmin
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

 
    registrar(numeroMesa:number): Observable<any>
     {
        var url = this.apiUrl + "mesas/registrar";
        var data = { numero_mesa: numeroMesa};
        
        return this.http.post<any>(url, data, this.httpOptions);
     }
     listar(): Observable<any>
    {
        var url = this.apiUrl + "mesas";
        
        return this.http.get(url, this.httpOptions);
    }
}