// ignore_for_file: must_be_immutable

// import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:page_flip/page_flip.dart';
import 'package:smart_lamp/ai.dart';
import 'package:smart_lamp/proxy.dart';
import 'package:text_to_speech/text_to_speech.dart';

import '../models/word.dart';

class Storybook extends StatefulWidget {
  @override
  StorybookState createState() => StorybookState();

  Word word;
  Proxy proxyModel = Proxy();

  Future<Map<dynamic, dynamic>>? storybook;

  Storybook({super.key, required this.word});
}

class StorybookState extends State<Storybook> {
  //vars
  TextToSpeech tts = TextToSpeech();
  final _controller = GlobalKey<PageFlipWidgetState>();

  @override
  void initState() {
    super.initState();
    widget.storybook = generateStory(widget.word.word!);
  }

  Widget pageWidget(String text, String imageURL) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Image.network(imageURL),
        ),
        Container(
          color: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 24),
          child: Text(
            text,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
        )
      ],
    );
  }

  // Widget bookButton(bool forward) {
  //   return ElevatedButton(
  //       style: ElevatedButton.styleFrom(
  //           foregroundColor: const Color(0xff1a1a1a),
  //           backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
  //           shape: const CircleBorder()),
  //       onPressed: () {
  //         pageNumber = _controller.
  //         if (forward) {
  //           _controller.currentState?.goToPage(index)
  //         } else {}
  //       },
  //       child: const SizedBox(
  //         height: 50,
  //         width: 50,
  //         child: Icon(
  //           Icons.volume_up_outlined,
  //           size: 30,
  //         ),
  //       ));
  // }

  Widget bookWrapper() {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: bookWidget(),
      ),
    );
  }

  Widget bookWidget() {
    return FutureBuilder(
        future: widget.storybook,
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data == null) {
              return const Text("null data");
            } else {
              List<Widget> pages = [];
              Map<dynamic, dynamic> storybook = snapshot.data;
              for (var element in storybook.keys) {
                pages.add(pageWidget(element, storybook[element]));
              }

              return PageFlipWidget(
                  key: _controller,
                  backgroundColor: Colors.white,
                  showDragCutoff: true,
                  lastPage: Container(
                    color: Colors.white,
                    child: const Center(
                      child: Text("The End."),
                    ),
                  ),
                  children: pages);
            }
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: SpinKitRing(
                size: 40,
                lineWidth: 8,
                color: Theme.of(context).primaryColor,
              ),
            );
          } else if (snapshot.hasError) {
            return const Text("error");
          } else {
            return const Text("unknown");
          }
        });
  }

  Widget backButton() {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
            foregroundColor: const Color(0xff1a1a1a),
            backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
            shape: const CircleBorder()),
        onPressed: () {
          Navigator.pop(context);
        },
        child: const SizedBox(
          height: 50,
          width: 50,
          child: Icon(
            Icons.arrow_back,
            size: 30,
          ),
        ));
  }

  Widget header() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(flex: 1, child: backButton()),
            Expanded(
              flex: 3,
              child: Center(
                  child: Text(widget.word.word!,
                      style: const TextStyle(fontSize: 32))),
            ),
          ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        centerTitle: false,
        leading: null,
        automaticallyImplyLeading: false,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: header(),
      ),
      body: bookWrapper(),
    );
  }
}
