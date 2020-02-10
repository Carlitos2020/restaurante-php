import { Component, OnInit } from '@angular/core';
import { Router } from '@angular/router';
import { AlertService } from "../../../shared/services/alert.service";
import { EntradasService} from "../entradas.service";

@Component({
  selector: 'app-entradas-add',
  templateUrl: './entradas-add.component.html',
  styleUrls: ['./entradas-add.component.css']
})
export class EntradasAddComponent implements OnInit {

  idInsumo:number = 0;
  cantidad:number = 0;
  descripcion:string = "";

  insumos:any[];

  constructor(private router:Router, 
              private entradasService:EntradasService,
              private alertService:AlertService
              ) { }

  ngOnInit() {
  	this.llenarDatos();
  }

  llenarDatos() {
  	this.entradasService.listarInsumos()
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

  btnAgregarEntrada(){
  	this.entradasService.registrar(this.idInsumo, this.cantidad, this.descripcion)
      .subscribe(
        (response)=>{
          if(response.ok){
            this.alertService.success("Se guardo correctamente la entrada","Entradas");
          }else{
            this.alertService.error(response.result, "Entradas");
          }
          this.router.navigate(['/adminalmacen/entradas']);
        },
        (err)=>{
          this.alertService.error("Error al guardar la entrada",err);
        }
      )
  }

  btnCancelar(){
  	this.router.navigate(['/adminalmacen/entradas']);
  }

}
