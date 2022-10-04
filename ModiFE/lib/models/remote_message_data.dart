enum RemoteMessageType {
  other,
  partnerRequest,
  partnerReminder,
  partnerRemoved,
  partnerAccepted
}

class RemoteMessageData {
  final RemoteMessageType type;

  RemoteMessageData.fromJson(Map<String, dynamic> json) :
    type = RemoteMessageType.values[int.tryParse(json["type"] ?? "0") ?? 0];
}

class PartnerRequestRemoteMessage extends RemoteMessageData {
  final String partnerNickname;

  PartnerRequestRemoteMessage.fromJson(Map<String, dynamic> json) :
    partnerNickname = json["partnerNickname"] ?? "ERROR",
    super.fromJson(json);
}

class PartnerReminderRemoteMessage extends RemoteMessageData {
  final String partnerNickname;

  PartnerReminderRemoteMessage.fromJson(Map<String, dynamic> json) :
    partnerNickname = json["partnerNickname"] ?? "ERROR",
    super.fromJson(json);
}

class PartnerAcceptedRemoteMessage extends RemoteMessageData {
  final String partnerNickname;

  PartnerAcceptedRemoteMessage.fromJson(Map<String, dynamic> json) :
    partnerNickname = json["partnerNickname"] ?? "ERROR",
    super.fromJson(json);
}
