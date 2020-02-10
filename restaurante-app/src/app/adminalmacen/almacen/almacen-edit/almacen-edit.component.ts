import { Component, OnInit } from '@angular/core';
import { Router, ActivatedRoute } from '@angular/router';

import { AlmacenControlService } from '../almacenControl.service';

import { AlertService } from "../../../shared/services/alert.service";


@Component({
  selector: 'app-almacen-edit',
  templateUrl: './almacen-edit.component.html',
  styleUrls: ['./almacen-edit.component.css']
})
export class AlmacenEditComponent implements OnInit {
	idInsumo:number=0;
	Insumo:string="";
    Total:number=0.0;
    cantidad_ajustada:number=0.0;

  	constructor(
  		private router:Router,
     	private route:ActivatedRoute, 
     	private alertService:AlertService,
     	private almacenControlService:AlmacenControlService
  	) { }

  	ngOnInit() {
    //Obtengo el parametro de la url
  	this.idInsumo = parseInt(this.route.snapshot.paramMap.get("id")); 

      this.almacenControlService.mostrar(this.idInsumo)
      .subscribe(
        (response)=>{
          console.log(response);
          if(response.ok){
            this.Insumo = response.result.Insumo;
            this.Total = response.result.Total;

          }else{
            console.log("No se pudo obtener la data");
            this.router.navigate(['/adminalmacen/almacenControl']);

          }
        }
      )
  	}

  	btnAjustarInsumo(){
    this.almacenControlService.editar(this.idInsumo, this.Total, this.cantidad_ajustada)
      .subscribe(
        (response)=>{
          console.log(response);
          if(response.ok){
            console.log("Elemento ajustado correctamente");
            this.alertService.success("Datos Actualizados","Existencias");
          }else{
            console.log("Ha ocurrido un error");
          }
          this.router.navigate(['/adminalmacen/almacenControl']);        
        },
        (err)=>{
          this.alertService.error("Error al actualizar",err);
        }
      )
  }

  	btnCancelar(){
  		this.router.navigate(['/adminalmacen/almacenControl']);
  	}
}
