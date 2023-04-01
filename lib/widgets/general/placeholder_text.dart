import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:smart_lamp/assets/theme.dart';
import 'package:smart_lamp/widgets/general/spacer.dart';

Widget listPlaceholder(String message, IconData icon, Color color) {
  return Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        message != "Loading"
            ? Icon(
                icon,
                size: 48,
                color: dark,
              )
            : SpinKitFadingFour(
                color: color,
              ),
        getSpacer(8),
        Text(
          message,
          style: TextStyle(fontSize: 24, color: color),
        ),
      ],
    ),
  );
}
