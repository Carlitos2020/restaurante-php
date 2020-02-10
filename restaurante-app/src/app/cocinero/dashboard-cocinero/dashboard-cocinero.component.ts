import { Component, OnInit } from '@angular/core';

import { Router } from '@angular/router';

import { DashboardService } from '../dashboard-cocinero/dashboard-cocinero.service';

import { AlertService } from "../../shared/services/alert.service";



@Component({
  selector: 'app-dashboard-cocinero',
  templateUrl: './dashboard-cocinero.component.html',
  styleUrls: ['./dashboard-cocinero.component.css']
})
export class DashboardCocineroComponent implements OnInit {


  idSetInterval;
	pedidosCP: any[];
  pedidosSP: any[];
  pedidosEP: any[];
  pedidosL: any[];

  constructor(private router:Router, private dashboardService:DashboardService,private alertService:AlertService) { }

  ngOnInit() {
     this.llenarDatos();
     
     this.idSetInterval = setInterval(() => {
      this.llenarDatos();
      console.log("cargando..............")
    }, 5000);
  }

   llenarDatos()
  {
    this.dashboardService.listaPedidosCP()
      .subscribe(
        (response)=>{
          console.log(response);
          if(response.ok){
            this.pedidosCP = response.result;
          }else{
            console.log("No se pudo obtener la data");
          }
        }
      );

      this.dashboardService.listaPedidosSP()
      .subscribe(
        (response)=>{
          console.log(response);
          if(response.ok){
            this.pedidosSP = response.result;
          }else{
            console.log("No se pudo obtener la data");
          }
        }
      );

        this.dashboardService.listaPedidosEnPreparacion()
      .subscribe(
        (response)=>{
          console.log(response);
          if(response.ok){
            this.pedidosEP = response.result;
          }else{
            console.log("No se pudo obtener la data");
          }
        }
      );

        this.dashboardService.listaPedidosListos()
      .subscribe(
        (response)=>{
          console.log(response);
          if(response.ok){
            this.pedidosL = response.result;
          }else{
            console.log("No se pudo obtener la data");
          }
        }
      );

  }

  btnPasarEnPreparacion(id:number)
  {
    this.dashboardService.pasarPeidoAEnPreparacion(id)
    .subscribe(
      (response)=>{
        if(response.ok)
        {
          this.alertService.success("Cambio de estado correctamente","Estado En preparacion");
          console.log("Se cambio correctamente a EN PREPACION"+id);
          this.ngOnInit();
        }else{
          console.log("Ocurrio un error");
          this.alertService.error("Error al cambiar de estado",null);  
        }
      },
      (err) => {
        console.log("Ocurrio un error");
        this.alertService.error("Error al cambiar de estado",err);
      }
    )
  }

  btnPasarListo(id:number)
  {
    this.dashboardService.pasarPedidoAListo(id)
    .subscribe(
      (response)=>{
        if(response.ok)
        {
          this.alertService.success("Cambio de estado correctamente","Estado listo");
          console.log("Se cambio correctamente A PREPARADO");
          this.ngOnInit();
        }else{
          console.log("Ocurrio un error");
          this.alertService.error("Error al cambiar de estado",null);  
        }
      },
      (err) => {
        console.log("Ocurrio un error");
        this.alertService.error("Error al cambiar de estado",err);
      }
    )
  }

  

}
