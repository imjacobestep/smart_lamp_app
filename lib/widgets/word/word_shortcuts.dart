import 'package:flutter/material.dart';
import 'package:smart_lamp/widgets/word/word_media_search.dart';

import '../../assets/theme.dart';
import '../../models/word.dart';
import '../../pages/chat_page.dart';
import '../../pages/storytime_page.dart';
import '../../utilities.dart';
import '../general/app_bar.dart';
import '../general/spacer.dart';

Widget wordShortcuts(Word word, BuildContext context) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          shortcut(word, "Story Time", Icons.bedtime_outlined, context),
        ],
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          shortcut(word, "chat", Icons.chat_outlined, context),
          searchShortcut(word, "general", "search", Icons.search_outlined),
        ],
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          searchShortcut(word, "images", "images", Icons.image_outlined),
          searchShortcut(word, "youtube", "videos", Icons.movie_outlined)
        ],
      )
    ],
  );
}

Widget shortcut(Word word, String label, IconData icon, BuildContext context) {
  return Expanded(
    child: Card(
      elevation: 0,
      color: Colors.transparent,
      child: InkWell(
        onTap: label == "chat"
            ? () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ChatPage(
                              word: word.word!,
                            )));
              }
            : () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => StoryTimePage(word: word)));
              },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                decoration:
                    BoxDecoration(color: surface, shape: BoxShape.circle),
                child: headerButtonContent(icon),
              ),
              getSpacer(10),
              Text(
                label,
                style: TextStyle(color: dark, fontSize: 18),
              )
            ],
          ), //definition,
        ),
      ),
    ),
  );
}
