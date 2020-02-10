import { Injectable } from "@angular/core";
import swal from "sweetalert2";

@Injectable()
export class AlertService
{
    constructor()
    {

    }

    success(message, title): void
    {
        swal({
            type:'success',
            title: title,
            text: message
        });
    }

    error(message, err): void
    {
        console.log(err);
        let title="Error";
        swal({
            type: 'error',
            title: title,
            text:message
        })
    }
}