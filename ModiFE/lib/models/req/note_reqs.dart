class AddNoteReq {
  final DateTime date;
  final String text;
  final int mood;
  final Duration timezoneOffset;

  AddNoteReq({
    required this.date,
    required this.text,
    required this.mood,
    required this.timezoneOffset
  });

  Map<String, dynamic> toJson() {
    return {
      "date": "${date.year}-${date.month.toString().padLeft(2, "0")}-${date.day.toString().padLeft(2, "0")}",
      "text": text,
      "mood": mood,
      "timezoneOffset": timezoneOffset.inMinutes
    };
  }
}

class UpdateNoteReq {
  final String id;
  final String text;
  final int mood;
  final Duration timezoneOffset;

  UpdateNoteReq({
    required this.id,
    required this.text,
    required this.mood,
    required this.timezoneOffset
  });

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "text": text,
      "mood": mood,
      "timezoneOffset": timezoneOffset.inMinutes
    };
  }
}
