import { Component, OnInit } from '@angular/core';


import { Router } from '@angular/router';

@Component({
  selector: 'app-container-inside-admin',
  templateUrl: './container-inside-admin.component.html',
  styleUrls: ['./container-inside-admin.component.css']
})
export class ContainerInsideAdminComponent implements OnInit {


  titulo="Dashboard";

  constructor(private router:Router) { }

  ngOnInit() {
    //this.router.navigate(['/admin/dashboard']);
  }

  redirectDashboard()
  {
    this.efectos(1);
    this.router.navigate(['/admin/dashboard']);
    this.titulo="Dashboard";
  }

  redirectPlatos()
  {
    this.efectos(3);
    this.router.navigate(['/admin/platos']);
    this.titulo="Platos";
  }

  redirectInsumos()
  {
    this.efectos(4);
    this.router.navigate(['/admin/insumos']);
    this.titulo="Insumos";
  }

  redirectProveedores()
  {
    this.efectos(2);
    this.router.navigate(['/admin/proveedores']);
    this.titulo="Proveedores";
  }

  redirectUsuarios()
  {
    this.efectos(5);
    this.router.navigate(['/admin/usuarios']);
    this.titulo="Usuarios";
  }
  redirectMesas()
  {
    this.efectos(6);
    this.router.navigate(['/admin/mesas']);
    this.titulo="Mesas";
  }

  redirectAlmacenControl()
  {
    this.efectos(7);
    this.router.navigate(['/admin/almacenControl']);
    this.titulo="almacenControl";
  }

  // EFECTOS NAV

  efectos(id:number)
  {
    let linkDasboard = document.getElementById('link-dashboard');
    let linkProveedores = document.getElementById('link-proveedores');
    let linkPlatos = document.getElementById('link-platos');
    let linkInsumos = document.getElementById('link-insumos');
    let linkUsuarios = document.getElementById('link-usuarios');
    let linkMesas = document.getElementById('link-mesas');
    let linkAlmacenControl = document.getElementById('link-almacenControl');

    linkDasboard.classList.remove('active');
    linkProveedores.classList.remove('active');
    linkPlatos.classList.remove('active');
    linkInsumos.classList.remove('active');
    linkUsuarios.classList.remove('active');
    linkMesas.classList.remove('active');
    linkAlmacenControl.classList.remove('active');

    switch(id){
      case 1:{
        linkDasboard.classList.add('active');
      }break;
      case 2:{
        linkProveedores.classList.add('active');
      }break;
      case 3:{
        linkPlatos.classList.add('active');
      }break;
      case 4:{
        linkInsumos.classList.add('active');
      }break;
      case 5:{
        linkUsuarios.classList.add('active');
      }break;
      case 6:{
        linkMesas.classList.add('active');
      }break;
      case 7:{
        linkAlmacenControl.classList.add('active');
      }break;
    }
  }

}
