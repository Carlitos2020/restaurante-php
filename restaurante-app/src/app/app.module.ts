import { BrowserModule } from '@angular/platform-browser';
import { NgModule } from '@angular/core';
import { FormsModule,ReactiveFormsModule } from '@angular/forms';
import { HttpClientModule } from '@angular/common/http';
import { DatePipe } from '@angular/common';
import { MAT_DATE_LOCALE } from '@angular/material/core';

import { AppRoutingModule, ROUTING_COMPONENTS } from './app-routing.module';
import { AppMaterialModule } from './app-material.module';


import { DataTablesModule } from 'angular-datatables';
import { NgSelectizeModule } from 'ng-selectize';

//Graficos
import { ChartsModule } from 'ng2-charts';


// token
import { TokenGuard } from './shared/guards/token.guard';

// Servicios
import { AlertService } from './shared/services/alert.service';
import { HeaderService } from './shared/services/header.service';
import { TokenService } from './shared/services/token.service';

import { SecurityService } from "./security/security.service";
import { ProveedoresService } from "./admin/proveedores/proveedores.service";
import  { InsumosService } from "./admin/insumos/insumos.service";
import { UsuariosService} from "./admin/usuarios/usuarios.service";
import { RolesService} from "./admin/roles/roles.service";

import  { MesasServiceAdmin } from "./admin/mesas/mesas.service";
import  { AlmacenControlService } from "./admin/almacen/almacenControl.service";

import { MesasService } from "./mozo/mesas/mesas.service";
import { PedidosService } from "./mozo/pedidos/pedidos.service";
import { PlatosService } from "./mozo/platos/platos.service";
import { EntradasService } from "./adminalmacen/entradas/entradas.service";
import { InsumosService as InsumosAlmacenService } from "./adminalmacen/insumos/insumos.service";
import { CajaService } from "./admincaja/caja.service";
import { MesasService as MesasCajaService } from "./admincaja/mesas/mesas.service";
import { DashboardService} from "./cocinero/dashboard-cocinero/dashboard-cocinero.service";
import { DashboardService as AlmaceneroDashboardService} from "./adminalmacen/dashboard-adminalmacen/dashboard.service";


import { DashboardService as AdminDashboardService} from "./admin/dashboard-admin/dashboard.service";

import { SalidasService} from "./adminalmacen/salidas/salidas.service";
import { ProveedoresService as ProveedoresAlmacenService } from "./adminalmacen/proveedores/proveedores.service";

import { AngularDateTimePickerModule } from 'angular2-datetimepicker';

import { AppComponent } from './app.component';

import { MatDialogModule } from '@angular/material';
import { BrowserAnimationsModule } from '@angular/platform-browser/animations';

import  { AlmacenControlService as AlmaceneroControlService} from "./adminalmacen/almacen/almacenControl.service";
//import { HttpModule } from '@angular/http';


@NgModule({
  declarations: [
    AppComponent,
    ROUTING_COMPONENTS
  ],
  imports: [
    BrowserModule,
    FormsModule,
    HttpClientModule,
    BrowserAnimationsModule,
    AppRoutingModule,
    AppMaterialModule,
    DataTablesModule,
    AngularDateTimePickerModule,
    MatDialogModule,
    ChartsModule,
    ReactiveFormsModule

  ],
  providers: [
    DatePipe,
    { provide: MAT_DATE_LOCALE, useValue: 'en-GB' },

  	TokenGuard,

    AlertService,
    HeaderService,
    TokenService,

    SecurityService,
    ProveedoresService,
    InsumosService,
    UsuariosService,
    RolesService,
    AdminDashboardService,

    MesasServiceAdmin,

    AlmacenControlService,

    //SERVICIOS DEL MOZO
    MesasService,
    PedidosService,
    PlatosService,

    //SERVICIOS DEL ALMACENERO
    AlmaceneroDashboardService,
    InsumosAlmacenService,
    EntradasService,  
    SalidasService,
    ProveedoresAlmacenService,
    AlmaceneroControlService,

    //SERVICIOS DEL COCINERO
    DashboardService,

    //SERVICIOS DEL CAJERO
    CajaService,
    MesasCajaService

  ],
  bootstrap: [AppComponent]
})
export class AppModule { }
