import { BaseRes } from "./base-res";
import { SingleNote } from "./note-reses";

export class BuyNoteRes extends BaseRes {
  public unlockedNote: SingleNote;
  public tokens: number;

  constructor(unlockedNote: SingleNote, tokens: number) {
    super("", false);
    this.unlockedNote = unlockedNote;
    this.tokens = tokens;
  }
}

export class GetPricesRes extends BaseRes {
  public randomNote: number;
  public randomMonthNote: number;
  public note: number;

  constructor(randomNote: number, randomMonthNote: number, note: number) {
    super("", false);
    this.randomNote = randomNote;
    this.randomMonthNote = randomMonthNote;
    this.note = note;
  }
}
