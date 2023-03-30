import 'package:flutter/material.dart';
import 'package:smart_lamp/assets/theme.dart';

import '../models/word.dart';
import '../pages/word_page.dart';

void toDetails(Word word, BuildContext context) {
  Navigator.push(
      context, MaterialPageRoute(builder: (context) => WordPage(word: word)));
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
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            IconButton(
              onPressed: () => toDetails(word, context),
              icon: const Icon(Icons.chevron_right_sharp),
              iconSize: 32,
            )
          ],
        ),
      ),
    ),
  );
}
