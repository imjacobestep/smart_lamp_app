import 'package:flutter/material.dart';

Color dark = const Color(0xff373737);
Color canvas = const Color(0xffFCFBF7);
Color surface = const Color(0xffC8DECB);
Color accent = const Color(0xff0D7B58);

class VLTheme {
  BuildContext? context;
  Color black = const Color(0xff1a1a1a);
  Color white = Colors.white;
  Color accent = const Color(0xffe8defc);
  Color card = const Color(0xffe6e0eb);

  VLTheme({this.context});

  ButtonStyle primaryLongButtonTheme() {
    return ElevatedButton.styleFrom(
      // surfaceTintColor: Colors.transparent,
      elevation: 0,
      backgroundColor: black,
      foregroundColor: card,
      // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))
    );
  }

  ButtonStyle secondaryLongButtonTheme() {
    return ElevatedButton.styleFrom(
      // surfaceTintColor: Colors.transparent,
      elevation: 0,
      backgroundColor: card,
      foregroundColor: black,
      // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))
    );
  }

  ButtonStyle circularButtonTheme() {
    return ElevatedButton.styleFrom(
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        backgroundColor: card,
        foregroundColor: black,
        shape: const CircleBorder());
  }

  Widget spacer(double size, String axis) {
    return SizedBox(
      height: (axis == "horizontal") ? null : size,
      width: (axis == "vertical") ? null : size,
    );
  }

  Widget longButton(bool isPrimary, void Function() tapFunction, IconData icon,
      String label) {
    return ElevatedButton(
      style: isPrimary ? primaryLongButtonTheme() : secondaryLongButtonTheme(),
      onPressed: tapFunction,
      child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
          child: Row(
            children: [
              Icon(
                icon,
                size: 30,
              ),
              const SizedBox(
                width: 10,
              ),
              Text(label)
            ],
          )),
    );
  }
}
