import { Injectable } from "@angular/core";

@Injectable()
export class TokenService
{
    constructor(){

    }

    empty()
    {
        localStorage.removeItem('token')
    }

    set(token: string)
    {
        localStorage.setItem('token', token);
    }
}