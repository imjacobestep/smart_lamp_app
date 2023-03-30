import 'package:flutter/material.dart';

bool showTablet(BuildContext context) {
  bool tabletWidth = MediaQuery.of(context).size.width >= 600 ? true : false;
  bool isLandscape =
      MediaQuery.of(context).orientation == Orientation.portrait ? false : true;

  return tabletWidth && isLandscape ? true : false;
}
