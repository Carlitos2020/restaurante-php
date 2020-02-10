import { Component, OnInit } from '@angular/core';

import { Router,ActivatedRoute } from '@angular/router';

import { ProveedoresService } from "../proveedores.service";

import { AlertService } from "../../../shared/services/alert.service";

@Component({
  selector: 'app-proveedores-add',
  templateUrl: './proveedores-add.component.html',
  styleUrls: ['./proveedores-add.component.css']
})
export class ProveedoresAddComponent implements OnInit {


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

  }


  btnAgregarProveedor()
  {
    this.proveedoresService.registrar(this.nombre,this.direccion,this.descripcion)
      .subscribe(
        (res)=>{
          if(res.ok)
          {
            this.alertService.success("Guardado correctamente","Guardar Proveedor");
            this.router.navigate(['/adminalmacen/proveedores']);
          }
        },
        (err) => {
					this.alertService.error("Error al guardar proveedor",err);
				}
      )
  }

  btnCancelar(){
    this.router.navigate(['/adminalmacen/proveedores']);
  }

}
