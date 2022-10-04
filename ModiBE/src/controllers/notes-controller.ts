import { AddNoteReq, UpdateNoteReq } from "../models/req/note-reqs";
import { NotesMapper } from "../mappers/notes-mapper";
import { FirebaseNote, FirebaseNoteProps } from "../models/firebase/note";
import { AddNoteRes, CalculateComboRes, ComboType, SingleNote, UpdateNoteRes } from "../models/res/note-reses";
import { AuthUser } from "../models/auth-user";
import { FirebaseCollections } from "../models/firebase/collections";
import { FirebaseUser } from "../models/firebase/user";
import { config } from "../config";
import { BaseRes } from "../models/res/base-res";
import { errorCodes } from "../utils/error-codes";
import { UserMapper } from "../mappers/user-mapper";
import { UserController } from "./user-controller";

/**
 * Controller to execute notes related actions
 */
export class NotesController {
  /**
   * Return a list of note from the given user filtered by the given dates
   * @param {string} dateFromStr Start filter date
   * @param {string} dateToStr End filter date
   * @param {AuthUser} authUser The user on which to perform the action
   * @return {Promise<SingleNote[]>}
   */
  public static async getMany(dateFromStr: string, dateToStr: string, authUser: AuthUser): Promise<SingleNote[]> {
    const userDoc = await UserController.getUserDoc(authUser.id);
    const collection = userDoc.ref.collection(FirebaseCollections.userNotes);

    // Generate date for the query
    const dateFrom = NotesMapper.getStringDate(new Date(dateFromStr));
    const dateTo = NotesMapper.getStringDate(new Date(dateToStr));

    const query = await collection.where(FirebaseNoteProps.date, ">=", dateFrom).where(FirebaseNoteProps.date, "<=", dateTo).get();

    const res = query.docs.map((x) => NotesMapper.fromFirebaseModelToSingleNote(x.data() as FirebaseNote, x.id));
    return res;
  }

  /**
   * Return all the notes of the user's partner
   * If the user hasn't a partner throw an Error
   * @param {number} year The filter year
   * @param {AuthUser} authUser The user on which to perform the action
   * @return {Promise<SingleNote[]>}
   */
  public static async getPartnerNotesPerYear(year: number, authUser: AuthUser): Promise<SingleNote[]> {
    const partnerDoc = UserController.getPartnerDoc(authUser.id);
    const collection = (await partnerDoc).ref.collection(FirebaseCollections.userNotes);

    const dateFrom = NotesMapper.getStringDate(new Date(year, 0, 1));
    const dateTo = NotesMapper.getStringDate(new Date(year, 11, 31));
    const query = await collection.where(FirebaseNoteProps.date, ">=", dateFrom).where(FirebaseNoteProps.date, "<=", dateTo).get();

    const res = query.docs.map((x) => NotesMapper.fromFirebaseModelToSingleNote(x.data() as FirebaseNote, x.id));
    return res;
  }

  /**
   * Return the year available to be used as filter in the other NotesController methods
   * @param {AuthUser} authUser The user on which to perform the action
   * @return {Promise<number[]>}
   */
  public static async getAvailableYears(authUser: AuthUser): Promise<number[]> {
    const years: number[] = [];

    const userDoc = await UserController.getUserDoc(authUser.id);
    const allNotesQuery = await userDoc.ref.collection(FirebaseCollections.userNotes).get();
    allNotesQuery.forEach((snap) => {
      const year: number | null = NotesMapper.getYearFromFirebaseNote(snap.data() as FirebaseNote);

      if (year && years.includes(year) == false) {
        years.push(year);
      }
    });

    return years;
  }

  /**
   * Add the given note to the given user
   * @param {AddNoteReq} req The req with the information about the note to add
   * @param {AuthUser }authUser The user on which to perform the action
   * @return {Promise<AddNoteRes>}
   */
  public static async add(req: AddNoteReq, authUser: AuthUser): Promise<AddNoteRes> {
    this.checkAddReqValidity(req);

    const userDoc = await UserController.getUserDoc(authUser.id);
    const collection = userDoc.ref.collection(FirebaseCollections.userNotes);

    // Search for a possible note with the same date
    const reqDate = new Date(req.date);
    const query = await collection.where(FirebaseNoteProps.date, "==", NotesMapper.getStringDate(reqDate)).get();

    if (query.size == 0) {
      const firebaseNote = NotesMapper.fromAddReqToFirebaseModel(req);
      const addedDoc = await collection.add(firebaseNote);
      const calculateComboRes = await this.calculateCombo(userDoc, reqDate, firebaseNote, req.timezoneOffset);

      const addedDocSnap = await addedDoc.get();
      return new AddNoteRes(
          NotesMapper.fromFirebaseModelToSingleNote(addedDocSnap.data() as FirebaseNote, addedDocSnap.id),
          calculateComboRes,
      );
    } else {
      throw new Error(errorCodes.notes.alreadyAddedNote);
    }
  }

