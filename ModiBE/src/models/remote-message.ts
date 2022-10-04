/* eslint-disable no-unused-vars */
export enum RemoteMessageType {
  other,
  partnerRequest,
  partnerReminder,
  partnerRemoved,
  partnerAccepted
}

export class RemoteMessageData {
  public type: RemoteMessageType;

  constructor(type: RemoteMessageType) {
    this.type = type;
  }

  public toMap(): { [key: string]: string; } {
    return {
      "type": this.type.toString(),
    };
  }
}

export class RemoteMessagePartnerRequest extends RemoteMessageData {
  public partnerNickname: string;

  constructor(parterNickname: string) {
    super(RemoteMessageType.partnerRequest);
    this.partnerNickname = parterNickname;
  }

  public toMap(): { [key: string]: string; } {
    const model = super.toMap();
    model["partnerNickname"] = this.partnerNickname;
    return model;
  }
}

export class RemoteMessagePartnerReminder extends RemoteMessageData {
  public partnerNickname: string;

  constructor(parterNickname: string) {
    super(RemoteMessageType.partnerReminder);
    this.partnerNickname = parterNickname;
  }

  public toMap(): { [key: string]: string; } {
    const model = super.toMap();
    model["partnerNickname"] = this.partnerNickname;
    return model;
  }
}

export class RemoteMessagePartnerAccepted extends RemoteMessageData {
  public partnerNickname: string;

  constructor(parterNickname: string) {
    super(RemoteMessageType.partnerAccepted);
    this.partnerNickname = parterNickname;
  }

  public toMap(): { [key: string]: string; } {
    const model = super.toMap();
    model["partnerNickname"] = this.partnerNickname;
    return model;
  }
}
