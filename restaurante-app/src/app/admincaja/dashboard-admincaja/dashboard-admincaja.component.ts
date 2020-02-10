import { Component, OnInit } from '@angular/core';
import { Router } from '@angular/router';
import { CajaService } from '../caja.service';
import { AlertService } from "../../shared/services/alert.service";

@Component({
  selector: 'app-dashboard-admincaja',
  templateUrl: './dashboard-admincaja.component.html',
  styleUrls: ['./dashboard-admincaja.component.css']
})
export class DashboardAdmincajaComponent implements OnInit {

  constructor(private router:Router,
              private cajaService:CajaService,
              private alertService:AlertService
              ) { }

  montoActual:number = 0.0;
  estaCajaAbierta:boolean = true;
  montoFinal:number = 0.0;
  operacionesDeLaCaja: any[];

  ngOnInit() {
  	this.cargarEstadoInicial();
  }

  cargarEstadoInicial() {
  	this.cajaService.obtenerEstadoCaja()
      .subscribe(
        (response)=>{
          console.log(response);
          if(response.ok){
            this.montoActual = response.result.monto_actual;
            this.estaCajaAbierta = response.result.esta_abierta;
          }else{
            console.log("No se pudo obtener la data");
          }
        }
      );

    this.cajaService.obtenerOperacionesCaja().subscribe(
        (response)=>{
          console.log(response);
          if(response.ok) {
            this.operacionesDeLaCaja = response.result;
          } else {
            console.log("No se pudo obtener la data");
          }
        }
      );
  }

  btnAbrirCaja(){
  	this.cajaService.abrirCaja(this.montoActual).subscribe(
  			(response)=>{
	          console.log(response);
	          if(response.ok){
	            this.cargarEstadoInicial();
            	this.alertService.success(response.result, "Caja");
	          }else{
	            console.log("No se abrir la caja");
	            this.alertService.error(response.result, "Caja");
	          }
	      	},
		    (err)=>{
	          this.alertService.error("Error al abrir la caja",err);
        	}	
  		);
  }

  btnCerrarCaja() {
  	this.cajaService.cerrarCaja(this.montoFinal).subscribe(
  			(response)=>{
	          console.log(response);
	          if(response.ok){
	            this.cargarEstadoInicial();
            	this.alertService.success(response.result, "Caja");
	          }else{
	            console.log("No se abrir la caja");
	            this.alertService.error(response.result, "Caja");
	          }
	      	},
		    (err)=>{
	          this.alertService.error("Error al cerrar la caja",err);
        	}	
  		);
  }

  btnRegistrarOperacion() {
    console.log("Navegando a agregar un nuevo insumo: ");

    this.router.navigate(['/admincaja/operaciones/agregar']);
  }
}
