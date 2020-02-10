import { Injectable } from '@angular/core';
import { HttpClient, HttpHeaders } from '@angular/common/http';
import { Observable } from 'rxjs/Observable';
import { environment } from '../../environments/environment';
import { HeaderService } from '../shared/services/header.service';


 @Injectable()
 export class SecurityService
 {

	httpOptions:object;
    private apiUrl:string = environment.apiUrl;
    
     constructor(
		private http:HttpClient,
		private headerService:HeaderService
     )
     {
		let headers = new HttpHeaders();
        headers = headers.set("Accept", "application/json");
        
		this.httpOptions = { headers: headers };
     }


     login(email:string, password:string): Observable<any>
     {
        var url = this.apiUrl + "login";
        var data = { username: email, password: password };
        
		return this.http.post<any>(url, data, this.httpOptions);
     }
 }
