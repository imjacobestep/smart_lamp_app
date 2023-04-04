import 'package:flutter/material.dart';
import 'package:smart_lamp/assets/theme.dart';
import 'package:smart_lamp/models/word.dart';
import 'package:smart_lamp/utilities.dart';
import 'package:smart_lamp/widgets/general/app_bar.dart';
import 'package:smart_lamp/widgets/general/spacer.dart';

Widget wordMediaSearch(Word word) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          searchShortcut(word, "general", "search", Icons.search_outlined),
          searchShortcut(word, "images", "images", Icons.image_outlined)
        ],
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          searchShortcut(
              word, "definitions", "definitions", Icons.menu_book_outlined),
          searchShortcut(word, "youtube", "videos", Icons.movie_outlined)
        ],
      )
    ],
  );
}

Widget searchShortcut(
    Word word, String searchType, String label, IconData icon) {
  return Expanded(
    child: Card(
      elevation: 0,
      color: Colors.transparent,
      child: InkWell(
        onTap: () => googleSearch(word.word!, searchType),
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
