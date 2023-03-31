import 'package:flutter/material.dart';
import 'package:smart_lamp/widgets/spacer.dart';

import '../assets/theme.dart';

Widget navIcon(
    String label, IconData icon, void Function() tapFunction, bool isPrimary) {
  return ElevatedButton(
    style: ElevatedButton.styleFrom(
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      backgroundColor: isPrimary ? dark : surface,
      foregroundColor: isPrimary ? surface : dark,
    ),
    onPressed: tapFunction,
    child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
        child: Row(
          children: [
            Icon(
              icon,
              size: 30,
            ),
            getSpacer(10),
            Text(
              label,
              style: TextStyle(fontSize: 16),
            )
          ],
        )),
  );
}

Widget navBar(List<Widget> buttons, int currentIndex, BuildContext context) {
  return Container(
    color: canvas,
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
    width: MediaQuery.of(context).size.width,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.max,
      children: buttons,
    ),
  );
}

Widget fabBar(List<Widget> buttons, BuildContext context) {
  return Container(
    color: Colors.transparent,
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
    width: MediaQuery.of(context).size.width,
    child: Row(
      mainAxisSize: MainAxisSize.max,
      children: buttons,
    ),
  );
}
