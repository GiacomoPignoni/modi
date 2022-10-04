import admin from "firebase-admin";

export class AuthUser {
  public id: string;
  public email?: string | undefined;

  constructor(data: admin.auth.DecodedIdToken) {
    this.id = data.uid;
    this.email = data.email;
  }
}
