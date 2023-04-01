// ignore_for_file: unnecessary_string_escapes

import 'package:flutter/material.dart';
import 'package:smart_lamp/widgets/general/placeholder_text.dart';
import 'package:smart_lamp/widgets/home/word_listing.dart';

import '../../assets/theme.dart';
import '../../models/word.dart';
import '../../models/proxy.dart';

Widget learnWords(Proxy proxyModel) {
  return FutureBuilder(
      future: proxyModel.listWhere('words', 'learned', 4, "<"),
      builder: (BuildContext context, AsyncSnapshot<Iterable> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data != null) {
            final data = snapshot.requireData.where((word) => word.showToday());
            if (data.isNotEmpty) {
              return ListView.builder(
                  padding: const EdgeInsets.all(4),
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    Word word = data.elementAt(index);
                    return wordListing(word, context);
                  });
            } else {
              return listPlaceholder("You're all caught up!",
                  Icons.check_circle_outline_outlined, dark);
            }
          } else {
            return listPlaceholder(
                "No new words", Icons.check_circle_outline_outlined, dark);
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

Widget chronologicalList(Proxy proxyModel, bool learned) {
  return FutureBuilder(
      future: learned
          ? proxyModel.listWhere('words', 'learned', 4, "=")
          : proxyModel.listWhere('words', 'learned', 4, "<"),
      builder: (BuildContext context, AsyncSnapshot<Iterable> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data != null) {
            final data = snapshot.requireData;
            return ListView.builder(
                padding: const EdgeInsets.all(4),
                itemCount: data.length,
                itemBuilder: (context, index) {
                  Word word = data.elementAt(index);
                  return wordListing(word, context);
                });
          } else {
            return listPlaceholder(
                "No new words", Icons.check_circle_outline_outlined, dark);
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
