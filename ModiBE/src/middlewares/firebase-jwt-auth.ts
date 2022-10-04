import { NextFunction, Request, Response } from "express";
import admin from "firebase-admin";
import { AuthUser } from "../models/auth-user";
import { Logger } from "../utils/logger";
import { ResCodes } from "../utils/res-code";

export const firebaseJwtAuth = async function(req: Request, res: Response, next: NextFunction): Promise<void> {
  try {
    const token = req.header("Authorization")?.split(" ")[1];

    if (token) {
      const decoded = await admin.auth().verifyIdToken(token);
      const authUser = new AuthUser(decoded);
      res.locals.authUser = authUser;
      next();
    } else {
      Logger.error("Request without token");
      res.sendStatus(ResCodes.unauthorized);
    }
  } catch (error: any) {
    Logger.error(error.toString());

    if (error.errorInfo?.code === "auth/id-token-expired") {
      res.status(ResCodes.sessioneExpired).send("Session expired");
    } else {
      res.sendStatus(ResCodes.unauthorized);
    }
  }
};
