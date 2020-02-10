import { Component, OnInit, Input, OnChanges, SimpleChanges } from '@angular/core';
import { Router } from '@angular/router';
import { PedidosService } from "../pedidos.service";
import { AlertService } from "../../../shared/services/alert.service";

@Component({
  selector: 'app-pedidos-list',
  templateUrl: './pedidos-list.component.html',
  styleUrls: ['./pedidos-list.component.css']
})
export class PedidosListComponent implements OnInit, OnChanges {

  @Input() numMesa:number;
  @Input() hayQueRecargar:boolean;
  pedidos: any[];
  
  constructor(private router:Router,
              private pedidosService:PedidosService, 
              private alertService:AlertService) { }

  ngOnInit() {
  	this.cargarPedidos();
  }

  cargarPedidos()
  {
      this.pedidosService.listarDeMesa(this.numMesa).subscribe(
        (response) => {
          console.log(response);
          if(response.ok) {
            this.pedidos = response.result;
          } else {
            console.log("No se pudo obtener la data");
          }
        }
      );
  }

    btnEditar(id: number)
  {
      console.log("Navegando a editar el pedido: "+id);

      this.router.navigate(['/mozo/pedidos/editar/'+id]);
  }

  btnEliminar(id:number)
  {
    this.pedidosService.eliminar(id)
    .subscribe(
      (response)=>{
        if(response.ok)
        {
          this.alertService.success("Eliminado correctamente","Eliminar");
          console.log("Se elimino correctamente");
          this.cargarPedidos();
        }else{
          console.log("Ocurrio un error");
          this.alertService.error("Error al eliminar pedido",null);  
        }
      },
      (err) => {
        console.log("Ocurrio un error");
        this.alertService.error("Error al eliminar pedido",err);
      }
    )
  }

  //Cuando cambia el numero de mesa recargo la lista de pedidos
  ngOnChanges(changes: SimpleChanges) {
    this.cargarPedidos();
  }
}
