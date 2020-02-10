import { Component, OnInit } from '@angular/core';

import { Router, ActivatedRoute } from '@angular/router';

import { ProveedoresService } from '../proveedores.service';

import { AlertService } from "../../../shared/services/alert.service";

@Component({
  selector: 'app-proveedores-insumos-add',
  templateUrl: './proveedores-insumos-add.component.html',
  styleUrls: ['./proveedores-insumos-add.component.css']

})
export class ProveedoresInsumosAddComponent implements OnInit {
  idProveedor:number=0;
  insumos: any[];
  nombre_insumo:string="";
  cantidad_minima:number=0.0;

  constructor(
    private router:Router,
    private route:ActivatedRoute,
    private proveedoresService:ProveedoresService,
    private alertService:AlertService
    ) {}
  //constructor(private router:Router) {}

  ngOnInit() {
      this.llenarDatos();
  }


   llenarDatos()
  {
    this. idProveedor= parseInt( this.route.snapshot.paramMap.get("id")); 
    this.proveedoresService.listarInsumos(this.idProveedor)
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

  btnCancelar(){
    this.router.navigate(['/adminalmacen/proveedores/mostrar/insumos/'+this.idProveedor]);
  }

  btnAgregarInsumo(){
    this.proveedoresService.agregarInsumoProveedor(this.idProveedor,this.nombre_insumo, this.cantidad_minima)
      .subscribe(
        (response)=>{
          console.log(response);
          if(response.ok){
            console.log("Elemento agregado correctamente");
            this.alertService.success("Se guardo correctamente el insumo","Insumo Guardado");
            this.router.navigate(['/adminalmacen/proveedores/mostrar/insumos/'+this.idProveedor]);
          }else{
            console.log("Ha ocurrido un error");
          }          
        },
        (err)=>{
          this.alertService.error("Error al guardar insumo",err);
        }
      )
  }

}
