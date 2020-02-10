import { Component, OnInit } from '@angular/core';
import { Router } from '@angular/router';
import { AlertService } from "../../../shared/services/alert.service";
import { UsuariosService} from "../usuarios.service";
import { RolesService} from "../../roles/roles.service";

@Component({
  selector: 'app-usuarios-list',
  templateUrl: './usuarios-list.component.html',
  styleUrls: ['./usuarios-list.component.css']
})
export class UsuariosListComponent implements OnInit {
  
  usuarios: any[];
  roles: any[];

  constructor(private router:Router, 
              private usuariosService:UsuariosService, 
              private rolesService:RolesService, 
              private alertService:AlertService
              ) { }

  ngOnInit() {
  	this.llenarDatos();
  }

  llenarDatos()
  {
  	this.usuariosService.listar()
      .subscribe(
        (response)=>{
          console.log(response);
          if(response.ok){
            this.usuarios = response.result;
          }else{
            console.log("No se pudo obtener la data");
          }
        }
      );

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

  btnEditar(id: number)
  {
      console.log("Navegando a editar el usuario: "+id);

      this.router.navigate(['/admin/usuarios/editar/'+id]);
  }

  btnAgregar()
  {
      console.log("Navegando a agregar un nuevo usuario: ");

      this.router.navigate(['/admin/usuarios/agregar']);
  }

  btnCambiarEstado(usuario,activado:boolean)
  {
      if(activado)
      {
        console.log("desactiva cuenta ");
        this.usuariosService.desactivar(usuario.id)
          .subscribe(
            (res)=>{
              console.log("activa cuenta ");
              console.log(res)
              usuario.state=!usuario.state;
            }
          )
      }else
      {
        this.usuariosService.activar(usuario.id)
          .subscribe(
            (res)=>{
              console.log("activa cuenta ");
              console.log(res)
              usuario.state=!usuario.state;
            }
          )
      }
  }

  btnEliminar(id:number)
  {
  	this.usuariosService.eliminar(id)
    .subscribe(
      (response)=>{
        if(response.ok)
        {
          this.alertService.success("Usuario eliminado correctamente","Eliminar");
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
    )
  }


}
