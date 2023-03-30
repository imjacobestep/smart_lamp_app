import 'package:flutter/material.dart';
import 'package:smart_lamp/widgets/word_listing.dart';

import '../models/word.dart';

Widget learnWords(Future<Iterable<dynamic>> list) {
  return FutureBuilder(
      future: list,
      builder: (BuildContext context, AsyncSnapshot<Iterable> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data != null) {
            final data = snapshot.requireData.where((word) => word.showToday());
            return ListView.builder(
                padding: const EdgeInsets.all(20),
                itemCount: data.length,
                itemBuilder: (context, index) {
                  Word word = data.elementAt(index);
                  return wordListing(word, context);
                });
          } else {
            return const Text("You're all caught up!");
          }
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading");
        } else if (snapshot.hasError) {
          return const Text("Something went wrong");
        } else {
          // ignore: unnecessary_string_escapes
          return const Text("¯\_(ツ)_/¯");
        }
      });
}

Widget chronologicalList(Future<Iterable<dynamic>> list) {
  return FutureBuilder(
      future: list,
      builder: (BuildContext context, AsyncSnapshot<Iterable> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data != null) {
            final data = snapshot.requireData;
            return ListView.builder(
                padding: const EdgeInsets.all(20),
                itemCount: data.length,
                itemBuilder: (context, index) {
                  Word word = data.elementAt(index);
                  return wordListing(word, context);
                });
          } else {
            return const Text("No new words!");
          }
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading");
        } else if (snapshot.hasError) {
          return const Text("Something went wrong");
        } else {
          // ignore: unnecessary_string_escapes
          return const Text("¯\_(ツ)_/¯");
        }
      });
}
