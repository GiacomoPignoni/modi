export interface RegisterUserReq {
  nickname: string;
}

export interface UpdateNicknameReq {
  nickname: string;
}

export interface CheckNicknameReq {
  nickname: string;
}

export interface AskToBePartnerReq {
  partnerNickname: string;
}

export interface AcceptPartnerRequestReq {
  partnerId: string;
}

export interface RejectPartnerRequestReq {
  partnerId: string;
}

export interface RegisterMessagingTokenReq {
  token: string;
}

export interface RemoveMessagingTokenReq {
  token: string;
}
