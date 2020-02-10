import { Component, OnInit } from '@angular/core';
import { Router } from '@angular/router';
import { PedidosService } from "../pedidos.service";
import { AlertService } from "../../../shared/services/alert.service";

@Component({
  selector: 'app-pedidos-ready',
  templateUrl: './pedidos-ready.component.html',
  styleUrls: ['./pedidos-ready.component.css']
})
export class PedidosReadyComponent implements OnInit {

  idSetInterval;
  
  constructor(private router:Router,
              private pedidosService:PedidosService, 
              private alertService:AlertService) { }

  pedidos: any[];

  ngOnInit() {
	  this.cargarPedidosListos();
	  
      
      this.idSetInterval = setInterval(() => {
        this.cargarPedidosListos();
        console.log("cargando..............")
      }, 5000);
  }


  ngOnDestroy() {
    if (this.idSetInterval) {
      clearInterval(this.idSetInterval);
    }
  }

  cargarPedidosListos() {
  	this.pedidosService.listarListos().subscribe(
  		(response) => {
  			if(response.ok) {
  				this.pedidos = response.result;
  			} else {
  				console.log("No se pudo obtener la data");
  			}
  		}
  	);
  }

  btnPasarPedidoAEntregado(idPedido: number) {
  	this.pedidosService.pasarPedidoAEntregado(idPedido).subscribe(
  		(response) => {
  			if(response.ok) {
  				this.alertService.success(response.result, "Pedido");
  				this.cargarPedidosListos();
  			} else {
  				this.alertService.error(response.result, "Pedido");
  			}
  		},
  		(error) => {
  			this.alertService.error("No se pudo cambiar el estado del pedido", "Pedido");
  		}
  	);
  }
}
