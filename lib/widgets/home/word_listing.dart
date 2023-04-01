import 'package:flutter/material.dart';
import 'package:smart_lamp/assets/theme.dart';

import '../../models/word.dart';
import '../../pages/word_page.dart';

void toDetails(Word word, BuildContext context) {
  Navigator.push(
      context, MaterialPageRoute(builder: (context) => WordPage(word: word)));
}

Widget getBox(bool filled, Color color) {
  return Container(
    width: 14,
    height: 28,
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(3),
        color: filled ? color : Colors.transparent,
        border:
            Border.all(width: 2, color: filled ? Colors.transparent : color)),
  );
}

Widget learnedProgress(Word word) {
  List<Widget> boxes = [];
  Color color = (word.isLearned! == 4) ? surface : dark.withAlpha(150);
  int numFilled = word.isLearned!;
  for (int i = 0; i < 4; i++) {
    if (numFilled > 0) {
      boxes.add(getBox(true, color));
      numFilled--;
    } else {
      boxes.add(getBox(false, color));
    }
  }
  return Wrap(
    spacing: 6,
    children: boxes,
  );
}

Widget wordListing(Word word, BuildContext context) {
  return Card(
    elevation: 0,
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: word.isLearned == 4
            ? BorderSide(width: 2, color: surface)
            : BorderSide.none),
    color: word.isLearned == 4 ? Colors.transparent : surface,
    child: InkWell(
      onTap: () => toDetails(word, context),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              word.word!,
              style: TextStyle(color: dark, fontSize: 20),
            ),
            learnedProgress(word)
            // IconButton(
            //   onPressed: () => toDetails(word, context),
            //   icon: const Icon(Icons.chevron_right_sharp),
            //   iconSize: 32,
            // )
          ],
        ),
      ),
    ),
  );
}
