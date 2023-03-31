import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smart_lamp/models/date_converter.dart';

import 'proxy.dart';

class Word {
  final String? id;
  String? word;
  String? definition;
  String? use;
  int? isLearned;
  Timestamp? dateAdded;
  Timestamp? lastLearned;

  Word(
      {this.id,
      this.word,
      this.definition,
      this.use,
      this.isLearned,
      this.dateAdded,
      this.lastLearned});

  factory Word.fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options) {
    final data = snapshot.data();
    return Word(
      id: snapshot.id,
      word: data?['word'],
      definition: data?['definition'],
      use: data?['use'],
      isLearned: data?['learned'],
      dateAdded: data?['timestamp'],
      lastLearned: data?['lastlearned'],
    );
  }

  bool showToday() {
    int daysSinceAdded = dateAdded != null ? getDaysSince(dateAdded!) : 0;
    int daysSinceLearned = getDaysSince(lastLearned!);
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

  void markLearned() {
    Proxy proxyModel = Proxy();
    int temp = isLearned != null ? isLearned! : 0;
    temp += 1;
    isLearned = temp;
    lastLearned = Timestamp.now();
    proxyModel.upsert(this);
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (word != null) "word": word,
      if (definition != null) "definition": definition,
      if (use != null) "use": use,
      // ignore: unnecessary_null_comparison
      if (isLearned != null) "learned": isLearned,
      if (dateAdded != null) "timestamp": dateAdded,
      if (lastLearned != null) "lastlearned": lastLearned,
    };
  }
}
