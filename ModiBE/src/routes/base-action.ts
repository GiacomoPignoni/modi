import { Logger } from "../utils/logger";
import { Response } from "express";
import { BaseRes } from "../models/res/base-res";

export async function action(res: Response, action: () => {}): Promise<void> {
  try {
    await action();
  } catch (error: any) {
    Logger.error(error, res.locals.authUser);
    res.send(new BaseRes(error.message, true));
  }
}
