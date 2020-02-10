import { Component, OnInit } from '@angular/core';

import { Router, ActivatedRoute } from '@angular/router';

import { EntradasService } from '../entradas.service'

import { AlertService } from "../../../shared/services/alert.service";

@Component({
  selector: 'app-entradas-edit',
  templateUrl: './entradas-edit.component.html',
  styleUrls: ['./entradas-edit.component.css']
})
export class EntradasEditComponent implements OnInit {

  idInsumo:number=0;
  nombre_insumo:string="";
  cantidad:number=0.0;

  constructor(private router:Router,
     private route:ActivatedRoute, 
     private alertService:AlertService,
     private entradasService:EntradasService) {}
  
  ngOnInit() {
    //Obtengo el parametro de la url
  	this.idInsumo = parseInt(this.route.snapshot.paramMap.get("id")); 

      this.entradasService.mostrar(this.idInsumo)
      .subscribe(
        (response)=>{
          console.log(response);
          if(response.ok){
            this.nombre_insumo = response.result.nombre_insumo;
            this.cantidad = response.result.cantidad;

          }else{
            console.log("No se pudo obtener la data");
            this.router.navigate(['/adminalmacen/entradas']);

          }
        }
      )
  }

  btnActualizarEntrada(){
    this.entradasService.editar(this.idInsumo, this.cantidad)
      .subscribe(
        (response)=>{
          console.log(response);
          if(response.ok){
            console.log("Elemento editado correctamente");
            this.alertService.success("Datos Actualizados","Entradas");
          }else{
            console.log("Ha ocurrido un error");
          }
          this.router.navigate(['/adminalmacen/entradas']);        
        },
        (err)=>{
          this.alertService.error("Error al actualizar",err);
        }
      )
  }

  btnCancelar(){
    this.router.navigate(['/adminalmacen/entradas']);
  }
}