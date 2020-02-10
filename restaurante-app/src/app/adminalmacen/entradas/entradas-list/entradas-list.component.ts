import { Component, OnInit } from '@angular/core';
import { Router } from '@angular/router';
import { AlertService } from "../../../shared/services/alert.service";
import { EntradasService} from "../entradas.service";

@Component({
  selector: 'app-entradas-list',
  templateUrl: './entradas-list.component.html',
  styleUrls: ['./entradas-list.component.css']
})
export class EntradasListComponent implements OnInit {

  entradas: any[];

  constructor(private router:Router, 
              private entradasService:EntradasService,
              private alertService:AlertService
              ) { }

  ngOnInit() {
  	this.llenarDatos();
  }

  llenarDatos() {
  	this.entradasService.listar()
      .subscribe(
        (response)=>{
          console.log(response);
          if(response.ok){
            this.entradas = response.result;
          }else{
            console.log("No se pudo obtener la data");
          }
        }
    );
  }

  btnAgregar(){
    this.router.navigate(['/adminalmacen/entradas/agregar']);
  }

  btnEditar(id:number){
    console.log("Navegando a editar entrada: "+id);

    this.router.navigate(['/adminalmacen/entrada/editar/'+id]);
  }

  btnEliminar(id:number)
  {
    this.entradasService.eliminar(id)
    .subscribe(
      (response)=>{
        if(response.ok)
        {
          this.alertService.success("Eliminado correctamente","Eliminar");
          console.log("Se elimino correctamente");
          this.llenarDatos();
        }else{
          console.log("Ocurrio un error");
          this.alertService.error("Error al eliminar entrada",null);  
        }
      },
      (err) => {
        console.log("Ocurrio un error");
        this.alertService.error("Error al eliminar entrada",err);
      }
    )
  }
}
