import { Component, OnInit } from '@angular/core';
import { Router } from '@angular/router';
import { AlertService } from "../../../shared/services/alert.service";
import { SalidasService} from "../salidas.service";

@Component({
  selector: 'app-salidas-list',
  templateUrl: './salidas-list.component.html',
  styleUrls: ['./salidas-list.component.css']
})
export class SalidasListComponent implements OnInit {

  salidas: any[];

  constructor(private router:Router, 
              private salidasService:SalidasService,
              private alertService:AlertService
              ) { }

  ngOnInit() {
  	this.llenarDatos();
  }

  llenarDatos() {
  	this.salidasService.listar()
      .subscribe(
        (response)=>{
          console.log(response);
          if(response.ok){
            this.salidas = response.result;
          }else{
            console.log("No se pudo obtener la data");
          }
        }
      );
  }

  btnAgregar(){
    this.router.navigate(['/adminalmacen/salidas/agregar']);
  }  

  btnEliminar(idSalida:number) {
    this.salidasService.eliminar(idSalida)
      .subscribe(
        (response) => {
          console.log(response);
          if(response.ok){
            this.alertService.success(response.result,"Salidas");
            this.llenarDatos();
          }else{
            this.alertService.error(response.result,"Salidas");
          }
        },
        (error) => {
          this.alertService.error("No se pudo eliminar la salida","Salidas");
        }
      );
  }
}
