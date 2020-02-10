import { Component, OnInit } from '@angular/core';
import { Router } from '@angular/router';
import { CajaService } from '../../caja.service';
import { AlertService } from "../../../shared/services/alert.service";

@Component({
  selector: 'app-operaciones-add',
  templateUrl: './operaciones-add.component.html',
  styleUrls: ['./operaciones-add.component.css']
})
export class OperacionesAddComponent implements OnInit {

  constructor(private router:Router,
              private cajaService:CajaService,
              private alertService:AlertService
              ) { }

  esEntrada:boolean = true;
  montoOperacion:number = 0.0;
  montoCaja:number = 0.0;
  nuevoMontoCaja:number = 0.0;
  descripcion:string = "";

  ngOnInit() {
    this.cajaService.obtenerEstadoCaja().subscribe(
      (response)=>{
        console.log(response);
        if(response.ok){
          this.montoCaja = response.result.monto_actual;
          this.nuevoMontoCaja = this.montoCaja;
        }else{
          console.log("No se pudo obtener la data");
        }
      }
    );
  }

  cambiarMonto() {
    this.nuevoMontoCaja = (+this.montoCaja);
    
    if(this.esEntrada) {
      this.nuevoMontoCaja += this.montoOperacion;
    } else {
      this.nuevoMontoCaja -= this.montoOperacion;
    }

  }

  btnAgregarOperacion() {
    var monto = this.montoOperacion;
    if(!this.esEntrada){
      monto = -monto;
    }

    this.cajaService.registrarOperacion(monto, this.descripcion)
      .subscribe(
        (response)=>{
          console.log(response);
          if(response.ok){
            this.alertService.success(response.result, "Operaciones caja");
            this.router.navigate(['/admincaja/dashboard']); 
          }else{
            this.alertService.error(response.result, "Operaciones caja");
          }
        },
        (error)=>{
          this.alertService.error("No se pudo registrar la operación", "Operaciones caja");
        }
     );
  }

  btnCancelar() {
    this.router.navigate(['/admincaja/dashboard']);
  }
}
