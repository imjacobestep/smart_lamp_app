// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:smart_lamp/models/proxy.dart';
import 'package:smart_lamp/pages/storytime_page.dart';
import 'package:smart_lamp/widgets/general/navbar.dart';
import 'package:smart_lamp/widgets/general/spacer.dart';
import 'package:smart_lamp/widgets/word/word_media.dart';

import '../assets/theme.dart';
import '../models/word.dart';
import '../widgets/general/app_bar.dart';

class WordPage extends StatefulWidget {
  @override
  WordPageState createState() => WordPageState();

  Word word;
  Proxy proxyModel = Proxy();

  WordPage({super.key, required this.word});
}

class WordPageState extends State<WordPage> {
  @override
  void initState() {
    super.initState();
  }

  Widget wordNav() {
    List<Widget> buttons = [];
    if (widget.word.isLearned! != 4) {
      buttons.add(navIcon("Learned", Icons.check_circle_outline_outlined, () {
        widget.word.markLearned();
      }, true));
      buttons.add(getSpacer(10));
    }
    buttons.add(navIcon("Story Time", Icons.bedtime_outlined, () {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => StoryTimePage(word: widget.word)));
    }, false));
    return fabBar(buttons, context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: canvas,
      appBar: appBar(headerBack(context), widget.word.word!, dark,
          headerSpeak(widget.word.word!, context)),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
        child: wordMedia(widget.word, context),
      ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      // floatingActionButton: wordNav(),
    );
  }
}