  /**
   * Update the given note of the given user
   * @param {UpdateNoteReq} req The req with the information about the note to update
   * @param {AuthUser} authUser The user on which to perform the action
   * @return {Promise<UpdateNoteRes>}
   */
  public static async update(req: UpdateNoteReq, authUser: AuthUser): Promise<UpdateNoteRes> {
    this.checkUpdateReqValidity(req);

    const userDoc = await UserController.getUserDoc(authUser.id);
    const collection = userDoc.ref.collection(FirebaseCollections.userNotes);
    const noteDoc = await collection.doc(req.id).get();

    if (noteDoc.exists) {
      const firebaseNote = noteDoc.data() as FirebaseNote;

      if (firebaseNote.d! !== this.getNowWithUserTimezone(req.timezoneOffset)) {
        throw new Error(errorCodes.notes.cantUpdateNote);
      }

      const newFirebaseNote = NotesMapper.fromUpdateReqToFirebaseModel(req);
      await noteDoc.ref.update(newFirebaseNote);

      const newNoteDoc = await noteDoc.ref.get();
      return new UpdateNoteRes(NotesMapper.fromFirebaseModelToSingleNote(newNoteDoc.data() as FirebaseNote, noteDoc.id));
    } else {
      throw new Error(errorCodes.notes.noteNotFound);
    }
  }

  /**
   * Delete the given note from the given user
   * @param {string} noteId The note id to be delete
   * @param {AuthUser} authUser The user on which to perform the action
   * @return {Promise<BaseRes>}
   */
  public static async delete(noteId: string, authUser: AuthUser): Promise<BaseRes> {
    const userDoc = await UserController.getUserDoc(authUser.id);
    const collection = userDoc.ref.collection(FirebaseCollections.userNotes);

    const doc = await collection.doc(noteId).get();
    if (doc.exists) {
      await collection.doc(noteId).delete();
      return new BaseRes("Done");
    } else {
      throw new Error(errorCodes.notes.noteNotFound);
    }
  }

  /**
   * Calculate the combo value of the given user and give to him the new amount of tokens if he do a combo
   * @param {FirebaseFirestore.DocumentSnapshot<FirebaseFirestore.DocumentData>} userDoc The user's firebase doc to operate on
   * @param {Date} reqDate The latest added date
   * @param {FirebaseNote} firebaseNote The latest added
   * @param {number} timezoneOffset The timezone of the user
   * @return {Promise<number>} New calculated tokens value
   */
  private static async calculateCombo(
      userDoc: FirebaseFirestore.DocumentSnapshot<FirebaseFirestore.DocumentData>,
      reqDate: Date,
      firebaseNote: FirebaseNote,
      timezoneOffset?: number,
  ): Promise<CalculateComboRes> {
    const userData = await userDoc.data() as FirebaseUser;

    const now = this.getNowWithUserTimezone(timezoneOffset);
    const reqDateStr = NotesMapper.getStringDate(reqDate);

    const res: CalculateComboRes = {
      tokens: userData.t!,
      gainedTokens: 0,
      comboCounter: userData.c
    };

    if (now === reqDateStr) {
      const dateBefore = new Date(reqDate.getFullYear(), reqDate.getMonth(), reqDate.getDate() - 1);
      
      if (userData.l! < now) {
        res.gainedTokens = 1;
        res.tokens += 1;
      }

      if (userData.l === NotesMapper.getStringDate(dateBefore)) {
        const newCount = (userData.c ?? 0) + 1;

        if (newCount % config.miniCombo === 0) {
          //This is made to remove the 1 gained token before
          res.tokens += config.miniComboToken - res.gainedTokens;

          res.gainedTokens = config.miniComboToken;
          res.comboType = ComboType.mini;
        }

        if (newCount % config.bigCombo === 0) {
          //This is made to remove the 1 gained token before
          res.tokens += config.bigComboToken - res.gainedTokens;;

          res.gainedTokens = config.bigComboToken;
          res.comboType = ComboType.big;
        }

        res.comboCounter = newCount;
        await userDoc.ref.update(UserMapper.getModelForUpdateComboData(firebaseNote.d!, newCount, res.tokens));
        return res;
      } else if (firebaseNote.d! > userData.l!) {
        await userDoc.ref.update(UserMapper.getModelForUpdateComboData(firebaseNote.d!, 0, res.tokens));
      }
    }

    return res;
  }

  private static checkUpdateReqValidity(req: UpdateNoteReq): void {
    if (req.text == null || req.mood == null || req.id == null) {
      throw new Error(errorCodes.invalidInput);
    }
  }

  private static checkAddReqValidity(req: AddNoteReq): void {
    if (req.text == null || req.mood == null || req.date == null) {
      throw new Error(errorCodes.invalidInput);
    }

    if (req.date > this.getNowWithUserTimezone(req.timezoneOffset)) {
      throw new Error(errorCodes.notes.cantAddNoteInFuture);
    }

    const now = new Date();
    if (req.date < this.getDateStringWithUserTimezone(new Date(now.getFullYear(), 0, 1), req.timezoneOffset)) {
      throw new Error(errorCodes.notes.addNoteInCurrentYear);
    }
  }

  private static getNowWithUserTimezone(timezoneOffset?: number): string {
    return this.getDateStringWithUserTimezone(new Date(), timezoneOffset);
  }

  /**
   * Covert the given date based on the given timezoneOffeset
   * @param {Date} date The date to be converted
   * @param {number} timezoneOffset The timezone offset in minutes
   * @return {string} The convert date formatted in string from the NotesMapper
   */
  private static getDateStringWithUserTimezone(date: Date, timezoneOffset?: number): string {
    date.setMinutes(date.getMinutes() + date.getTimezoneOffset());
    date.setMinutes(date.getMinutes() + ((timezoneOffset == undefined) ? 0 : timezoneOffset));

    return NotesMapper.getStringDate(date);
  }
}
