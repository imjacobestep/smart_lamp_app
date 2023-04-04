import 'package:flutter/material.dart';
import 'package:smart_lamp/models/word.dart';
import 'package:smart_lamp/widgets/general/spacer.dart';
import 'package:smart_lamp/widgets/home/word_listing.dart';

import '../../assets/theme.dart';
import '../general/navbar.dart';

Widget wordProgress(Word word, BuildContext context) {
  return Card(
      child: Padding(
    padding: const EdgeInsets.all(20),
    child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.6,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  word.isLearned == 4 ? "Great work!" : "Keep it up!",
                  style: TextStyle(
                      color: dark, fontSize: 25, fontWeight: FontWeight.bold),
                ),
                Text(
                  word.isLearned == 4
                      ? "You’ve reinforced this word the recommended number of times. Check back for more words."
                      : "You’ve reinforced this word ${word.isLearned} out of 4 times. Keep working on it to boost long-term recall.",
                  style: TextStyle(color: dark, fontSize: 16),
                  maxLines: 10,
                  overflow: TextOverflow.ellipsis,
                  softWrap: false,
                ),
                getSpacer(10),
                Container(
                    constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.43),
                    child: word.isLearned == 4
                        ? SizedBox()
                        : navIcon(
                            "Mark Learned", Icons.check_circle_outline_outlined,
                            () {
                            word.markLearned();
                          }, true))
              ],
            ),
          ),
          learnedProgress(word, true),
        ]),
  ));
}
