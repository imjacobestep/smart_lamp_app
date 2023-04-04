import 'package:flutter/material.dart';
import 'package:smart_lamp/assets/theme.dart';
import 'package:smart_lamp/utilities.dart';

import '../../pages/settings_page.dart';

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
  return ElevatedButton(
      style: headerButtonStyle(surface, dark),
      onPressed: () {
        Navigator.pop(context);
      },
      child: headerButtonContent(Icons.arrow_back_outlined));
}

Widget headerSpeak(String word, BuildContext context) {
  return ElevatedButton(
      style: headerButtonStyle(surface, dark),
      onPressed: () {
        speakContent(word);
      },
      child: headerButtonContent(Icons.volume_up_outlined));
}

Widget headerProfile(BuildContext context) {
  return ElevatedButton(
      style: headerButtonStyle(canvas, dark),
      onPressed: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => SettingsPage()));
      },
      child: headerButtonContent(Icons.account_circle_outlined));
}

Widget headerLogo() {
  return Image.asset(
    "lib/assets/vl_icon.png",
    height: 50,
    width: 50,
  );
}

ButtonStyle headerButtonStyle(Color backgroundColor, Color iconColor) {
  return ElevatedButton.styleFrom(
      foregroundColor: iconColor,
      backgroundColor: backgroundColor,
      shape: const CircleBorder());
}

Widget headerButtonContent(IconData icon) {
  return SizedBox(
    height: 50,
    width: 50,
    child: Icon(
      icon,
      color: dark,
      size: 30,
    ),
  );
}

Widget headerButton(IconData icon, Color backgroundColor, Color iconColor,
    void Function(BuildContext context) tapFunction, BuildContext context) {
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
