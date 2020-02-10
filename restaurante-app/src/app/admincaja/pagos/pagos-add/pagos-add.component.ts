import { Component, OnInit } from '@angular/core';
import { Router } from '@angular/router';
import { MesasService } from "../../mesas/mesas.service";
import { CajaService } from "../../caja.service";
import { AlertService } from "../../../shared/services/alert.service";

@Component({
  selector: 'app-pagos-add',
  templateUrl: './pagos-add.component.html',
  styleUrls: ['./pagos-add.component.css']
})
export class PagosAddComponent implements OnInit {

  numMesa: number = 1;
  mesas: any[];
  pedidos: any[];

  constructor(private router:Router, 
              private mesasService:MesasService, 
              private cajaService:CajaService, 
              private alertService:AlertService
              ) { }

  ngOnInit() {
  	this.cargarMesas();
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
        }
      );
  }

  btnCambioNumeroMesa(numMesa:number)
  {
    console.log("Mesa escogida: " + numMesa);
    this.numMesa = numMesa;
    this.obtenerConsumosPorMesa()
  }

  btnRegistrarPago()
  {
    this.cajaService.registrarPago(this.numMesa).subscribe(
        (response)=>{
          console.log(response);
          if(response.ok){
            this.alertService.success(response.result, "Operaciones caja");
          }else{
            this.alertService.error(response.result, "Operaciones caja");
          }
        }
      );
  }


  obtenerConsumosPorMesa()
  {
    this.cajaService.obtenerConsumosPorMesa(this.numMesa)
      .subscribe(
        (res)=>{
          console.log(res);
          this.pedidos=res.result;
        }
      )
  }

}
