import { Component, OnInit } from '@angular/core';

import { Router,ActivatedRoute } from '@angular/router';

import { ProveedoresService } from "../proveedores.service";

import { AlertService } from "../../../shared/services/alert.service";

@Component({
  selector: 'app-proveedores-edit',
  templateUrl: './proveedores-edit.component.html',
  styleUrls: ['./proveedores-edit.component.css']
})
export class ProveedoresEditComponent implements OnInit {

  idProveedor=0;
  nombre:string="";
  direccion:string="";
  descripcion:string="";

  constructor(
    private router:Router,
    private proveedoresService:ProveedoresService,
    private route:ActivatedRoute,
    private alertService:AlertService
  ) { }

  ngOnInit() {
    this.cargarDatos();
  }

  cargarDatos()
  {
  	this.idProveedor = parseInt(this.route.snapshot.paramMap.get("id")); 
    this.proveedoresService.mostrar(this.idProveedor)
      .subscribe(
        (res)=>{
          console.log(res);
          if(res.ok && res.result!=null)
          {
            this.nombre=res.result.nombre_proveedor;
            this.direccion=res.result.direccion_proveedor;
            this.descripcion=res.result.descripcion;
          }
        }
      )
  }

  btnActualizarProveedor(){
    this.proveedoresService.editar(this.idProveedor,this.nombre,this.direccion,this.descripcion)
      .subscribe(
        (res)=>{
          this.alertService.success("Se actualizo correctamente","Actualizacion")
        }
      )
    this.router.navigate(['/admin/proveedores']);
  }

  btnCancelar(){
    this.router.navigate(['/admin/proveedores']);
  }

}
