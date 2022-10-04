import { NgModule } from "@angular/core";
import { RouterModule, Routes } from "@angular/router";

const routes: Routes = [
  {
    path: "",
    pathMatch: "full",
    redirectTo: "home",
  },
  {
    path: "home",
    loadChildren: () => import("./pages/home/home.module").then((m) => m.HomeModule),
  },
  {
    path: "privacy-policy",
    loadChildren: () => import("./pages/privacy-policy/privacy-policy.module").then((m) => m.PrivacyPolicyModule),
  },
  {
    path: "terms-and-conditions",
    loadChildren: () => import("./pages/terms-and-conditions/terms-and-conditions.module").then((m) => m.TermsAndConditionsModule),
  },
  {
    path: "support",
    loadChildren: () => import("./pages/support/support.module").then((m) => m.SupportModule),
  },
];

@NgModule({
  imports: [
    RouterModule.forRoot(routes, {
      initialNavigation: "enabledBlocking",
    }),
  ],
  exports: [RouterModule],
})
export class AppRoutingModule { }
