import { Injectable } from '@angular/core';
import { HttpClient, HttpHeaders } from '@angular/common/http';
import { Observable } from 'rxjs/Observable';
import { environment } from '../../../environments/environment';
import { HeaderService } from '../../shared/services/header.service';

@Injectable()
export class UsuariosService {
  
	httpOptions:object;
	private apiUrl:string = environment.apiUrl;
    
  	constructor(private http:HttpClient, private headerService:HeaderService) {
	  	let headers = new HttpHeaders();
	    headers = headers.set("Content-Type", "application/json");
	        
	    this.httpOptions = { headers: headers };
  	}

  	listar(): Observable<any>
    {
        var url = this.apiUrl + "usuarios";
        
        return this.http.get(url, this.httpOptions);
    }

    registrar(rol_id:number, username:string, password:string,
    		 firstname:string, surname:string, email:string): Observable<any>
    {
        var url = this.apiUrl + "usuarios/registrar";
        var data = { 
		        	rol_id: rol_id, 
		        	username: username,
		        	password: password,
		        	firstname: firstname,
		        	surname: surname,
		        	email: email
				};
        
        return this.http.post<any>(url, data, this.httpOptions);
    }

    eliminar(id:number): Observable<any>
    {
        var url = this.apiUrl + "usuarios/eliminar";
        var data = {
            id:id
        };
        return this.http.post<any>(url, data, this.httpOptions);
    }
    activar(id:number): Observable<any>
    {
        var url = this.apiUrl + "usuarios/activar";
        var data = {
            id:id
        };
        return this.http.post<any>(url, data, this.httpOptions);
    }

    desactivar(id:number): Observable<any>
    {
        var url = this.apiUrl + "usuarios/desactivar";
        var data = {
            id:id
        };
        return this.http.post<any>(url, data, this.httpOptions);
    }


    mostrar(idUsuario: number): Observable<any>
    {
        var url = this.apiUrl + "usuarios/mostrar/"+idUsuario;
        
        return this.http.get(url, this.httpOptions);
    }

    actualizar(idUsuario,rol_id,username,firstname,surname):Observable<any>
    {
        var url = this.apiUrl + "usuarios/edit";
        var data = {
            id:idUsuario,
            rol_id:rol_id,
            username:username,
            firstname:firstname,
            surname:surname
        };

        return this.http.post<any>(url, data, this.httpOptions);
    }
}
