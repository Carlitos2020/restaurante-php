import { Component, OnInit } from '@angular/core';

import { Router } from '@angular/router';

import { AlmacenControlService } from "../almacenControl.service";

import { AlertService } from "../../../shared/services/alert.service";

@Component({
  selector: 'app-almacen-list',
  templateUrl: './almacen-list.component.html',
  styleUrls: ['./almacen-list.component.css'],
  providers:  [ AlmacenControlService ]
})
export class AlmacenListComponent implements OnInit {
/*<h4 [ngClass]="{'text-danger': montoCaja < 0, 'text-success': montoCaja > 0}">*/

	existencias:any[];
  constructor(
  		private router:Router, 
  		private almacenControlService:AlmacenControlService, 
  		private alertService:AlertService
  	) { }

  ngOnInit() {

  	this.llenarDatos();
  }

  llenarDatos(){
  	
    this.almacenControlService.listar()
      .subscribe(
        (response)=>{
          console.log(response);
          if(response.ok){
            this.existencias = response.result;
          }else{
            console.log("No se pudo obtener la data");
          }
        }
    );
  }

  btnEditar(id:number){

  	console.log("Navegando a ajustar eal almacen: "+id);

    this.router.navigate(['/adminalmacen/almacen/ajustar/'+id]);
  }

}
