import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_flip/page_flip.dart';
import 'package:smart_lamp/assets/theme.dart';
import 'package:smart_lamp/models/ai.dart';
import 'package:smart_lamp/models/story_book.dart';
import 'package:smart_lamp/widgets/general/placeholder_text.dart';
import 'package:smart_lamp/widgets/story/page_widget.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../models/story_page.dart';

Widget bookWidget(String word, dynamic pageController) {
  return FutureBuilder(
      future: generateStory(word),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data == null) {
            //null data
            return listPlaceholder("Oops, no response from GPT",
                Icons.error_outline_outlined, surface);
          } else {
            return PageFlipWidget(
                key: pageController,
                backgroundColor: dark,
                showDragCutoff: true,
                lastPage: Container(
                  color: canvas,
                  child: Center(
                    child: Text(
                      "The End.",
                      style: TextStyle(
                          color: dark,
                          fontSize: 24,
                          fontFamily:
                              GoogleFonts.loveYaLikeASister().fontFamily),
                    ),
                  ),
                ),
                children: getPages(snapshot.requireData, pageController));
          }
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          //loading
          return listPlaceholder("Loading", Icons.cloud_sync_outlined, surface);
        } else if (snapshot.hasError) {
          //error
          return listPlaceholder("Oops, there was an error",
              Icons.error_outline_outlined, surface);
        } else {
          //unknown
          return listPlaceholder(
              // ignore: unnecessary_string_escapes
              "¯\_(ツ)_/¯",
              Icons.error_outline_outlined,
              surface);
        }
      });
}

List<Widget> getPages(StoryBook storyBook, dynamic pageController) {
  List<Widget> pageWidgets = [titlePage(storyBook.titlePage!, pageController)];
  for (int i = 0; i < storyBook.pages!.length; i++) {
    pageWidgets.add(storyPage(storyBook.pages!.elementAt(i), i,
        storyBook.pages!.length + 1, pageController));
  }
  return pageWidgets;
}
