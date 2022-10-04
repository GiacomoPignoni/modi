import { Router } from "express";
import { firebaseJwtAuth } from "../middlewares/firebase-jwt-auth";
import { UserController } from "../controllers/user-controller";
import { CheckNicknameRes, GetPartnerRequestsRes, GetUserRes } from "../models/res/user-reses";
import { action } from "./base-action";
import { BaseRes } from "../models/res/base-res";

export const userRouter = Router();

userRouter.post("/check-nickname", async (req, res) => {
  action(res, async () => {
    const available = await UserController.checkNickname(req.body);
    res.send(new CheckNicknameRes(available));
  });
});

userRouter.post("/register", firebaseJwtAuth, async (req, res) => {
  action(res, async () => {
    await UserController.registerNew(req.body, res.locals.authUser);
    res.send(new BaseRes("Done"));
  });
});

userRouter.get("/profile", firebaseJwtAuth, async (req, res) => {
  action(res, async () => {
    const user = await UserController.get(res.locals.authUser);
    res.send(new GetUserRes(user));
  });
});

userRouter.put("/update-nickname", firebaseJwtAuth, async (req, res) => {
  action(res, async () => {
    await UserController.updateNickname(req.body, res.locals.authUser);
    res.send(new BaseRes("Done"));
  });
});

userRouter.get("/get-partner-requests", firebaseJwtAuth, async (req, res) => {
  action(res, async () => {
    const requests = await UserController.getPartnerRequests(res.locals.authUser);
    res.send(new GetPartnerRequestsRes(requests));
  });
});

userRouter.post("/send-partner-request", firebaseJwtAuth, async (req, res) => {
  action(res, async () => {
    await UserController.sendPartnerRequest(req.body, res.locals.authUser);
    res.send(new BaseRes("Done"));
  });
});

userRouter.post("/accept-partner-request", firebaseJwtAuth, async (req, res) => {
  action(res, async () => {
    await UserController.acceptPartnerRequest(req.body, res.locals.authUser);
    res.send(new BaseRes("Done"));
  });
});

userRouter.post("/reject-partner-request", firebaseJwtAuth, async (req, res) => {
  action(res, async () => {
    await UserController.rejectPartnerRequest(req.body, res.locals.authUser);
    res.send(new BaseRes("Done"));
  });
});

userRouter.delete("/remove-partner", firebaseJwtAuth, async (req, res) => {
  action(res, async () => {
    await UserController.removePartner(res.locals.authUser);
    res.send(new BaseRes("Done"));
  });
});

userRouter.get("/send-partner-notification", firebaseJwtAuth, async (req, res) => {
  action(res, async () => {
    await UserController.sendPartnerNotificationReminder(res.locals.authUser);
    res.send(new BaseRes("Done"));
  });
});

userRouter.post("/register-messaging-token", firebaseJwtAuth, async (req, res) => {
  action(res, async () => {
    await UserController.registerMessagingToken(req.body, res.locals.authUser);
    res.send(new BaseRes("Done"));
  });
});

userRouter.delete("/remove-messaging-token", firebaseJwtAuth, async (req, res) => {
  action(res, async () => {
    await UserController.removeMessagingToken(req.body, res.locals.authUser);
    res.send(new BaseRes("Done"));
  });
});
