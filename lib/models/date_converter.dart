import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smart_lamp/models/word.dart';

int getDaysSince(Timestamp timestamp) {
  DateTime then = DateTime.parse(timestamp.toDate().toString());
  DateTime now = DateTime.now();
  return then.difference(now).inDays;
}

bool repeatToday(Word word) {
  int daysSinceAdded = getDaysSince(word.dateAdded!);
  int daysSinceLearned = getDaysSince(word.lastLearned!);
  bool repeatDay = false;

  switch (daysSinceAdded) {
    case 1:
      repeatDay = true;
      break;
    case 7:
      repeatDay = true;
      break;
    case 6:
      repeatDay = true;
      break;
    case 35:
      repeatDay = true;
      break;
    default:
      repeatDay = false;
      break;
  }

  return ((daysSinceLearned != 0) && repeatDay);
}
