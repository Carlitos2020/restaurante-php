import { NgModule } from '@angular/core';
import { Routes, RouterModule } from '@angular/router';
import { TokenGuard } from './shared/guards/token.guard';

import { LoginComponent } from './security/login/login.component';
import { ContainerInsideAdminComponent } from './shared/components/container-inside-admin/container-inside-admin.component';
import { DashboardAdminComponent } from './admin/dashboard-admin/dashboard-admin.component';

import { Page404Component } from './shared/components/page404/page404.component';

import { PlatosListComponent } from './admin/platos/platos-list/platos-list.component';
import { PlatosEditComponent } from './admin/platos/platos-edit/platos-edit.component';
import { PlatosAddComponent } from './admin/platos/platos-add/platos-add.component';
import { PlatosInsumosComponent} from './admin/platos/platos-insumos-list/platos-insumos-list.component';
import { PlatosInsumosAddComponent} from './admin/platos/platos-insumos-add/platos-insumos-add.component';

import { InsumosListComponent } from './admin/insumos/insumos-list/insumos-list.component';
import { InsumosEditComponent } from './admin/insumos/insumos-edit/insumos-edit.component';
import { InsumosAddComponent } from './admin/insumos/insumos-add/insumos-add.component';
import { ProveedoresListComponent } from './admin/proveedores/proveedores-list/proveedores-list.component';
import { ProveedoresEditComponent } from './admin/proveedores/proveedores-edit/proveedores-edit.component';
import { ProveedoresAddComponent } from './admin/proveedores/proveedores-add/proveedores-add.component';
import { UsuariosListComponent } from './admin/usuarios/usuarios-list/usuarios-list.component';
import { UsuariosAddComponent } from './admin/usuarios/usuarios-add/usuarios-add.component';
import { UsuariosEditComponent } from './admin/usuarios/usuarios-edit/usuarios-edit.component';

import { ProveedoresInsumosAddComponent } from './admin/proveedores/proveedores-insumos-add/proveedores-insumos-add.component';
import { ProveedoresInsumosListComponent } from './admin/proveedores/proveedores-insumos-list/proveedores-insumos-list.component';
import { ProveedoresInsumosEditComponent } from './admin/proveedores/proveedores-insumos-edit/proveedores-insumos-edit.component';

import { DashboardAdminalmacenComponent } from './adminalmacen/dashboard-adminalmacen/dashboard-adminalmacen.component';
import { DashboardAdmincajaComponent } from './admincaja/dashboard-admincaja/dashboard-admincaja.component';
import { DashboardCocineroComponent } from './cocinero/dashboard-cocinero/dashboard-cocinero.component';
import { DashboardMozoComponent } from './mozo/dashboard-mozo/dashboard-mozo.component';
import { ContainerInsideAdminAlmacenComponent } from './shared/components/container-inside-admin-almacen/container-inside-admin-almacen.component';
import { ContainerInsideAdminCajaComponent } from './shared/components/container-inside-admin-caja/container-inside-admin-caja.component';
import { ContainerInsideMozoComponent } from './shared/components/container-inside-mozo/container-inside-mozo.component';
import { ContainerInsideCocineroComponent } from './shared/components/container-inside-cocinero/container-inside-cocinero.component';

import { MesasAddComponent } from './admin/mesas/mesas-add/mesas-add.component';

import { PedidosAddComponent } from './mozo/pedidos/pedidos-add/pedidos-add.component';
import { PedidosListComponent } from './mozo/pedidos/pedidos-list/pedidos-list.component';
import { PedidosEditComponent } from './mozo/pedidos/pedidos-edit/pedidos-edit.component';
import { EntradasAddComponent } from './adminalmacen/entradas/entradas-add/entradas-add.component';
import { EntradasListComponent } from './adminalmacen/entradas/entradas-list/entradas-list.component';
import { SalidasAddComponent } from './adminalmacen/salidas/salidas-add/salidas-add.component';
import { SalidasListComponent } from './adminalmacen/salidas/salidas-list/salidas-list.component';

import { InsumosListComponent as InsumosAlmacenListComponent } from './adminalmacen/insumos/insumos-list/insumos-list.component';
import { InsumosEditComponent as InsumosAlmacenEditComponent } from './adminalmacen/insumos/insumos-edit/insumos-edit.component';
import { InsumosAddComponent as InsumosAlmacenAddComponent } from './adminalmacen/insumos/insumos-add/insumos-add.component';
import { AlmacenListComponent } from './admin/almacen/almacen-list/almacen-list.component';
import { OperacionesAddComponent } from './admincaja/operaciones/operaciones-add/operaciones-add.component';
import { AlmacenEditComponent as AdminAlmacenEditComponent } from './admin/almacen/almacen-edit/almacen-edit.component';
import { EntradasEditComponent } from './adminalmacen/entradas/entradas-edit/entradas-edit.component';

