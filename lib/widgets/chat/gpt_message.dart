import 'package:change_case/change_case.dart';
import 'package:dart_openai/openai.dart';
import 'package:flutter/material.dart';
import 'package:smart_lamp/assets/theme.dart';
import 'package:smart_lamp/widgets/chat/chat_elements.dart';
import 'package:smart_lamp/widgets/general/spacer.dart';
import 'package:smart_lamp/widgets/word/word_variant_card.dart';

import '../../models/ai.dart';
import '../../keys.dart';

Widget gptMessage(String word) {
  OpenAI.apiKey = aiKey;
  return FutureBuilder(
    future: generateMessage(word),
    builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
      Widget messageContent;
      bool hasContent = false;
      if (snapshot.hasData && snapshot.data != null) {
        //result
        messageContent = chatBubble(false, snapshot.requireData, context);
        hasContent = true;
      } else if (snapshot.hasData) {
        //no result
        messageContent = chatBubble(false, "Oops, no response!", context);
      } else {
        //loading
        messageContent = chatBubble(true, "Oops, no response!", context);
      }
      return Card(
          child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          getProfilePic(word, false),
          getSpacer(10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.58,
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      word.toCapitalCase(),
                      style: TextStyle(fontSize: 18, color: dark),
                    ),
                    speakButton(hasContent ? snapshot.data : "", hasContent)
                  ],
                ),
              ),
              messageContent
            ],
          )
        ]),
      ));
    },
  );
}
