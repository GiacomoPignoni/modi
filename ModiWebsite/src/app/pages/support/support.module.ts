import { NgModule } from "@angular/core";
import { CommonModule } from "@angular/common";
import { SupportComponent } from "./support.component";
import { RouterModule, Routes } from "@angular/router";

const routes: Routes = [
  {
    path: "",
    component: SupportComponent,
  },
];

@NgModule({
  declarations: [
    SupportComponent,
  ],
  imports: [
    CommonModule,
    RouterModule.forChild(routes),
  ],
})
export class SupportModule { }
