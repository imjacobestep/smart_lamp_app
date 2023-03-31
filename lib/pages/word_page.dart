// ignore_for_file: must_be_immutable

import 'package:dart_openai/openai.dart';
import 'package:flutter/material.dart';
import 'package:flutter_profile_picture/flutter_profile_picture.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:owlbot_dart/owlbot_dart.dart';
import 'package:smart_lamp/models/ai.dart';
import 'package:smart_lamp/keys.dart';
import 'package:smart_lamp/pages/storybook.dart';
import 'package:smart_lamp/models/proxy.dart';
import 'package:smart_lamp/utilities.dart';
import 'package:smart_lamp/widgets/navbar.dart';
import 'package:smart_lamp/widgets/spacer.dart';
import 'package:smart_lamp/widgets/word_media.dart';
import 'package:smart_lamp/widgets/word_variant_card.dart';
import 'package:text_to_speech/text_to_speech.dart';
import 'package:smart_lamp/assets/theme.dart';

import '../models/word.dart';
import '../widgets/app_bar.dart';

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
              builder: (context) => Storybook(word: widget.word)));
    }, false));
    return fabBar(buttons, context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(headerBack(context), widget.word.word!,
          headerSpeak(widget.word.word!)),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
        child: wordMedia(widget.word),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: wordNav(),
    );
  }
}
