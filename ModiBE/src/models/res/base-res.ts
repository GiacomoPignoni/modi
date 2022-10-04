export class BaseRes {
  public message: string;
  public isError: boolean;

  constructor(message: string, isError: boolean = false) {
    this.message = message;
    this.isError = isError;
  }
}
