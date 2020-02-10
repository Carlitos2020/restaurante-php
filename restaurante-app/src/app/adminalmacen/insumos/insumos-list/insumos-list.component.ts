import { Component, OnInit } from '@angular/core';

import { Router } from '@angular/router';

import { InsumosService } from '../insumos.service';

import { AlertService } from "../../../shared/services/alert.service";

@Component({
  selector: 'app-insumos-list',
  templateUrl: './insumos-list.component.html',
  styleUrls: ['./insumos-list.component.css']

})
export class InsumosListComponent implements OnInit {

  insumos: any[];

  constructor(private router:Router, private insumosService:InsumosService, private alertService:AlertService) {}
  //constructor(private router:Router) {}

  ngOnInit() {
      this.llenarDatos();
  }


   llenarDatos()
  {
    this.insumosService.listar()
      .subscribe(
        (response)=>{
          console.log(response);
          if(response.ok){
            this.insumos = response.result;
          }else{
            console.log("No se pudo obtener la data");
          }
        }
      );
  }

  btnEditar(id: number)
  {
      console.log("Navegando a editar el insumo: "+id);

      this.router.navigate(['/adminalmacen/insumos/editar/'+id]);
  }

  btnAgregar()
  {
      console.log("Navegando a agregar un nuevo insumo: ");

      this.router.navigate(['/adminalmacen/insumos/agregar']);
  }

  btnEliminar(id:number)
  {
    this.insumosService.eliminar(id)
    .subscribe(
      (response)=>{
        if(response.ok)
        {
          this.alertService.success("Eliminado correctamente","Eliminar");
          console.log("Se elimino correctamente");
          this.llenarDatos();
        }else{
          console.log("Ocurrio un error");
          this.alertService.error("Error al eliminar insumo",null);  
        }
      },
      (err) => {
        console.log("Ocurrio un error");
        this.alertService.error("Error al eliminar insumo",err);
      }
    )
  }



}
