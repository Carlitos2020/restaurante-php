import { Injectable } from "@angular/core";
import { HttpHeaders } from "@angular/common/http";

@Injectable()
export class HeaderService
{
    constructor()
    {

    }

	getHttpOptions(sendToken:boolean):object {
		let httpOptions:object;
		
		let headers = new HttpHeaders();
		headers = headers.set("Content-Type", "application/json; charset=utf-8");

		if (sendToken) {
			let token = localStorage.getItem("token");
			headers = headers.set('Token', token);
		}
		
		httpOptions = {headers: headers};
		return httpOptions;
	}

}