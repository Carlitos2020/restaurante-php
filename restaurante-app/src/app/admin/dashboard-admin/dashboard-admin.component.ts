import { Component, OnInit } from '@angular/core';
import { MatDatepickerModule } from '@angular/material/datepicker';
import { Router } from '@angular/router';
import { DatePipe } from '@angular/common';
import { AlertService } from "../../shared/services/alert.service";
import { DashboardService } from "../dashboard-admin/dashboard.service";
import { ChartDataSets, ChartOptions, Chart } from 'chart.js';
import { Color, BaseChartDirective, Label } from 'ng2-charts';
import {FormControl} from '@angular/forms';
import { ChartsModule } from 'ng2-charts';

//import 'rxjs/operators';
//import { Map } from 'rxjs/operators';
//import * as pluginAnnotations from 'chartjs-plugin-annotation';

@Component({
  selector: 'app-dashboard-admin',
  templateUrl: './dashboard-admin.component.html',
  styleUrls: ['./dashboard-admin.component.css']

})
export class DashboardAdminComponent implements OnInit {

  FECHA_INICIO1:Date=null;
  FECHA_FIN1:Date=null;
  FECHA_INICIO2:Date=null;
  FECHA_FIN2:Date=null;
  reportesv: any[];
  reportesp: any[];



  serializedDate = new FormControl((new Date()).toISOString());
  existencias:any[];
	selectedDate:String;
	datos:any[][];
  fecha:Date;
  date1 = new Date();
  horas:any[];
  cantidades:any[];
  FECHA_INICIO3:Date=null;
  FECHA_FIN3:Date=null;
  reportesCaja: any[];


  title = 'Ng7ChartJs By DotNet Techy';
  LineChart;
  BarChart;
  PieChart;


  SeGeneroReporteVentas:Boolean=false;
  SeGeneroReportePlatos:Boolean=false;
  titleVentas = 'Gráfico de Lineas de las Ventas';
  titlePlato = 'Gráfico de Barras de las Ganancias por Plato';


  constructor(
  	private router:Router, 
  	private alertService:AlertService, 
    private dashboardService:DashboardService,
		private datePipe: DatePipe
    ) { 
  	
  }

  ngOnInit() {
    this.llenarDatos();
    
    // Line chart:
    this.LineChart = new Chart('lineChart', {
  type: 'line',
  data: {
  labels: ["Jan", "Feb", "March", "April", "May", "June","July","Aug","Sep","Oct","Nov","Dec"],
  datasets: [{
      label: 'Number of Items Sold in Months',
      data: [9,7 , 3, 5, 2, 10,15,16,19,3,1,9],
      fill:false,
      lineTension:0.2,
      borderColor:"red",
      borderWidth: 1
  }]
  }, 
    options: {
    title:{
        text:"Line Chart",
        display:true
    },
    scales: {
        yAxes: [{
            ticks: {
                beginAtZero:true
            }
        }]
    }
    }
    });

    // Bar chart:
    this.BarChart = new Chart('barChart', {
      type: 'bar',
    data: {
    labels: ["Red", "Blue", "Yellow", "Green", "Purple", "Orange"],
    datasets: [{
        label: '# of Votes',
        data: [9,7 , 3, 5, 2, 10],
        backgroundColor: [
            'rgba(255, 99, 132, 0.2)',
            'rgba(54, 162, 235, 0.2)',
            'rgba(255, 206, 86, 0.2)',
            'rgba(75, 192, 192, 0.2)',
            'rgba(153, 102, 255, 0.2)',
            'rgba(255, 159, 64, 0.2)'
        ],
        borderColor: [
            'rgba(255,99,132,1)',
            'rgba(54, 162, 235, 1)',
            'rgba(255, 206, 86, 1)',
            'rgba(75, 192, 192, 1)',
            'rgba(153, 102, 255, 1)',
            'rgba(255, 159, 64, 1)'
        ],
        borderWidth: 1
    }]
    }, 
    options: {
    title:{
        text:"Bar Chart",
        display:true
    },
    scales: {
        yAxes: [{
            ticks: {
                beginAtZero:true
            }
        }]
    }
    }
    });

    // pie chart:
    this.PieChart = new Chart('pieChart', {
      type: 'pie',
    data: {
    labels: ["Red", "Blue", "Yellow", "Green", "Purple", "Orange"],
    datasets: [{
        label: '# of Votes',
        data: [9,7 , 3, 5, 2, 10],
        backgroundColor: [
            'rgba(255, 99, 132, 0.2)',
            'rgba(54, 162, 235, 0.2)',
            'rgba(255, 206, 86, 0.2)',
            'rgba(75, 192, 192, 0.2)',
            'rgba(153, 102, 255, 0.2)',
            'rgba(255, 159, 64, 0.2)'
        ],
        borderColor: [
            'rgba(255,99,132,1)',
            'rgba(54, 162, 235, 1)',
            'rgba(255, 206, 86, 1)',
            'rgba(75, 192, 192, 1)',
            'rgba(153, 102, 255, 1)',
            'rgba(255, 159, 64, 1)'
        ],
        borderWidth: 1
    }]
    }, 
    options: {
    title:{
        text:"Bar Chart",
        display:true
    },
    scales: {
        yAxes: [{
            ticks: {
                beginAtZero:true
            }
        }]
    }
    }
    });


}

