import { Component, OnInit } from '@angular/core';

import { Router } from '@angular/router';

import { PlatosService } from '../platos.service';

import { AlertService } from "../../../shared/services/alert.service";


@Component({
  selector: 'app-platos-list',
  templateUrl: './platos-list.component.html',
  styleUrls: ['./platos-list.component.css'],
  providers:  [ PlatosService ]
})

export class PlatosListComponent implements OnInit {
	platos: any[];

  constructor(private router:Router, private platosService:PlatosService, private alertService:AlertService) { 

  }

 ngOnInit() {
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

  btnEditar(id: number)
  {
      console.log("Navegando a editar el plato: "+id);

      this.router.navigate(['/admin/platos/editar/'+id]);
  }

  btnAgregar()
  {
      console.log("Navegando a agregar un nuevo plato: ");

      this.router.navigate(['/admin/platos/agregar']);
  }

   btnListarInsumos(id: number)
  {
    console.log("Navegando a agregar un nuevo plato: ");

    this.router.navigate(['/admin/platos/mostrar/insumos/'+id]);
  }

 btnEliminar(id:number)
  {
    this.platosService.eliminar(id)
    .subscribe(
      (response)=>{
        if(response.ok)
        {
          this.alertService.success("Eliminado correctamente","Eliminar");
          console.log("Se elimino correctamente");
          this.ngOnInit();
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


btnHabilitar(id:number)
  {
    this.platosService.habilitar(id)
    .subscribe(
      (response)=>{
        if(response.ok)
        {
          this.alertService.success("Habilitado correctamente","Habilitar");
          console.log("Se habilito correctamente");
          this.ngOnInit();
        }else{
          console.log("Ocurrio un error");
          this.alertService.error("Error al habilitar insumo",null);  
        }
      },
      (err) => {
        console.log("Ocurrio un error");
        this.alertService.error("Error al habilitar insumo",err);
      }
    )
  }

  btnDeshabilitar(id:number)
  {
    this.platosService.deshabilitar(id)
    .subscribe(
      (response)=>{
        if(response.ok)
        {
          this.alertService.success("Deshabilitado correctamente","Deshabilitar");
          console.log("Se deshabilito correctamente");
          this.ngOnInit();
        }else{
          console.log("Ocurrio un error");
          this.alertService.error("Error al deshabilitar insumo",null);  
        }
      },
      (err) => {
        console.log("Ocurrio un error");
        this.alertService.error("Error al deshabilitar insumo",err);
      }
    )
  }


}
