import { NgModule } from '@angular/core';
import { BrowserAnimationsModule } from '@angular/platform-browser/animations';
import { MatButtonModule, MatCheckboxModule, MatNativeDateModule } from '@angular/material';
import { MatToolbarModule } from '@angular/material/toolbar';
import { MatSidenavModule } from '@angular/material/sidenav';
import { MatIconModule } from '@angular/material/icon';
import { MatListModule } from '@angular/material/list';
import { MatFormFieldModule } from '@angular/material/form-field';
import { MatSelectModule } from '@angular/material/select';
import { MatInputModule } from '@angular/material/input';
import { MatDialogModule } from '@angular/material/dialog';
import { MatCardModule } from '@angular/material/card';
import { MatSliderModule } from '@angular/material/slider';
import { MatDatepickerModule } from '@angular/material/datepicker';
import { MatTableModule } from '@angular/material/table';
import { MatPaginatorModule } from '@angular/material/paginator'


@NgModule({
	imports: [
		BrowserAnimationsModule,
		MatButtonModule, 
		MatCheckboxModule, 
		MatNativeDateModule,
		MatToolbarModule, 
		MatSidenavModule, 
		MatIconModule, 
		MatListModule, 
		MatFormFieldModule,
		MatSelectModule,
		MatInputModule,
		MatDialogModule,
		MatDatepickerModule,
		MatTableModule,
		MatPaginatorModule,
		MatCardModule,
		MatSliderModule
	],
	exports: [
		BrowserAnimationsModule,
		MatButtonModule, 
		MatCheckboxModule, 
		MatNativeDateModule,
		MatToolbarModule, 
		MatSidenavModule, 
		MatIconModule, 
		MatListModule, 
		MatFormFieldModule,
		MatSelectModule,
		MatInputModule,
		MatDialogModule,
		MatDatepickerModule,
		MatTableModule,
		MatPaginatorModule,
		MatCardModule,
		MatSliderModule
	]
})
export class AppMaterialModule { }