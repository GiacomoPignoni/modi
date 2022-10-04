/* eslint-disable no-console */

import { AuthUser } from "../models/auth-user";
import { isProd } from "./env";

export class Logger {
  public static info(message: any, authUser?: AuthUser): void {
    console.log("\x1b[32m", `${this.getDate()} [${authUser?.id}] ${message}`, "\x1b[0m");
  }

  public static debugInfo(message: any, authUser?: AuthUser): void {
    if (isProd === false) {
      console.log("\x1b[32m", `${this.getDate()} [${authUser?.id}] ${message}`, "\x1b[0m");
    }
  }

  public static error(message: any, authUser?: AuthUser): void {
    console.log("\x1b[31m", `${this.getDate()} [${authUser?.id}] ${message}`, "\x1b[0m");
  }

  private static getDate(): string {
    const now = new Date();
    return `[${now.getDate()}-${now.getMonth() + 1}-${now.getFullYear()} ${now.getHours()}:${now.getMinutes()}:${now.getSeconds()}]`;
  }
}
