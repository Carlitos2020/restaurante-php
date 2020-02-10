import { Component, OnInit } from '@angular/core';

import { Router } from '@angular/router';

import { InsumosService } from '../insumos.service'

import { AlertService } from "../../../shared/services/alert.service";

@Component({
  selector: 'app-insumos-add',
  templateUrl: './insumos-add.component.html',
  styleUrls: ['./insumos-add.component.css']
})
export class InsumosAddComponent implements OnInit {

  nombre_insumo:string="";
  cantidad_minima:number=0.0;
  unidades:string="";

  constructor(
    private router:Router, 
    private insumosService:InsumosService,
    private alertService:AlertService
    ) {}

  ngOnInit() {
  }

  btnAgregarInsumo(){

    this.insumosService.registrar(this.nombre_insumo, this.cantidad_minima, this.unidades)
      .subscribe(
        (response)=>{
          console.log(response);
          if(response.ok){
            console.log("Elemento agregado correctamente");
            this.alertService.success("Se guardo correctamente el insumo","Insumos");
          }else{
            console.log("Ha ocurrido un error");
          }
          this.router.navigate(['/adminalmacen/insumos']);
        },
        (err)=>{
          this.alertService.error("Error al guardar insumo",err);
        }
      )
  }

  btnCancelar(){
    this.router.navigate(['/adminalmacen/insumos']);
  }
}
