import { Component, OnInit } from '@angular/core';

import { Router } from '@angular/router';

@Component({
  selector: 'app-container-inside-admin-caja',
  templateUrl: './container-inside-admin-caja.component.html',
  styleUrls: ['./container-inside-admin-caja.component.css']
})
export class ContainerInsideAdminCajaComponent implements OnInit {


  titulo="Dashboard";

  constructor(
    private router:Router
  ) { }

  ngOnInit() {
  }
  
  redirectDashboard()
  {
    this.efectos(1);
    this.router.navigate(['/admincaja/dashboard']);
    this.titulo="Dashboard";
  }

  redirectRegistrarOperacion()
  {
    this.efectos(2);
    this.router.navigate(['/admincaja/operaciones/agregar']);
    this.titulo="Operación";
  }

  redirectRegistrarPago()
  {
    this.efectos(3);
    this.router.navigate(['/admincaja/pagos/agregar']);
    this.titulo="Pago";
  }

    // EFECTOS NAV

    efectos(id:number)
    {
      let linkDasboard = document.getElementById('link-dashboard'); 
      let linkRegistrarOperacion = document.getElementById('link-registrar-operacion'); 
      let linkRegistrarPago = document.getElementById('link-registrar-pago'); 
  
      linkDasboard.classList.remove('active'); 
      linkRegistrarOperacion.classList.remove('active'); 
      linkRegistrarPago.classList.remove('active'); 
  
      switch(id){
        case 1:{
          linkDasboard.classList.add('active');
        }break;
        case 2:{
          linkRegistrarOperacion.classList.add('active');
        }break;
        case 3:{
          linkRegistrarPago.classList.add('active');
        }break;
      }
    }  
}
