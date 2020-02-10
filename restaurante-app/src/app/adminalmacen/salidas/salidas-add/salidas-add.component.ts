import { Component, OnInit } from '@angular/core';

import { Router,ActivatedRoute } from '@angular/router';

import { SalidasService } from "../salidas.service";

import { AlertService } from "../../../shared/services/alert.service";

@Component({
  selector: 'app-salidas-add',
  templateUrl: './salidas-add.component.html',
  styleUrls: ['./salidas-add.component.css']
})
export class SalidasAddComponent implements OnInit {

  idInsumo:number = 0;
  cantidad:number = 0;
  descripcion:string = "";
  insumos:any[];

  constructor(
		private router:Router, 
        private salidasService:SalidasService,
        private alertService:AlertService
  ) { }

  ngOnInit() {
  	this.llenarDatos();
  }

  llenarDatos() {
  	this.salidasService.listarInsumos()
      .subscribe(
        (response)=>{
          console.log(response);
          if(response.ok){
            this.insumos = response.result;
          }else{
            console.log("No se pudo obtener la data");
          }
        }
      );
  }

   btnAgregarSalida(){
  	this.salidasService.registrar(this.idInsumo, -this.cantidad, this.descripcion)
      .subscribe(
        (response)=>{
          if(response.ok){
            this.alertService.success("Se guardo correctamente la salida","Salidas");
          }else{
            this.alertService.error(response.result, "Salidas");
          }
          this.router.navigate(['/adminalmacen/salidas']);
        },
        (err)=>{
          this.alertService.error("Error al guardar la entrada",err);
        }
      )
  }

  btnCancelar(){
  	this.router.navigate(['/adminalmacen/salidas']);
  }

}
