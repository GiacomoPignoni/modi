import express, { json } from "express";
import { firebaseJwtAuth } from "./middlewares/firebase-jwt-auth";
import { isProd } from "./utils/env";
import { Logger } from "./utils/logger";
import admin from "firebase-admin";
import { notesRouter } from "./routes/notes-router";
import { userRouter } from "./routes/user-router";
import { shopRouter } from "./routes/shop-router";
import { config } from "./config";

function main(): void {
  Logger.info(`Running in ${isProd ? "PROD" : "DEV"}`, { id: "Server" });

  const serviceAccount = require((isProd) ? "../config/prod.firebase.json" : "../config/dev.firebase.json");
  admin.initializeApp({
    credential: admin.credential.cert(serviceAccount),
  });

  const app = express();
  const PORT = process.env.PORT || 3000;

  app.use(json());

  app.use("/api/notes", notesRouter);
  app.use("/api/user", userRouter);
  app.use("/api/shop", shopRouter);

  app.get("/api/hello-auth", firebaseJwtAuth, (req, res) => {
    res.send(`Hello, ${PORT}, ${process.env.NODE_ENV}, ${res.locals.authUser.id}, ${config.version}`);
  });

  app.get("/api/hello", (req, res) => {
    res.send(`Hello, ${PORT}, ${process.env.NODE_ENV}, ${config.version}`);
  });

  app.listen(PORT, () => {
    Logger.info(`Linstening on port ${PORT}`, { id: "Server" });
  });
}

main();
