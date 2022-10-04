import 'package:modi/models/res/base_res.dart';
import 'package:modi/models/single_note.dart';

class GetPricesRes extends BaseRes {
  int randomNote;
  int randomMonthNote;
  int note;

  GetPricesRes.fromJson(Map<String, dynamic> json) :
    randomNote = json["randomNote"] ?? 0,
    randomMonthNote = json["randomMonthNote"] ?? 0,
    note = json["note"] ?? 0,
    super.fromJson(json);
}

class BuyNoteRes extends BaseRes {
  SingleNote? unlockedNote;
  int tokens;

  BuyNoteRes.fromJson(Map<String, dynamic> json) :
    unlockedNote = json["unlockedNote"] != null ? SingleNote.fromJson(json["unlockedNote"]) : null,
    tokens = json["tokens"] ?? 0,
    super.fromJson(json);
}
