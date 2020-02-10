import { Component, OnInit } from '@angular/core';

import { Router } from '@angular/router';


@Component({
  selector: 'app-container-inside-cocinero',
  templateUrl: './container-inside-cocinero.component.html',
  styleUrls: ['./container-inside-cocinero.component.css']
})
export class ContainerInsideCocineroComponent implements OnInit {

  titulo="Dashboard";

  constructor(
    private router:Router
  ) { }

  ngOnInit() {
  }
  redirectDashboard()
  {
    this.efectos(1);
    this.router.navigate(['/cocinero/dashboard']);
    this.titulo="Dashboard";
  }

    // EFECTOS NAV

    efectos(id:number)
    {
      let linkDasboard = document.getElementById('link-dashboard'); 
  
      linkDasboard.classList.remove('active'); 
  
      switch(id){
        case 1:{
          linkDasboard.classList.add('active');
        }break;
      }
    }  
}
