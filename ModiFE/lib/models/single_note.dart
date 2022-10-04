import 'package:modi/models/moods.dart';

class SingleNote {
  String id;
  String? text;
  Mood? mood;
  DateTime date;
  bool unlocked;

  SingleNote.fromJson(Map<String, dynamic> json) :
    id = json["id"],
    text = json["text"],
    mood = Mood.values[json["mood"]],
    unlocked = json["unlocked"] ?? false,
    date = DateTime.parse(json["date"]);
}
