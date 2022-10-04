import { config } from "../config";
import { NotesMapper } from "../mappers/notes-mapper";
import { UserMapper } from "../mappers/user-mapper";
import { AuthUser } from "../models/auth-user";
import { FirebaseCollections } from "../models/firebase/collections";
import { FirebaseNoteProps, FirebaseNote } from "../models/firebase/note";
import { FirebaseUser } from "../models/firebase/user";
import { BuyNoteRes, GetPricesRes } from "../models/res/shop-reses";
import { errorCodes } from "../utils/error-codes";
import { UserController } from "./user-controller";

/**
 * Controller to execute shop actions
 */
export class ShopController {
  /**
   * Return all shop prices
   * @return {Promise<GetPricesRes>}
   */
  public static async getPrices(): Promise<GetPricesRes> {
    return new GetPricesRes(
        config.randomNotePrice,
        config.randomMonthNotePrice,
        config.notePrice,
    );
  }

  /**
   * Unlock a random note from user if it has enought tokens
   * Automatically update available user's tokens
   * @param {AuthUser} authUser The user on which to perform the action
   * @return {Promise<BuyNoteRes>}
   */
  public static async unlockRandomNote(authUser: AuthUser): Promise<BuyNoteRes> {
    const userDoc = await UserController.getUserDoc(authUser.id);
    const userData: FirebaseUser = userDoc.data()! as FirebaseUser;

    if (userData.t >= config.randomNotePrice) {
      const unlockableNotes = await userDoc.ref.collection(FirebaseCollections.userNotes)
          .where(FirebaseNoteProps.unlocked, "!=", true).get();

      if (unlockableNotes.size > 0) {
        const randomIndex = Math.floor(Math.random() * unlockableNotes.size);

        // Unlock the note
        unlockableNotes.docs[randomIndex].ref.update(NotesMapper.getModelToUnlockNote());

        // Remove tokens from user
        const newTokens = userData.t - config.randomNotePrice;
        userDoc.ref.update(UserMapper.getModelToUpdateTokens(newTokens));

        // Get the unlocked note to return it
        const unlockedNote: FirebaseNote = unlockableNotes.docs[randomIndex].data() as FirebaseNote;
        unlockedNote.u = true;
        return new BuyNoteRes(
            NotesMapper.fromFirebaseModelToSingleNote(unlockedNote, unlockableNotes.docs[randomIndex].id),
            newTokens,
        );
      } else {
        throw new Error(errorCodes.shop.noNotesToUnlock);
      }
    } else {
      throw new Error(errorCodes.shop.noTokens);
    }
  }

  /**
   * Unlock a random note from the given month and current year from user if it has enought tokens
   * Automatically update available user's tokens
   * @param {number} month The month from which to take the note
   * @param {AuthUser} authUser The user on which to perform the action
   * @return {Promise<BuyNoteRes>}
   */
  public static async unlockRandomMonthNote(month: number, authUser: AuthUser): Promise<BuyNoteRes> {
    // Check month validity
    if (Number.isInteger(month) && month < 1 || month > 12) {
      throw new Error(errorCodes.shop.invalidMonth);
    }

    const userDoc = await UserController.getUserDoc(authUser.id);
    const userData: FirebaseUser = userDoc.data()! as FirebaseUser;

    if (userData.t >= config.randomMonthNotePrice) {
      // Calculate dates to filter notes
      const now = new Date();
      const dateFrom = new Date(now.getFullYear(), month - 1, 1);
      const dateTo = new Date(now.getFullYear(), month, 0);

      const dateFilterNotes = await userDoc.ref.collection(FirebaseCollections.userNotes)
          .where(FirebaseNoteProps.date, ">=", NotesMapper.getStringDate(dateFrom))
          .where(FirebaseNoteProps.date, "<=", NotesMapper.getStringDate(dateTo))
          .get();

      // Manually filter unlocked notes bacause Firebase doesn't allow to filter on multiple properties
      // Not a big problem because the notes will be max 31, because they are filtered by month
      const unlockableNotes = dateFilterNotes.docs.filter((x) => x.data()[FirebaseNoteProps.unlocked] === false);

      if (unlockableNotes.length > 0) {
        const randomIndex = Math.floor(Math.random() * unlockableNotes.length);

        // Unlock the note
        unlockableNotes[randomIndex].ref.update(NotesMapper.getModelToUnlockNote());

        // Remove tokens from user
        const newTokens = userData.t - config.randomMonthNotePrice;
        userDoc.ref.update(UserMapper.getModelToUpdateTokens(newTokens));

        // Get unlocked note to return it
        const unlockedNote: FirebaseNote = unlockableNotes[randomIndex].data() as FirebaseNote;
        unlockedNote.u = true;
        return new BuyNoteRes(
            NotesMapper.fromFirebaseModelToSingleNote(unlockedNote, unlockableNotes[randomIndex].id),
            newTokens,
        );
      } else {
        throw new Error(errorCodes.shop.noNotesToUnlock);
      }
    } else {
      throw new Error(errorCodes.shop.noTokens);
    }
  }

  /**
   * Unlock a note from the given date from user if it has enought tokens
   * Automatically update available user's tokens
   * @param {string} date The date from which to take the note
   * @param {AuthUser} authUser The user on which to perform the action
   * @return {Promise<BuyNoteRes>}
   */
  public static async unlockNote(date: string, authUser: AuthUser): Promise<BuyNoteRes> {
    const userDoc = await UserController.getUserDoc(authUser.id);
    const userData: FirebaseUser = userDoc.data()! as FirebaseUser;

    if (userData.t >= config.notePrice) {
      const unlockableNotes = await userDoc.ref.collection(FirebaseCollections.userNotes)
          .where(FirebaseNoteProps.date, "==", NotesMapper.getStringDate(new Date(date)))
          .get();

      if (unlockableNotes.size > 0) {
        const note: FirebaseNote = unlockableNotes.docs[0].data() as FirebaseNote;

        if (note.u === true) {
          throw new Error(errorCodes.shop.noteAlreadyUnlocked);
        }

        // Unlock note
        unlockableNotes.docs[0].ref.update(NotesMapper.getModelToUnlockNote());

        // Remove token from user
        const newTokens = userData.t - config.notePrice;
        userDoc.ref.update(UserMapper.getModelToUpdateTokens(newTokens));

        note.u = true;
        return new BuyNoteRes(
            NotesMapper.fromFirebaseModelToSingleNote(note, unlockableNotes.docs[0].id),
            newTokens,
        );
      } else {
        throw new Error(errorCodes.shop.noteNotFound);
      }
    } else {
      throw new Error(errorCodes.shop.noTokens);
    }
  }
}
