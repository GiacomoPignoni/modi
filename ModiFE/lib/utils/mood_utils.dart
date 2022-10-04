import 'package:modi/models/moods.dart';

class MoodUtils {
  static String getMoodFileName(Mood mood, bool selected) {
    switch(mood) {
      case Mood.happy:
        if(selected) {
          return "happy.svg";
        } else {
          return "happy_outlined.svg";
        }
      case Mood.neutral:
        if(selected) {
          return "neutral.svg";
        } else {
          return "neutral_outlined.svg";
        }
      case Mood.sad:
        if(selected) {
          return "sad.svg";
        } else {
          return "sad_outlined.svg";
        }
      case Mood.angry:
        if(selected) {
          return "angry.svg";
        } else {
          return "angry_outlined.svg";
        }
    }
  }
}
