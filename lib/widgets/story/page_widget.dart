import 'package:flutter/material.dart';
import 'package:smart_lamp/utilities.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../assets/theme.dart';
import '../../models/story_page.dart';

Widget titlePage(TitlePage titlePage, dynamic pageController) {
  Widget titleHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
          color: canvas,
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(40), topRight: Radius.circular(10))),
      child: Row(
          // mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "",
              style: TextStyle(color: dark, fontSize: 14),
            )
          ]),
    );
  }

  Widget titleContent(String title, String image) {
    return Expanded(
      child: Column(
        children: [
          Expanded(
            child: Image.network(image),
          ),
          Expanded(
              child: Container(
                  height: 140,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                      color: canvas,
                      borderRadius: const BorderRadius.only(
                          bottomRight: Radius.circular(10))),
                  child: Center(
                    child: Text(
                      title,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: dark,
                          fontSize: 32,
                          fontFamily:
                              GoogleFonts.loveYaLikeASister().fontFamily),
                    ),
                  )))
        ],
      ),
    );
  }

  return Expanded(
      child: Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      titleHeader(),
      titleContent(titlePage.title!, titlePage.imageURL!),
      pageControls(titlePage.title!, 1, 6, pageController)
    ],
  ));
}

Widget storyPage(StoryPage storyPage, int pageNumber, int totalPages,
    dynamic pageController) {
  Widget pageHeader(int pageNumber, int totalPages) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
          color: canvas,
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(40), topRight: Radius.circular(10))),
      child: Row(
          // mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "$pageNumber/$totalPages",
              style: TextStyle(color: dark, fontSize: 14),
            )
          ]),
    );
  }

  Widget pageContent(String text, String image) {
    return Expanded(
      child: Column(
        children: [
          Expanded(
            child: Image.network(image),
          ),
          Expanded(
              child: Container(
                  height: 140,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                      color: canvas,
                      borderRadius: const BorderRadius.only(
                          bottomRight: Radius.circular(10))),
                  child: Center(
                    child: Text(
                      text,
                      style: TextStyle(
                          color: dark,
                          fontSize: 16,
                          fontFamily: GoogleFonts.balsamiqSans().fontFamily),
                    ),
                  )))
        ],
      ),
    );
  }

  return Expanded(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        pageHeader(pageNumber, totalPages),
        pageContent(storyPage.text!, storyPage.imageURL!),
        pageControls(storyPage.text!, pageNumber, totalPages, pageController)
      ],
    ),
  );
}

Widget pageControls(
    String text, int pageNumber, int totalPages, dynamic pageController) {
  return Container(
    decoration: BoxDecoration(
        color: dark,
        borderRadius: const BorderRadius.only(topLeft: Radius.circular(40))),
    padding: const EdgeInsets.all(40),
    child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        // mainAxisSize: MainAxisSize.max,
        children: [
          // pageButton(Icons.arrow_back_outlined, () {
          //   if (pageNumber != 1) {
          //     pageController.currentState?.goToPage(pageNumber - 2);
          //   }
          // }, false),
          // pageButton(Icons.volume_up_outlined, () {
          //   speakContent(text);
          // }, true),
          // pageButton(Icons.arrow_forward_outlined, () {
          //   if (pageNumber < totalPages) {
          //     pageController.currentState?.goToPage(pageNumber + 1);
          //   }
          // }, false)
          ElevatedButton(
              onPressed: () {
                if (pageNumber != 1) {
                  pageController.currentState?.goToPage(pageNumber - 2);
                }
              },
              style: pageButtonStyle(false),
              child: pageButtonContent(Icons.arrow_back_outlined)),
          ElevatedButton(
              onPressed: () {
                speakContent(text);
              },
              style: pageButtonStyle(true),
              child: pageButtonContent(Icons.volume_up_outlined)),
          ElevatedButton(
              onPressed: () {
                if (pageNumber < totalPages) {
                  pageController.currentState?.goToPage(pageNumber);
                }
              },
              style: pageButtonStyle(false),
              child: pageButtonContent(Icons.arrow_forward_outlined))
        ]),
  );
}

ButtonStyle pageButtonStyle(bool isPrimary) {
  return ElevatedButton.styleFrom(
      foregroundColor: isPrimary ? dark : surface,
      backgroundColor: isPrimary ? surface : dark,
      shape: CircleBorder(
          side: BorderSide(width: isPrimary ? 0 : 2, color: surface)));
}

Widget pageButtonContent(IconData icon) {
  return SizedBox(
    height: 50,
    width: 50,
    child: Icon(
      icon,
      size: 30,
    ),
  );
}

Widget pageButton(IconData icon, void Function() tapFunction, bool isPrimary) {
  return ElevatedButton(
      style: ElevatedButton.styleFrom(
          foregroundColor: isPrimary ? dark : surface,
          backgroundColor: isPrimary ? surface : dark,
          shape: CircleBorder(
              side: BorderSide(width: isPrimary ? 0 : 2, color: surface))),
      onPressed: () => tapFunction,
      child: SizedBox(
        height: 50,
        width: 50,
        child: Icon(
          icon,
          size: 30,
        ),
      ));
}
