import 'package:flutter/material.dart';
import 'package:smart_lamp/assets/theme.dart';
import 'package:smart_lamp/utilities.dart';

PreferredSizeWidget appBar(
    Widget left, String title, Color titleColor, Widget right) {
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
                    child: (title == "VocaLamp")
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
  return headerButton(Icons.arrow_back_outlined, surface, dark, () {
    Navigator.pop(context);
  }, context);
}

Widget headerSpeak(String word, BuildContext context) {
  return headerButton(Icons.volume_up_outlined, surface, dark, () {
    speakContent(word);
  }, context);
}

Widget headerProfile(BuildContext context) {
  return headerButton(
      Icons.account_circle_outlined, canvas, dark, () {}, context);
}

Widget headerLogo() {
  return Image.asset(
    "lib/assets/vl_icon.png",
    height: 50,
    width: 50,
  );
}

Widget headerButton(IconData icon, Color backgroundColor, Color iconColor,
    void Function() tapFunction, BuildContext context) {
  return ElevatedButton(
      style: ElevatedButton.styleFrom(
          foregroundColor: iconColor,
          backgroundColor: backgroundColor,
          shape: const CircleBorder()),
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
