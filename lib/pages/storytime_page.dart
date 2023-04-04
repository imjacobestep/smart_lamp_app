// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:page_flip/page_flip.dart';
import 'package:smart_lamp/assets/theme.dart';
import 'package:smart_lamp/models/ai.dart';
import 'package:smart_lamp/models/proxy.dart';
import 'package:status_bar_control/status_bar_control.dart';
import 'package:text_to_speech/text_to_speech.dart';

import '../models/story_book.dart';
import '../models/word.dart';
import '../widgets/general/app_bar.dart';
import '../widgets/story/book_widget.dart';

class StoryTimePage extends StatefulWidget {
  @override
  StoryTimePageState createState() => StoryTimePageState();

  Word word;
  Proxy proxyModel = Proxy();
  Future<dynamic>? statusbarControl;

  Future<StoryBook>? storybook;

  StoryTimePage({super.key, required this.word});
}

class StoryTimePageState extends State<StoryTimePage> {
  //vars
  TextToSpeech tts = TextToSpeech();
  final controller = GlobalKey<PageFlipWidgetState>();

  @override
  void initState() {
    super.initState();
    widget.storybook = generateStory(widget.word.word!);
    widget.statusbarControl = StatusBarControl.setNavigationBarColor(dark);
    widget.statusbarControl =
        StatusBarControl.setNavigationBarStyle(NavigationBarStyle.DARK);
  }

  Widget bookWrapper() {
    return Scaffold(
      backgroundColor: dark,
      body: SafeArea(
        bottom: false,
        child: bookWidget(widget.word.word!, controller),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: dark,
      appBar: appBar(
        ElevatedButton(
            style: headerButtonStyle(dark, surface),
            onPressed: () {
              Navigator.pop(context);
            },
            child: headerButtonContent(Icons.close_outlined)),
        "",
        surface,
        headerButton(
            Icons.more_horiz_outlined, dark, surface, (context) {}, context),
      ),
      body: bookWrapper(),
    );
  }
}
