import 'package:flutter/material.dart';
import 'package:smart_lamp/assets/theme.dart';
import 'package:smart_lamp/widgets/spacer.dart';

Widget listPlaceholder(String message, IconData icon) {
  return Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(
          icon,
          size: 48,
          color: dark,
        ),
        getSpacer(8),
        Text(
          message,
          style: TextStyle(fontSize: 24, color: dark),
        ),
      ],
    ),
  );
}
