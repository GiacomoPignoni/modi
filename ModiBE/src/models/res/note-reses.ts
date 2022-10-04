import { BaseRes } from "./base-res";

export interface SingleNote {
  id: string;
  text?: string | null;
  mood: number;
  date: string;
  unlocked: boolean;
  addedTimestampSeconds: number;
}

export enum ComboType {
  mini = 0,
  big = 1
}

export interface CalculateComboRes {
  tokens: number;
  gainedTokens: number;
  comboType?: ComboType;
  comboCounter: number;
}

export class GetManyNotesRes extends BaseRes {
  public notes: SingleNote[];

  constructor(notes: SingleNote[]) {
    super("", false);
    this.notes = notes;
  }
}

export class AddNoteRes extends BaseRes {
  public tokens: number;
  public note: SingleNote;
  public gainedTokens: number;
  public comboType?: ComboType;
  public comboCounter: number;

  constructor(note: SingleNote, calculateComboRes: CalculateComboRes) {
    super("", false);
    this.note = note;
    this.tokens = calculateComboRes.tokens;
    this.gainedTokens = calculateComboRes.gainedTokens;
    this.comboType = calculateComboRes.comboType;
    this.comboCounter = calculateComboRes.comboCounter;
  }
}

export class UpdateNoteRes extends BaseRes {
  public note: SingleNote;

  constructor(note: SingleNote) {
    super("", false);
    this.note = note;
  }
}

export class GetAvailableYearsRes extends BaseRes {
  public years: number[];

  constructor(years: number[]) {
    super("", false);
    this.years = years;
  }
}
