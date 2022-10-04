import { firestore } from "firebase-admin";
import { FirebaseNote, FirebaseNoteProps } from "../models/firebase/note";
import { AddNoteReq, UpdateNoteReq } from "../models/req/note-reqs";
import { SingleNote } from "../models/res/note-reses";

export class NotesMapper {
  public static fromAddReqToFirebaseModel(m: AddNoteReq): FirebaseNote {
    return {
      d: this.getStringDate(new Date(m.date)),
      m: m.mood,
      t: m.text,
      u: false,
      at: firestore.Timestamp.now(),
    };
  }

  public static fromUpdateReqToFirebaseModel(m: UpdateNoteReq): FirebaseNote {
    return {
      m: m.mood,
      t: m.text,
    };
  }

  public static getModelToUnlockNote(): any {
    const model: any = {};
    model[FirebaseNoteProps.unlocked] = true;
    return model;
  }

  public static getStringDate(date: Date): string {
    return `${date.getFullYear()}-${(date.getMonth() + 1).toString().padStart(2, "0")}-${date.getDate().toString().padStart(2, "0")}`;
  }

  public static fromFirebaseModelToSingleNote(m: FirebaseNote, id: string): SingleNote {
    const now = new Date();
    const textVisible = m.d === this.getStringDate(now) || m.u;

    return {
      id,
      mood: m.m,
      text: textVisible ? m.t : null,
      date: m.d!,
      unlocked: m.u ?? false,
      addedTimestampSeconds: m.at?.seconds ?? 0,
    };
  }

  public static getYearFromFirebaseNote(firebaseNote: FirebaseNote): number | null {
    const yearStr = firebaseNote.d?.split("-")[0];

    if (yearStr) {
      return parseInt(yearStr);
    }

    return null;
  }
}