import { ProveedoresListComponent as AlmaceneroProveedoresListComponent} from './adminalmacen/proveedores/proveedores-list/proveedores-list.component';
import { ProveedoresEditComponent as AlmaceneroProveedoresEditComponent} from './adminalmacen/proveedores/proveedores-edit/proveedores-edit.component';
import { ProveedoresAddComponent as AlmaceneroProveedoresAddComponent} from './adminalmacen/proveedores/proveedores-add/proveedores-add.component';
import { AlmacenListComponent as AlmaceneroAlmacenListComponent } from './adminalmacen/almacen/almacen-list/almacen-list.component';

import { PagosAddComponent } from './admincaja/pagos/pagos-add/pagos-add.component';
import { ProveedoresInsumosListComponent as AlmaceneroProveedoresInsumosListComponent} from './adminalmacen/proveedores/proveedores-insumos-list/proveedores-insumos-list.component';
import { ProveedoresInsumosEditComponent as AlmaceneroProveedoresInsumosEditComponent } from './adminalmacen/proveedores/proveedores-insumos-edit/proveedores-insumos-edit.component';
import { ProveedoresInsumosAddComponent as AlmaceneroProveedoresInsumosAddComponent} from './adminalmacen/proveedores/proveedores-insumos-add/proveedores-insumos-add.component';

import { ProveedoresAddComponent as ProveedoresAlmacenAddComponent} from './adminalmacen/proveedores/proveedores-add/proveedores-add.component';
import { ProveedoresListComponent as ProveedoresAlmacenListComponent} from './adminalmacen/proveedores/proveedores-list/proveedores-list.component';
import { ProveedoresEditComponent as ProveedoresAlmacenEditComponent} from './adminalmacen/proveedores/proveedores-edit/proveedores-edit.component';
import { ProveedoresInsumosAddComponent as ProveedoresInsumosAlmacenAddComponent } from './adminalmacen/proveedores/proveedores-insumos-add/proveedores-insumos-add.component';
import { ProveedoresInsumosListComponent as ProveedoresInsumosAlmacenListComponent} from './adminalmacen/proveedores/proveedores-insumos-list/proveedores-insumos-list.component';

import { AlmacenEditComponent as AlmaceneroAlmacenEditComponent } from './adminalmacen/almacen/almacen-edit/almacen-edit.component';

import { PedidosReadyComponent } from './mozo/pedidos/pedidos-ready/pedidos-ready.component';
//import {AlmaceneroAlmacenEditComponent} from './adminalmacen/almacen/almacen-edit/almacen-edit.component';

export const ROUTING_COMPONENTS=[
  LoginComponent,
  ContainerInsideAdminComponent,

  DashboardAdminComponent,
  PlatosListComponent,
  PlatosEditComponent,
  PlatosInsumosComponent,
  PlatosInsumosAddComponent,
  InsumosListComponent,
  InsumosEditComponent,
  InsumosAddComponent,
  ProveedoresListComponent,
  ProveedoresEditComponent,
  ProveedoresAddComponent,
  ProveedoresInsumosAddComponent,
  ProveedoresInsumosListComponent,
  ProveedoresInsumosEditComponent,
  PlatosAddComponent,
  UsuariosListComponent,
  UsuariosAddComponent,
  UsuariosEditComponent,
  MesasAddComponent,
  AlmacenListComponent,
  AdminAlmacenEditComponent,
  

  ContainerInsideAdminAlmacenComponent, 
  DashboardAdminalmacenComponent,
  InsumosAlmacenListComponent,
  InsumosAlmacenEditComponent,
  InsumosAlmacenAddComponent,
  EntradasAddComponent,
  EntradasListComponent,
  EntradasEditComponent,
  SalidasAddComponent,
  SalidasListComponent,
  ProveedoresAlmacenAddComponent,
  ProveedoresAlmacenListComponent,
  ProveedoresAlmacenEditComponent,
  ProveedoresInsumosAlmacenAddComponent,
  ProveedoresInsumosAlmacenListComponent,

  ContainerInsideAdminCajaComponent, 
  DashboardAdmincajaComponent,
  OperacionesAddComponent,  
  PagosAddComponent,

  ContainerInsideCocineroComponent,
  DashboardCocineroComponent,

  ContainerInsideMozoComponent, 
  DashboardMozoComponent,
  PedidosAddComponent,
  PedidosListComponent,
  PedidosEditComponent,
  PedidosReadyComponent,

  AlmaceneroProveedoresListComponent,
  AlmaceneroProveedoresEditComponent,
  AlmaceneroProveedoresAddComponent,

  AlmaceneroProveedoresInsumosListComponent,
  AlmaceneroProveedoresInsumosEditComponent,
  AlmaceneroProveedoresInsumosAddComponent,
  AlmaceneroAlmacenListComponent,
  AlmaceneroAlmacenEditComponent,

  Page404Component
];

