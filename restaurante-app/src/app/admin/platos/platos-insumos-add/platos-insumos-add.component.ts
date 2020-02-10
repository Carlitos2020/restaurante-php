import { Component, OnInit } from '@angular/core';

import { Router, ActivatedRoute } from '@angular/router';

import { PlatosService } from '../platos.service'

import { InsumosService } from "../../insumos/insumos.service";

import { AlertService } from "../../../shared/services/alert.service";


@Component({
  selector: 'app-platos-insumos-add',
  templateUrl: './platos-insumos-add.component.html',
  styleUrls: ['./platos-insumos-add.component.css'],
  providers:  [ PlatosService ]
})
export class PlatosInsumosAddComponent implements OnInit {
  idPlato:number=0;
  idInsumo:number=0;
  cantidad:number=0;
  insumos: any[];

  constructor(
    private router:Router,
    private route:ActivatedRoute,
    private platosService:PlatosService,
    private insumosService:InsumosService,
    private alertService:AlertService
    ) {}


  ngOnInit() {
      this. idPlato= parseInt( this.route.snapshot.paramMap.get("id")); 
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

  btnAgregarInsumoPlato(){
    this.platosService.registrarInsumoPlato(this.idPlato,this.idInsumo,this.cantidad)
      .subscribe(       

        (response)=>{
          console.log(response);
          if(response.ok){
            console.log("Elemento agregado correctamente");
            this.alertService.success("Guardado correctamente","Guardar Insumo del Plato");
            this.router.navigate(['/admin/platos/mostrar/insumos/'+this.idPlato]);         
        }
      },
        (err) => {          
          console.log("Ha ocurrido un error");
           this.alertService.error("Error al guardar Plator",err);
        } 
        )     
    }


  btnCancelar(){
    this.router.navigate(['/admin/platos/mostrar/insumos/'+this.idPlato]);
  }

}
