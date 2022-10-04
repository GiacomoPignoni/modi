export interface AddNoteReq {
  date: string;
  text: string;
  mood: number;
  timezoneOffset?: number;
}

export interface UpdateNoteReq {
  id: string;
  text: string;
  mood: number;
  timezoneOffset?: number;
}