  llenarDatos(){
    
    this.dashboardService.listar()
      .subscribe(
        (response)=>{
          console.log(response);
          if(response.ok){
            this.existencias = response.result;
          }else{
            console.log("No se pudo obtener la data");
          }
        }
    );
  }




  btnAceptar(fecha: String){


    this.selectedDate = this.datePipe.transform(this.selectedDate, 'yyyy-MM-dd ');
    alert(this.selectedDate);

  }


  btnGenerarReporteVentas(){

    this.dashboardService.reporteventas(this.FECHA_INICIO1,this.FECHA_FIN1)
      .subscribe(

        (response)=>{
          console.log(response);
          if(response.ok){
             this.SeGeneroReporteVentas=true;
            console.log("REPORTE GENERADO CORRECTAMENTE "+this.FECHA_INICIO1+"  "+this.FECHA_FIN1);
            this.reportesv = response.result;
            this.generarGraficoVentas();
          }
        },
        (err) => {          
          console.log("ERROR AL GENERAR REPORTE"+this.FECHA_INICIO1+this.FECHA_FIN1);
        }        
      )
  }

  btnGenerarReportePlatos(){

    this.dashboardService.reporteplatos(this.FECHA_INICIO2,this.FECHA_FIN2)
      .subscribe(       

        (response)=>{
          console.log(response);
          if(response.ok){
            this.SeGeneroReportePlatos=true;
            console.log("REPORTE GENERADO CORRECTAMENTE "+this.FECHA_INICIO2+"  "+this.FECHA_FIN2);
            this.reportesp = response.result; 
            console.log(this.reportesp[0].nombre_plato);
            this.generarGraficoComidas();           
          }
        },
        (err) => {          
          console.log("ERROR AL GENERAR REPORTE"+this.FECHA_INICIO2+this.FECHA_FIN2);
        }        
      )

  }

  btnCierreCaja(){

    this.dashboardService.reportecaja(this.FECHA_INICIO3,this.FECHA_FIN3)
      .subscribe(       

        (response)=>{
          console.log(response);
          if(response.ok){
            console.log("REPORTE GENERADO CORRECTAMENTE "+this.FECHA_INICIO3+"  "+this.FECHA_FIN3);
            this.reportesCaja = response.result;
          }
        },
        (err) => {          
          console.log("ERROR AL GENERAR REPORTE"+this.FECHA_INICIO3+this.FECHA_FIN3);
        }        
      )
  }

  generarGraficoVentas(){

    
    this.LineChart = new Chart('lineChartVentas', {
      type: 'line',
      data: {
      labels:[],
      datasets: [{
        label: 'Ventas por día',
        data: [],
        fill:false,
        lineTension:0.2,
        borderColor:"red",
        borderWidth: 1
       }]
    }, 
    options: {
    title:{
        text:"Line Chart",
        display:true
    },
    scales: {
        yAxes: [{
            ticks: {
                beginAtZero:true
            }
        }]
    }
    }
    });

  for (var i = 0; i < this.reportesv.length; ++i) {
       this.LineChart.data.labels.push(this.reportesv[i].fecha);
       this.LineChart.data.datasets[0].data.push(this.reportesv[i].monto_total);
    }
   
    this.LineChart.update();   
  }




   generarGraficoComidas(){  


    this.BarChart = new Chart('barChartPlatos', {
    type: 'bar',
    data: {
    labels: [],
    datasets: [{
        label: 'Platos',
        data: [],
        backgroundColor:'rgba(255, 99, 132, 0.2)',
      
        borderColor: 'rgba(255,99,132,1)',
            
       
        borderWidth: 1
    }]
    }, 
    options: {
    title:{
        text:"Bar Chart",
        display:true
    },
    scales: {
        yAxes: [{
            ticks: {
                beginAtZero:true
            }
        }]
    }
    }
    });

  for (var i = 0; i < this.reportesp.length; ++i) {
       this.BarChart.data.labels.push(this.reportesp[i].nombre_plato);
       this.BarChart.data.datasets[0].data.push(this.reportesp[i].total);
    }
   
    this.BarChart.update();   
  }
 
    
}
