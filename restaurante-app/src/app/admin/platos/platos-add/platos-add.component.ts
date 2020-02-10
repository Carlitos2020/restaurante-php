import { Component, OnInit } from '@angular/core';

import { Router } from '@angular/router';

import { PlatosService } from '../platos.service'

import { AlertService } from "../../../shared/services/alert.service";

@Component({
  selector: 'app-platos-add',
  templateUrl: './platos-add.component.html',
  styleUrls: ['./platos-add.component.css'],
  providers:  [ PlatosService ]
})
export class PlatosAddComponent implements OnInit {

  nombre_plato:string="";
  precio:number=0.0;
 

  constructor(
    private router:Router, 
    private platosService:PlatosService,
    private alertService:AlertService
    ) { }

  ngOnInit() {
  }

  btnAgregarPlato(){

    this.platosService.registrar(this.nombre_plato,this.precio)
      .subscribe(       

        (response)=>{
          console.log(response);
          if(response.ok){
            console.log("Elemento agregado correctamente");
            this.alertService.success("Guardado correctamente","Guardar Plato");
            this.router.navigate(['/admin/platos']);
          }
        },
        (err) => {
          this.alertService.error("Error al guardar Plator",err);
          console.log("Ha ocurrido un error");
        }        
      )
  }

  btnCancelar(){
    this.router.navigate(['/admin/platos']);
  }

}
