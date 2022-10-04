import { firestore } from "firebase-admin";
import { FirebaseUser, FirebaseUserProps } from "../models/firebase/user";
import { User } from "../models/res/user-reses";

export class UserMapper {
  public static fromFirebaseModelToUser(m: FirebaseUser, email: string, partnerNickname: string | undefined): User {
    return {
      nickname: m.n!,
      tokens: m.t!,
      email: email,
      combo: m.c!,
      partnerNickname: partnerNickname,
    };
  }

  public static getModelToCreateUser(nickname: string): FirebaseUser {
    return {
      n: nickname,
      nl: nickname.toLowerCase(),
      t: 0,
      c: 0,
      l: "1990-01-01",
    };
  }

  public static getModelForUpdateComboData(lastAddedDate: string, newCount: number, newTokens: number | undefined = undefined): any {
    const model: any = {};

    model[FirebaseUserProps.lastAddedDate] = lastAddedDate;
    model[FirebaseUserProps.comboCounter] = newCount;
    if (newTokens != undefined) {
      model[FirebaseUserProps.tokens] = newTokens;
    }

    return model;
  }

  public static getModelForUpdateNickname(nickname: string): any {
    const model: any = {};
    model[FirebaseUserProps.nickname] = nickname;
    model[FirebaseUserProps.nicknameLowerCase] = nickname.toLowerCase();
    return model;
  }

  public static getModelToUpdateTokens(newTokens: number): any {
    const model: any = {};
    model[FirebaseUserProps.tokens] = newTokens;
    return model;
  }

  public static getModelToUpdateMessagingTokens(newArray: string[]): any {
    const model: any = {};
    model[FirebaseUserProps.messagingTokens] = newArray;
    return model;
  }

  public static getModelToUpdatePartnerRequests(newArray: string[]): any {
    const model: any = {};
    model[FirebaseUserProps.partnerRequests] = newArray;
    return model;
  }

  public static getModelToAddPartner(partnerId: string): any {
    const model: any = {};
    model[FirebaseUserProps.partnerId] = partnerId;
    model[FirebaseUserProps.partnerRequests] = [];
    return model;
  }

  public static getModelToRemovePartner(): any {
    const model: any = {};
    model[FirebaseUserProps.partnerId] = firestore.FieldValue.delete();
    model[FirebaseUserProps.lastNotificationSentToPartnerTimestamp] = firestore.FieldValue.delete();
    return model;
  }

  public static getModelToUpdateLastNotificationSentToPartnerTimestamp(): any {
    const model: any = {};
    model[FirebaseUserProps.lastNotificationSentToPartnerTimestamp] = firestore.Timestamp.now();
    return model;
  }
}
