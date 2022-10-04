class CheckNicknameReq {
  final String nickname;

  CheckNicknameReq({
    required this.nickname
  });

  Map<String, dynamic> toJson() {
    return {
      "nickname": nickname
    };
  }
}

class RegisterUserReq {
  final String nickname;

  RegisterUserReq({
    required this.nickname
  });

  Map<String, dynamic> toJson() {
    return {
      "nickname": nickname
    };
  }
}

class UpdateNicknameReq {
  final String nickname;

  UpdateNicknameReq({
    required this.nickname
  });

  Map<String, dynamic> toJson() {
    return {
      "nickname": nickname
    };
  }
}

class SendPartnerRequestReq {
  final String partnerNickname;

  SendPartnerRequestReq({
    required this.partnerNickname
  });

  Map<String, dynamic> toJson() {
    return {
      "partnerNickname": partnerNickname
    };
  }
}

class AcceptPartnerRequestReq {
  final String partnerId;

  AcceptPartnerRequestReq({
    required this.partnerId
  });

  Map<String, dynamic> toJson() {
    return {
      "partnerId": partnerId
    };
  }
}

class RejectPartnerRequestReq {
  final String partnerId;

  RejectPartnerRequestReq({
    required this.partnerId
  });

  Map<String, dynamic> toJson() {
    return {
      "partnerId": partnerId
    };
  }
}

class RegisterMessaginTokenReq {
  final String token;

  RegisterMessaginTokenReq({
    required this.token
  });

  Map<String, dynamic> toJson() {
    return {
      "token": token
    };
  }
}

class RemoveMessaginTokenReq {
  final String token;

  RemoveMessaginTokenReq({
    required this.token
  });

  Map<String, dynamic> toJson() {
    return {
      "token": token
    };
  }
}
