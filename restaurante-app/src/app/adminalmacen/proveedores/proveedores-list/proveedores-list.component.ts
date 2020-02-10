import { Component, OnInit } from '@angular/core';

import { Router } from '@angular/router';

import { ProveedoresService } from "../proveedores.service";

import { AlertService } from "../../../shared/services/alert.service";

@Component({
  selector: 'app-proveedores-list',
  templateUrl: './proveedores-list.component.html',
  styleUrls: ['./proveedores-list.component.css']
})
export class ProveedoresListComponent implements OnInit {


  proveedores: any[];

  constructor(
    private router:Router,
    private proveedoresService:ProveedoresService,
    private alertService:AlertService
  ) { }

  ngOnInit() {
    this.llenarDatos();
  }


  llenarDatos()
  {
    
    this.proveedoresService.listar()
      .subscribe(
        (res)=>{
          console.log(res);
          if(res.ok)
          {
            this.proveedores=res.result;
          }
        }
      )
  }

  btnEditar(id: number)
  {
      console.log("Navegando a editar el insumo: "+id);
      this.router.navigate(['/adminalmacen/proveedores/editar/'+id]);
  }

  btnAgregar()
  {
      console.log("Navegando a agregar un nuevo insumo: ");

      this.router.navigate(['/adminalmacen/proveedores/agregar']);
  }


  btnEliminar(id)
  {
    this.proveedoresService.eliminarProveedor(id)
    .subscribe(
      (res)=>{
        if(res.ok)
        {
          this.alertService.success("Eliminado correctamente","Eliminar");
          this.llenarDatos();
        }else{
          this.alertService.error("Error al eliminar proveedor",null);  
        }
      },
      (err) => {
        this.alertService.error("Error al eliminar proveedor",err);
      }
    )
  }
  btnListarInsumos(id: number)
  {
    console.log("Navegando a agregar un nuevo insumo del proveedor: ");

    this.router.navigate(['/adminalmacen/proveedores/mostrar/insumos/'+id]);
  }
}
