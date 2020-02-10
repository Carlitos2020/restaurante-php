import { Component, OnInit } from '@angular/core';

import { Router, ActivatedRoute } from '@angular/router';

import { PlatosService } from '../platos.service';

import { AlertService } from "../../../shared/services/alert.service";


@Component({
  selector: 'app-platos-insumos-list',
  templateUrl: './platos-insumos-list.component.html',
  styleUrls: ['./platos-insumos-list.component.css'],
  providers:  [ PlatosService ]
})

export class PlatosInsumosComponent implements OnInit {
  idPlato:number=0;
  idInsumo:number=0;
  insumos: any[];

  constructor(
    private router:Router,
    private route:ActivatedRoute,
    private platosService:PlatosService,
     private alertService:AlertService) {
    
  }

 ngOnInit() {    
      this. idPlato= parseInt( this.route.snapshot.paramMap.get("id")); 
      this.platosService.listarInsumosPlatos(this.idPlato)
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

  btnEliminar(idInsumo:number)
  {
      this.platosService.eliminarInsumo(this.idPlato,idInsumo)
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


  btnAgregar()
  {

      console.log("Navegando a agregar un nuevo plato: ");
      this.router.navigate(['/admin/platos/agregar/insumos/'+this.idPlato]);
  }

  btnRetroceder(){
    this.router.navigate(['/admin/platos/']);
  }
  

}