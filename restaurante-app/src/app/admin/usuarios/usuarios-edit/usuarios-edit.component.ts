import { Component, OnInit } from '@angular/core';

import { Router,ActivatedRoute } from '@angular/router';

import { UsuariosService } from "../usuarios.service";

import { AlertService } from "../../../shared/services/alert.service";
import { RolesService} from "../../roles/roles.service";


@Component({
  selector: 'app-usuarios-edit',
  templateUrl: './usuarios-edit.component.html',
  styleUrls: ['./usuarios-edit.component.css']
})
export class UsuariosEditComponent implements OnInit {


	roles: any[];
	rol_id:number = 0;
	username:string = ""; 
	firstname:string = "";
	surname:string = ""; 

  idUsuario=0;

  constructor(
    private router:Router,
    private usuariosService:UsuariosService,
    private route:ActivatedRoute,
    private alertService:AlertService,
    private rolesService:RolesService 
  ) { }


  ngOnInit() {
    this.cargarDatos();
    this.llenarRoles();
  }

  cargarDatos()
  {
  	this.idUsuario = parseInt(this.route.snapshot.paramMap.get("id")); 
    this.usuariosService.mostrar(this.idUsuario)
      .subscribe(
        (res)=>{
          console.log(res);
          if(res.ok && res.result!=null)
          {
            let data = res.result;
            this.rol_id=data.rol_id;
            this.firstname = data.firstname;
            this.surname = data.surname;
            this.username = data.username;
          }
        }
      )
  }

  llenarRoles()
  {
    this.rolesService.listar()
    .subscribe(
      (response)=>{
        console.log(response);
        if(response.ok){
          this.roles = response.result;
        }else{
          console.log("No se pudo obtener la data");
        }
      }
    );
  }

  btnActualizarDatos()
  {
    this.usuariosService.actualizar(this.idUsuario,this.rol_id,this.username,this.firstname,this.surname)
      .subscribe(
        (res)=>{
          console.log(res)
          this.alertService.success("Se actualizo correctamente al usuario","Usuarios");
        }
      )
  }


	btnCancelar(){
    this.router.navigate(['/admin/usuarios']);
  }
}
