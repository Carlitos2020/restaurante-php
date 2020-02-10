import { Component, OnInit } from '@angular/core';

import { Router, ActivatedRoute } from '@angular/router';

import { InsumosService } from '../insumos.service'

import { AlertService } from "../../../shared/services/alert.service";

@Component({
  selector: 'app-insumos-edit',
  templateUrl: './insumos-edit.component.html',
  styleUrls: ['./insumos-edit.component.css']
})
export class InsumosEditComponent implements OnInit {

  idInsumo:number=0;
  nombre_insumo:string="";
  cantidad_minima:number=0.0;

  constructor(private router:Router,
     private route:ActivatedRoute, 
     private alertService:AlertService,
     private insumosService:InsumosService) {}
  
  ngOnInit() {
    //Obtengo el parametro de la url
  	this.idInsumo = parseInt(this.route.snapshot.paramMap.get("id")); 

      this.insumosService.mostrar(this.idInsumo)
      .subscribe(
        (response)=>{
          console.log(response);
          if(response.ok){
            this.nombre_insumo = response.result.nombre_insumo;
            this.cantidad_minima = response.result.cantidad_minima;

          }else{
            console.log("No se pudo obtener la data");
            this.router.navigate(['/admin/insumos']);

          }
        }
      )
  }

  btnActualizarInsumo(){
    this.insumosService.editar(this.idInsumo, this.nombre_insumo, this.cantidad_minima)
      .subscribe(
        (response)=>{
          console.log(response);
          if(response.ok){
            console.log("Elemento editado correctamente");
            this.alertService.success("Datos Actualizados","Insumos");
          }else{
            console.log("Ha ocurrido un error");
          }
          this.router.navigate(['/admin/insumos']);        
        },
        (err)=>{
          this.alertService.error("Error al actualizar",err);
        }
      )
  }

  btnCancelar(){
    this.router.navigate(['/admin/insumos']);
  }
}
