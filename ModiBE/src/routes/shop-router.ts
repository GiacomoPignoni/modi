import { Router } from "express";
import { ShopController } from "../controllers/shop-controller";
import { firebaseJwtAuth } from "../middlewares/firebase-jwt-auth";
import { action } from "./base-action";

export const shopRouter = Router();

shopRouter.get("/prices", firebaseJwtAuth, async (req, res) => {
  action(res, async () => {
    const result = await ShopController.getPrices();
    res.send(result);
  });
});

shopRouter.get("/buy-random-note", firebaseJwtAuth, async (req, res) => {
  action(res, async () => {
    const result = await ShopController.unlockRandomNote(res.locals.authUser);
    res.send(result);
  });
});

shopRouter.get("/buy-random-month-note", firebaseJwtAuth, async (req, res) => {
  action(res, async () => {
    const result = await ShopController.unlockRandomMonthNote(parseInt(req.query.month as string), res.locals.authUser);
    res.send(result);
  });
});

shopRouter.get("/buy-note", firebaseJwtAuth, async (req, res) => {
  action(res, async () => {
    const result = await ShopController.unlockNote(req.query.date as string, res.locals.authUser);
    res.send(result);
  });
});
