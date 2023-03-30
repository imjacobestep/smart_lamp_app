import 'package:flutter/material.dart';
import 'package:smart_lamp/assets/theme.dart';

PreferredSizeWidget appBar(Widget left, String title, Widget right) {
  return AppBar(
      toolbarHeight: 80,
      centerTitle: true,
      leading: null,
      automaticallyImplyLeading: false,
      title: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(flex: 1, child: left),
              Expanded(
                flex: 3,
                child: Center(
                    child: (title == "Vocalamp")
                        ? homeTitle(title)
                        : pageTitle(title)),
              ),
              Expanded(flex: 1, child: right),
            ]),
      ));
}

Widget homeTitle(String title) {
  return Text(
    title,
    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 34),
  );
}

Widget pageTitle(String title) {
  return Text(title, style: const TextStyle(fontSize: 32));
}

Widget headerBack(BuildContext context) {
  return ElevatedButton(
      style: ElevatedButton.styleFrom(
          foregroundColor: black,
          backgroundColor: surface,
          shape: const CircleBorder()),
      onPressed: () {
        Navigator.pop(context);
      },
      child: const SizedBox(
        height: 50,
        width: 50,
        child: Icon(
          Icons.arrow_back,
          size: 30,
        ),
      ));
}

Widget headerSpeak(String word, dynamic tts) {
  return ElevatedButton(
      style: ElevatedButton.styleFrom(
          foregroundColor: black,
          backgroundColor: surface,
          shape: const CircleBorder()),
      onPressed: () {
        tts.speak(word);
      },
      child: const SizedBox(
        height: 50,
        width: 50,
        child: Icon(
          Icons.volume_up_outlined,
          size: 30,
        ),
      ));
}

Widget headerProfile() {
  return ElevatedButton(
      style: ElevatedButton.styleFrom(
          foregroundColor: black,
          backgroundColor: surface,
          shape: const CircleBorder()),
      onPressed: () {},
      child: const SizedBox(
        height: 50,
        width: 50,
        child: Icon(
          Icons.account_circle_outlined,
          size: 30,
        ),
      ));
}

Widget headerLogo() {
  return Image.asset(
    "assets/vl_icon.png",
    height: 50,
    width: 50,
  );
}
