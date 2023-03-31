import 'package:flutter/material.dart';
import 'package:smart_lamp/assets/theme.dart';
import 'package:smart_lamp/models/dictionary.dart';
import 'package:smart_lamp/widgets/gpt_message.dart';
import 'package:smart_lamp/widgets/spacer.dart';
import 'package:smart_lamp/widgets/word_definitions.dart';

import '../models/word.dart';

Widget wordMedia(Word word) {
  return ListView(
    children: [
      mediaSection("Chat", gptMessage(word.word!)),
      mediaSection("Definitions", wordDefinitions(word.word!)),
      SizedBox(
        height: 200,
      )
    ],
  );
}

Widget mediaSection(String label, Widget media) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisSize: MainAxisSize.min,
    children: [
      Text(
        " $label",
        style: TextStyle(fontSize: 18, color: dark),
      ),
      media,
    ],
  );
}
