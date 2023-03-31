import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:smart_lamp/assets/theme.dart';
import 'package:smart_lamp/models/ai.dart';

Widget chatBubble(bool loading, String content, BuildContext context) {
  return Container(
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
        color: surface,
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(2),
            topRight: Radius.circular(10),
            bottomLeft: Radius.circular(10),
            bottomRight: Radius.circular(10))),
    child: Container(
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * 0.49,
      ),
      child: loading
          ? SpinKitThreeBounce(
              size: 10,
              color: dark,
            )
          : Text(
              content,
              style: TextStyle(color: dark, fontSize: 16),
            ),
    ),
  );
}

Widget getProfilePic(String word, bool useAI) {
  return useAI
      ? FutureBuilder(
          future: generatePic(word),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.hasData && snapshot.data != null) {
              return profilePicture(snapshot.data, useAI, false);
            } else {
              return profilePicture(word, useAI, true);
            }
          })
      : profilePicture(word, useAI, false);
}

Widget profilePicture(String word, bool useAI, bool loading) {
  return Container(
    height: 100,
    width: 100,
    decoration: BoxDecoration(
        color: !useAI ? surface : null,
        image: useAI ? DecorationImage(image: NetworkImage(word)) : null,
        shape: BoxShape.circle),
    child: Center(
      child: loading
          ? SpinKitCircle(
              color: dark,
              size: 40,
            )
          : Text(
              useAI ? "" : "CG",
              style: TextStyle(color: dark, fontSize: 20),
            ),
    ),
  );
}
