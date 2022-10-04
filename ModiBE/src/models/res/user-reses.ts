import { BaseRes } from "./base-res";

export class GetUserRes extends BaseRes {
  public user: User;

  constructor(user: User) {
    super("", false);
    this.user = user;
  }
}

export interface User {
  nickname: string;
  tokens: number;
  email?: string | undefined;
  combo: number;
  partnerNickname?: string;
}

export class CheckNicknameRes extends BaseRes {
  available: boolean;

  constructor(available: boolean) {
    super("", false);
    this.available = available;
  }
}

export class GetPartnerRequestsRes extends BaseRes {
  requests: PartnerRequestDetails[];

  constructor(requests: PartnerRequestDetails[]) {
    super("", false);
    this.requests = requests;
  }
}

export interface PartnerRequestDetails {
  id: string;
  nickname: string;
}
