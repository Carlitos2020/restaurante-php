import { Component, OnInit } from '@angular/core';

import { Router } from '@angular/router';

import { MesasServiceAdmin } from '../mesas.service';

import { AlertService } from "../../../shared/services/alert.service";

@Component({
  selector: 'app-mesas-add',
  templateUrl: './mesas-add.component.html',
  styleUrls: ['./mesas-add.component.css']
})
export class MesasAddComponent implements OnInit {

	numero_mesa: number;
  mesas:any[];
  cargando: boolean = false;
  constructor(
  		private router:Router, 
    	private mesasService:MesasServiceAdmin,
    	private alertService:AlertService
  	) { }

  ngOnInit() {
    this.cargarMesas();
  }

  btnAgregarMesa(){
  	this.mesasService.registrar(this.numero_mesa)
      .subscribe(
        (response)=>{
          console.log(response);
          if(response.ok){
            console.log("Elemento agregado correctamente");
            this.alertService.success("Se guardo correctamente la mesa","Mesa");
          }else{
            console.log("Ha ocurrido un error");
          }
          this.router.navigate(['/admin/mesas']);
        },
        (err)=>{
          this.alertService.error("Error al guardar mesa",err);
        }
      )
      this.cargarMesas();
  }

  btnCancelar(){
  	this.router.navigate(['/admin/dashboard']);
  }
  cargarMesas() {
    this.mesasService.listar().subscribe(
        (response)=>{
          console.log(response);
          if(response.ok){
            this.mesas = response.result;
          }else{
            console.log("No se pudo obtener la data");
          }

          this.cargando = false;
        }
      );
  }
}
