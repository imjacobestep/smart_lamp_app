import 'package:flutter/material.dart';
import 'package:smart_lamp/assets/theme.dart';
import 'package:smart_lamp/widgets/chat/gpt_message.dart';
import 'package:smart_lamp/widgets/word/word_definitions.dart';
import 'package:smart_lamp/widgets/word/word_media_search.dart';
import 'package:smart_lamp/widgets/word/word_progress.dart';
import 'package:smart_lamp/widgets/word/word_shortcuts.dart';

import '../../models/word.dart';

Widget wordMedia(Word word, BuildContext context) {
  return ListView(
    children: [
      mediaSection("Progress", wordProgress(word, context)),
      // mediaSection("Chat", gptMessage(word.word!, context)),
      mediaSection("Shortcuts", wordShortcuts(word, context)),
      mediaSection("Definitions", wordDefinitions(word.word!)),
      const SizedBox(
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
