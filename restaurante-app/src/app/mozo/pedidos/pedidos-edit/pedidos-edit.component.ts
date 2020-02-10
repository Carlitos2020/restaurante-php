import { Component, OnInit } from '@angular/core';
import { Router, ActivatedRoute } from '@angular/router';
import { MesasService } from "../../mesas/mesas.service";
import { PedidosService } from "../pedidos.service";
import { PlatosService } from "../../platos/platos.service";
import { AlertService } from "../../../shared/services/alert.service";


@Component({
  selector: 'app-pedidos-edit',
  templateUrl: './pedidos-edit.component.html',
  styleUrls: ['./pedidos-edit.component.css']
})
export class PedidosEditComponent implements OnInit {

  mesas: any[];
  platos: any[];

  idPedido:number=0;
  idPlato:number=0;
  numMesa:number = 0;

  constructor(
              private router:Router,
              private route:ActivatedRoute, 
              private mesasService:MesasService, 
              private platosService:PlatosService, 
              private pedidosService:PedidosService, 
              private alertService:AlertService) {}
  
  ngOnInit() {
    //Obtengo el parametro de la url
  	this.idPedido = parseInt(this.route.snapshot.paramMap.get("id")); 

      this.pedidosService.mostrar(this.idPedido)
      .subscribe(
        (response)=>{
          console.log(response);
          if(response.ok){
            this.idPlato = response.result.idplato;
            this. numMesa = response.result.num_mesa;

          }else{
            console.log("No se pudo obtener la data");
            this.router.navigate(['/mozo/pedidos']);

          }
        }
      )

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

  btnActualizarPedido(){
    this.pedidosService.editar(this.idPedido, this.idPlato, this.numMesa)
      .subscribe(
        (response)=>{
          console.log(response);
          if(response.ok){
            console.log("Elemento editado correctamente");
            this.alertService.success("Datos Actualizados","Pedidos");
          }else{
            console.log("Ha ocurrido un error");
          }
          this.router.navigate(['/mozo/dashboard']);        
        },
        (err)=>{
          this.alertService.error("Error al actualizar",err);
        }
      )
  }

  btnCancelar(){
    this.router.navigate(['/mozo/dashboard']);
  }
}
