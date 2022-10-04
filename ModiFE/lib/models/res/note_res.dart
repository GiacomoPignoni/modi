import 'package:modi/models/res/base_res.dart';
import 'package:modi/models/single_note.dart';

enum ComboType {
  mini,
  big
}

class GetManyNotesRes extends BaseRes {
  final List<SingleNote> notes;

  GetManyNotesRes.fromJson(Map<String, dynamic> json) :
    notes = (json["notes"] as List<dynamic>).map<SingleNote>((x) => SingleNote.fromJson(x)).toList(),
    super.fromJson(json);
}

class AddNotesRes extends BaseRes {
  final SingleNote? note;
  final int tokens;
  final int gainedTokens;
  final ComboType? comboType;
  final int comboCounter;

  AddNotesRes.fromJson(Map<String, dynamic> json) :
    note = json["note"] != null ? SingleNote.fromJson(json["note"]) : null,
    tokens = json["tokens"] ?? 0,
    gainedTokens = json["gainedTokens"] ?? 0,
    comboType = json["comboType"] != null ? ComboType.values[json["comboType"]] : null,
    comboCounter = json["comboCounter"] ?? 0,
    super.fromJson(json);
}

class UpdateNoteRes extends BaseRes {
  final SingleNote? note;

  UpdateNoteRes.fromJson(Map<String, dynamic> json) :
    note = json["note"] != null ? SingleNote.fromJson(json["note"]) : null,
    super.fromJson(json);
}
