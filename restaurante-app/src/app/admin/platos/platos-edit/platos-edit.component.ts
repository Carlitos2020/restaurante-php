import { Component, OnInit } from '@angular/core';

import { Router, ActivatedRoute } from '@angular/router';

import { PlatosService } from '../platos.service';

import { AlertService } from "../../../shared/services/alert.service";

@Component({
  selector: 'app-platos-edit',
  templateUrl: './platos-edit.component.html',
  styleUrls: ['./platos-edit.component.css'],
  providers:  [ PlatosService ]
})
export class PlatosEditComponent implements OnInit {
	idPlato:number=0;
 	nombre_plato:string="";
  precio:number=0.0;

  constructor(private router:Router,
     private route:ActivatedRoute, private platosService:PlatosService, private alertService:AlertService) { }

  ngOnInit() {
  	 //Obtengo el parametro de la url
  	this.idPlato = parseInt(this.route.snapshot.paramMap.get("id")); 

      this.platosService.mostrar(this.idPlato)
      .subscribe(
        (response)=>{
          console.log(response);
          if(response.ok){
            this.nombre_plato = response.result.nombre_plato;
            this.precio = response.result.precio;

          }else{
            console.log("No se pudo obtener la data");
            this.router.navigate(['/admin/platos']);

          }
        }
      )
  }

   btnActualizarPlato(){
    this.platosService.editar(this.idPlato, this.nombre_plato, this.precio)
      .subscribe(
        (response)=>{
          console.log(response);
          if(response.ok){            
            console.log("Elemento editado correctamente");
            this.alertService.success("Datos Actualizados","Platos");
          }else{
            console.log("Ha ocurrido un error");
          }
          this.router.navigate(['/admin/platos']);        
        },
        (err)=>{
          this.alertService.error("Error al actualizar",err);
        }
      )
  }

  btnCancelar(){
    this.router.navigate(['/admin/platos']);
  }

}
