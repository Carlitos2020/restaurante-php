import { Component, OnInit } from '@angular/core';

import { Router, ActivatedRoute } from '@angular/router';

import { ProveedoresService } from '../proveedores.service';

import { AlertService } from "../../../shared/services/alert.service";

@Component({
  selector: 'app-proveedores-insumos-list',
  templateUrl: './proveedores-insumos-list.component.html',
  styleUrls: ['./proveedores-insumos-list.component.css'],
  providers:  [ ProveedoresService ]
})
export class ProveedoresInsumosListComponent implements OnInit {
	
  idProveedor:number=0;
  insumos: any[];

  constructor(
  	private router:Router,
    private route:ActivatedRoute,
    private proveedoresService:ProveedoresService,
    private alertService:AlertService) {

  }

  ngOnInit() {
    this.llenarDatos();
  }

  llenarDatos() {
  	  this. idProveedor= parseInt( this.route.snapshot.paramMap.get("id")); 
      this.proveedoresService.listarInsumosProveedor(this.idProveedor)
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

  btnAgregar()
  {
      console.log("Navegando a agregar un nuevo insumo del proveedor: ");
      this.router.navigate(['/adminalmacen/proveedores/agregar/insumo/'+this.idProveedor]);
  }

  btnRetroceder(){
    this.router.navigate(['/adminalmacen/proveedores/']);
  }

  btnEditarInsumo(id:number){
    
    console.log("Navegando a editar el insumo: "+id);

    this.router.navigate(['/adminalmacen/insumos/editar/'+id]);
    
  }

  btnEliminarInsumo(id: number){
    
    this.proveedoresService.eliminarInsumo(id)
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
    );
  }
}
