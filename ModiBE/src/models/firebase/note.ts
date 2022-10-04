import { firestore } from "firebase-admin";

export interface FirebaseNote {
  /**
   * Text
   */
  t: string;
  /**
   * Date
   */
  d?: string;
  /**
   * Mood
   */
  m: number;
  /**
   * Unlocked
   */
  u?: boolean;
  /**
   * Added timestamp
   */
  at?: firestore.Timestamp;
}

export class FirebaseNoteProps {
  public static text = "t";
  public static date = "d";
  public static mood = "m";
  public static unlocked = "u";
  public static addedTimestamp = "at";
}
