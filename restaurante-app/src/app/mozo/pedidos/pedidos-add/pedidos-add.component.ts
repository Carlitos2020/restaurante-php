import { Component, Input, OnInit } from '@angular/core';
import { Router } from '@angular/router';
import { MesasService } from "../../mesas/mesas.service";
import { PedidosService } from "../pedidos.service";
import { PlatosService } from "../../platos/platos.service";
import { AlertService } from "../../../shared/services/alert.service";

@Component({
  selector: 'app-pedidos-add',
  templateUrl: './pedidos-add.component.html',
  styleUrls: ['./pedidos-add.component.css']
})
export class PedidosAddComponent implements OnInit {

  platos: any[];

  idPlato:number = 0;
  @Input() numMesa:number; //El numero de mesa viene del componente padre

  constructor(private router:Router,
              private mesasService:MesasService, 
              private platosService:PlatosService, 
              private pedidosService:PedidosService, 
              private alertService:AlertService) { }

  ngOnInit() {
  	this.llenarDatos();
  }

  llenarDatos()
  {
    this.platosService.listar()
      .subscribe(
        (response)=>{
          console.log(response);
          if(response.ok){
            this.platos = response.result;
          }else{
            console.log("No se pudo obtener la data");
          }
        }
      );

  }

  btnAgregarPedido(){
	this.pedidosService.agregar(this.idPlato, this.numMesa)
      .subscribe(
        (response)=>{
          console.log(response);
          if(response.ok){
          	this.alertService.success(response.result, "Pedidos");
           	this.router.navigate(['/mozo/dashboard']); 
          }else{
            this.alertService.error(response.result, "Pedidos");
          }
        },
      	(err)=>{
          this.alertService.error("Error al guardar pedido",err);
        }
      );
  }
}
