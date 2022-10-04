import admin from "firebase-admin";

export interface FirebaseUser {
  /**
   * Nickname
   */
  n: string;
  /**
   * Nickname lowercase
   */
  nl: string;
  /**
   * Tokens
   */
  t: number;
  /**
   * Combo counter
   */
  c: number;
  /**
   * Last added date
   */
  l: string;
  /**
   * Partner id
   */
  p?: string;
  /**
   * Messaging tokens
   */
  m?: string[];
  /**
   * Partners requests
  */
  pr?: string[];
  /**
   * Last Notification sent to partner timestamp
   */
  nd?: admin.firestore.Timestamp;
}

export class FirebaseUserProps {
  public static nickname = "n";
  public static nicknameLowerCase = "nl";
  public static tokens = "t";
  public static comboCounter = "c";
  public static lastAddedDate = "l";
  public static partnerId = "p";
  public static partnerRequests = "pr";
  public static messagingTokens = "m";
  public static lastNotificationSentToPartnerTimestamp = "nd";
}
