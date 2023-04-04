import 'package:change_case/change_case.dart';
import 'package:dart_openai/openai.dart';
import 'package:flutter/material.dart';
import 'package:smart_lamp/assets/theme.dart';
import 'package:smart_lamp/widgets/chat/chat_card.dart';
import 'package:smart_lamp/widgets/chat/chat_elements.dart';
import 'package:smart_lamp/widgets/general/spacer.dart';
import 'package:smart_lamp/widgets/word/word_variant_card.dart';

import '../../models/ai.dart';
import '../../pages/chat_page.dart';
import '../../keys.dart';

Widget gptMessage(String word, BuildContext context) {
  OpenAI.apiKey = aiKey;
  return FutureBuilder(
    future: generateMessage(word),
    builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
      return chatCard(
          (snapshot.hasData && snapshot.data != null) ? snapshot.data : "",
          snapshot.connectionState == ConnectionState.waiting,
          word,
          context);
    },
  );
}
