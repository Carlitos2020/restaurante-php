import { Component, OnInit } from '@angular/core';
import { Router } from '@angular/router';
import { AlertService } from "../../../shared/services/alert.service";
import { UsuariosService} from "../usuarios.service";
import { RolesService} from "../../roles/roles.service";

@Component({
  selector: 'app-usuarios-add',
  templateUrl: './usuarios-add.component.html',
  styleUrls: ['./usuarios-add.component.css']
})
export class UsuariosAddComponent implements OnInit {

	roles: any[];
	rol_id:number = 0;
	username:string = ""; 
	password:string = "";
	firstname:string = "";
	surname:string = ""; 
	email:string = "";

	constructor(private router:Router,
              private usuariosService:UsuariosService, 
              private rolesService:RolesService, 
              private alertService:AlertService) { }

  	ngOnInit() {
      this.llenarDatos();
  	}

    llenarDatos()
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

  	btnAgregarUsuario(){
      this.usuariosService.registrar(this.rol_id, this.username, this.password,
            this.firstname, this.surname, this.email)
        .subscribe(
          (response)=>{
            console.log(response);
            if(response.ok){
              console.log("Usuario agregado");

              this.alertService.success("Se registró correctamente al usuario","Usuarios");
            }else{
              this.alertService.error(response.result,null);
              console.log("No se pudo registra al usuario");
            }
            this.router.navigate(['/admin/usuarios']);  
          },
    		  (err)=>{
            this.alertService.error("Error al registrar al usuario",err);
          });
  		
  	}

	btnCancelar(){
	  	this.router.navigate(['/admin/usuarios']);
	}
}
