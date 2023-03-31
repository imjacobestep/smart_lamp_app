import 'package:change_case/change_case.dart';
import 'package:flutter/material.dart';
import 'package:smart_lamp/utilities.dart';
import 'package:smart_lamp/widgets/spacer.dart';

import '../assets/theme.dart';

Widget wordVariant(
  String partOfSpeech,
  String definition,
  String example,
) {
  List<Widget> children = [];
  if (partOfSpeech != "-") {
    children.add(
      Text(
        partOfSpeech,
        style:
            TextStyle(fontSize: 20, color: dark, fontWeight: FontWeight.w400),
      ),
    );
    children.add(Divider(
      color: surface,
    ));
  }
  if (definition != "-") {
    children.add(detailLabel("definition"));
    children.add(detailContent(definition));
  }
  if (example != "-") {
    children.add(getSpacer(8));
    children.add(detailLabel("example"));
    children.add(detailContent(example.toSentenceCase()));
  }
  return Card(
    elevation: 0,
    color: Colors.transparent,
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: children,
      ), //definition,
    ),
  );
}

Widget detailLabel(String label) {
  return Text(
    label,
    style: TextStyle(fontSize: 14, color: dark, fontWeight: FontWeight.w500),
  );
}

Widget detailContent(String content) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Expanded(
        child: Text(
          content,
          maxLines: 10,
          overflow: TextOverflow.ellipsis,
          softWrap: false,
          style: TextStyle(fontSize: 14, color: dark),
        ),
      ),
      speakButton(content, true)
    ],
  );
}

Widget speakButton(String content, bool enabled) {
  return IconButton(
    onPressed: () {
      if (enabled) {
        speakContent(content);
      }
    },
    style: IconButton.styleFrom(),
    icon: const Icon(Icons.volume_up_sharp),
  );
}