const routes: Routes = [
  {
    path:'',
    component:LoginComponent,
    pathMatch: 'full'
  },
  {
    path:'admin',
    canActivate:[TokenGuard],
    component:ContainerInsideAdminComponent,
    children:[
      {
        path: 'dashboard',
        component: DashboardAdminComponent
      },
      {
        path: 'platos',
        component: PlatosListComponent
      },
      {
        path: 'platos/agregar',
        component: PlatosAddComponent
      },
      {
        path: 'platos/editar/:id',
        component: PlatosEditComponent
      },
      {
        path: 'platos/mostrar/insumos/:id',
        component: PlatosInsumosComponent 
      },
      {
        path: 'platos/agregar/insumos/:id',
        component: PlatosInsumosAddComponent
      },
      {
        path: 'insumos',
        component: InsumosListComponent
      },
      {
        path: 'insumos/editar/:id',
        component: InsumosEditComponent
      },
      {
        path: 'insumos/agregar',
        component: InsumosAddComponent
      },
      {
        path: 'proveedores',
        component: ProveedoresListComponent
      },
      {
        path: 'proveedores/editar/:id',
        component: ProveedoresEditComponent
      },
      {
        path: 'proveedores/agregar',
        component: ProveedoresAddComponent
      },
      {
        path: 'proveedores/agregar/insumo/:id',
        component: ProveedoresInsumosAddComponent
      },
      {
        path: 'proveedores/mostrar/insumos/:id',
        component: ProveedoresInsumosListComponent
      },
      {
        path: 'proveedores/insumo/editar/:id',
        component: InsumosEditComponent
      },
      {
        path: 'usuarios',
        component: UsuariosListComponent
      },
      {
        path: 'usuarios/agregar',
        component: UsuariosAddComponent
      },
      {
        path: 'usuarios/editar/:id',
        component: UsuariosEditComponent
      },
      {
        path: 'mesas',
        component: MesasAddComponent
      },
      {
        path: 'almacenControl',
        component: AlmacenListComponent
      },
      {
        path: 'almacen/ajustar/:id',
        component: AdminAlmacenEditComponent
      },
    ]
  },
  {
    path:'adminalmacen',
    canActivate:[TokenGuard],
    component:ContainerInsideAdminAlmacenComponent,
    children:[
      {
        path:'dashboard',
        component:DashboardAdminalmacenComponent
      },
      {
        path: 'insumos',
        component: InsumosAlmacenListComponent
      },
      {
        path: 'insumos/editar/:id',
        component: InsumosAlmacenEditComponent
      },
      {
        path: 'insumos/agregar',
        component: InsumosAlmacenAddComponent
      },
      {
        path: 'entradas',
        component: EntradasListComponent
      },
      {
        path: 'entradas/agregar',
        component: EntradasAddComponent
      },
      {
        path: 'salidas',
        component: SalidasListComponent
      },
      {
        path: 'salidas/agregar',
        component: SalidasAddComponent
      },
      {
        path: 'entrada/editar/:id',
        component: EntradasEditComponent
      },
      {
        path: 'proveedores',
        component: AlmaceneroProveedoresListComponent
      },
       {
        path: 'proveedores/agregar',
        component: AlmaceneroProveedoresAddComponent
      },
      {
        path: 'proveedores/editar/:id',
        component: AlmaceneroProveedoresEditComponent
      },
      {
        path: 'proveedores/mostrar/insumos/:id',
        component: AlmaceneroProveedoresInsumosListComponent
      },
      {
        path: 'proveedores/agregar/insumo/:id',
        component: AlmaceneroProveedoresInsumosAddComponent
      },
      {
        path: 'almacenControl',
        component: AlmaceneroAlmacenListComponent
      },
      {
        path: 'almacen/ajustar/:id',
        component: AlmaceneroAlmacenEditComponent
      },
    ]
  },
  {
    path:'admincaja',
    canActivate:[TokenGuard],
    component:ContainerInsideAdminCajaComponent,
    children:[
      {
        path:'dashboard',
        component:DashboardAdmincajaComponent
      },
      {
        path:'operaciones/agregar',
        component:OperacionesAddComponent
      },
      {
        path:'pagos/agregar',
        component:PagosAddComponent
      }
    ]
  },
  {
    path:'cocinero',
    canActivate:[TokenGuard],
    component:ContainerInsideCocineroComponent,
    children:[
      {
        path:'dashboard',
        component:DashboardCocineroComponent
      }
    ]
  },
  {
    path:'mozo',
    canActivate:[TokenGuard],
    component:ContainerInsideMozoComponent,
    children:[
      {
        path:'dashboard',
        component:DashboardMozoComponent
      },
      {
        path:'pedidos/agregar',
        component:PedidosAddComponent
      },
      {
        path:'pedidos/editar/:id',
        component:PedidosEditComponent
      },
      {
        path:'pedidos',
        component:PedidosListComponent
      }
    ]
  },
  { path: '**', component: Page404Component }

];

@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule],
  
})
export class AppRoutingModule { }
