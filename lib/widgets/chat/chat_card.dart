import 'package:change_case/change_case.dart';
import 'package:flutter/material.dart';

import '../../assets/theme.dart';
import '../../pages/chat_page.dart';
import '../general/spacer.dart';
import '../word/word_variant_card.dart';
import 'chat_elements.dart';

Widget chatCard(
    String messageContent, bool isLoading, String word, BuildContext context) {
  return Card(
      child: InkWell(
    onTap: () {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ChatPage(
                    word: word,
                  )));
    },
    child: Padding(
      padding: const EdgeInsets.all(10),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        getProfilePic(word, true),
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
                  speakButton(messageContent, messageContent != "")
                ],
              ),
            ),
            chatBubble(
                isLoading,
                messageContent != "" ? messageContent : "Oops, no response!",
                context),
          ],
        )
      ]),
    ),
  ));
}
