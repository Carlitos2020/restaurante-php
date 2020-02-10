import { Component, OnInit } from '@angular/core';
import { Router } from '@angular/router';
import { MesasService } from "../mesas/mesas.service";

@Component({
  selector: 'app-dashboard-mozo',
  templateUrl: './dashboard-mozo.component.html',
  styleUrls: ['./dashboard-mozo.component.css']
})
export class DashboardMozoComponent implements OnInit {

  mesaEscogida:number = 1;
  mesas: any[];

  cargando: boolean = false;
  //Variable que el modulo pedidos-add revisará para 
  //actualizar la lista de pedidos de la mesa
  actualizacionPedidos:boolean = false; 

  constructor(private router:Router, 
              private mesasService:MesasService, 
              ) { }

  ngOnInit() {
    this.cargando = true;
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

          this.cargando = false;
        }
      );
  }

  btnCambioNumeroMesa(numMesa:number)
  {
    console.log("Mesa escogida: " + numMesa);
    this.mesaEscogida = numMesa;
  }

  recargarPedidos(){ //NECESITA MEJORARSE
    this.actualizacionPedidos = !this.actualizacionPedidos;
  }
}
