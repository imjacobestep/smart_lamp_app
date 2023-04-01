// ignore_for_file: unnecessary_string_escapes

import 'package:flutter/material.dart';
import 'package:smart_lamp/models/dictionary.dart';
import 'package:smart_lamp/widgets/general/placeholder_text.dart';
import 'package:smart_lamp/widgets/general/spacer.dart';
import 'package:smart_lamp/widgets/word/word_variant_card.dart';

import '../../assets/theme.dart';

Widget wordDefinitions(String word) {
  return FutureBuilder(
      future: getDefinitions(word),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data != null) {
            final data = snapshot.requireData;
            List<Widget> variants = [];
            data.definitions.forEach(
              (element) {
                variants.add(wordVariant(element.type,
                    element.definition ?? "-", element.example ?? "-"));
                variants.add(
                  getSpacer(10),
                );
              },
            );
            return ListView(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              children: variants,
            );
          } else {
            return listPlaceholder(
                "No variants found", Icons.check_circle_outline_outlined, dark);
          }
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return listPlaceholder("Loading", Icons.cloud_sync_outlined, dark);
        } else if (snapshot.hasError) {
          return listPlaceholder(
              "Something went wrong", Icons.error_outline_outlined, dark);
        } else {
          return listPlaceholder(
              "¯\_(ツ)_/¯", Icons.error_outline_outlined, dark);
        }
      });
}
