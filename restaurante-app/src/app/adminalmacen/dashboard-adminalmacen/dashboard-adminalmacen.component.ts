import { Component, OnInit } from '@angular/core';
import { Router } from '@angular/router';
import { AlertService } from "../../shared/services/alert.service";
import { DashboardService } from "../dashboard-adminalmacen/dashboard.service";

@Component({
  selector: 'app-dashboard-adminalmacen',
  templateUrl: './dashboard-adminalmacen.component.html',
  styleUrls: ['./dashboard-adminalmacen.component.css']
})
export class DashboardAdminalmacenComponent implements OnInit {

	  existencias:any[];

  constructor(
  		private router:Router, 
  		private alertService:AlertService, 
  		private dashboardService:DashboardService
  	) { }


  ngOnInit() {
  	this.llenarDatos();

  }
  llenarDatos(){
  	
    this.dashboardService.listar()
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
}
