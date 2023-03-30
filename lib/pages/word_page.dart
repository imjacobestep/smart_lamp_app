// ignore_for_file: must_be_immutable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dart_openai/openai.dart';
import 'package:flutter/material.dart';
import 'package:flutter_profile_picture/flutter_profile_picture.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:owlbot_dart/owlbot_dart.dart';
import 'package:smart_lamp/ai.dart';
import 'package:smart_lamp/keys.dart';
import 'package:smart_lamp/pages/storybook.dart';
import 'package:smart_lamp/proxy.dart';
import 'package:text_to_speech/text_to_speech.dart';
import 'package:url_launcher/url_launcher.dart';
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
  //vars
  TextToSpeech tts = TextToSpeech();

  VLTheme? theme;

  final OwlBot owlBot = OwlBot(token: dictionaryKey);

  @override
  void initState() {
    theme = VLTheme(context: context);
    super.initState();
  }

  void markLearned() {}

  Widget variant(String partOfSpeech, String definition, String example) {
    List<Widget> children = [];

    if (partOfSpeech != "-") {
      children.add(
        Text(
          partOfSpeech,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      );
      children.add(const Divider());
    }
    if (definition != "-") {
      children.add(Text(
        "definition",
        style: Theme.of(context).textTheme.labelMedium,
      ));
      children.add(singleDefinition(definition));
    }
    if (example != "-") {
      children.add(const SizedBox(
        height: 8,
      ));
      children.add(Text(
        "example",
        style: Theme.of(context).textTheme.labelMedium,
      ));
      children.add(singleDefinition(example));
    }

    return Card(
      elevation: 0,
      color: Theme.of(context).colorScheme.background,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: children,
        ), //definition,
      ),
    );
  }

  Widget singleDefinition(definition) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            definition ?? "no definition",
            maxLines: 10,
            overflow: TextOverflow.ellipsis,
            softWrap: false,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
        IconButton(
          onPressed: () {
            tts.speak(definition);
          },
          style: Theme.of(context).outlinedButtonTheme.style,
          icon: const Icon(Icons.volume_up_sharp),
        )
      ],
    );
  }

  Future<String> getGPT() async {
    String word = widget.word.word!;
    String prompt = "Tell me about $word";
    String engineering =
        "I want you to act as an elementary school teacher. I will ask you to tell me about a word and you will explain the word to me as if I am a young child. Your responses are not longer than 20 words.";

    engineering =
        "I want you to pretend that you are the word '$word'. Explain yourself to me as if I were a small child learning about you for the first time. Your tone is friendly and playful and your responses are not longer than 30 words. You do not prompt further responses from me.";
    prompt = "Hi there, who are you?";

    OpenAIChatCompletionModel test =
        await OpenAI.instance.chat.create(model: "gpt-3.5-turbo", messages: [
      OpenAIChatCompletionChoiceMessageModel(
          role: 'system', content: engineering),
      OpenAIChatCompletionChoiceMessageModel(role: 'user', content: prompt)
    ]);

    return test.choices.first.message.content;
  }

  Future<String> getPic() async {
    String word = widget.word.word!;

    final image = await OpenAI.instance.image
        .create(prompt: word, n: 1, size: OpenAIImageSize.size256);

    return image.data.first.url;
  }

  Widget staticPic() {
    return Container(
      height: 60,
      width: 60,
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primaryContainer,
          shape: BoxShape.circle),
      child: Center(
        child: Text(
          "CG",
          style: TextStyle(color: Colors.black.withAlpha(100), fontSize: 20),
        ),
      ),
    );
  }

  Widget chatBubble(String text) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceVariant,
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(6),
              topRight: Radius.circular(24),
              bottomLeft: Radius.circular(24),
              bottomRight: Radius.circular(24))),
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.8,
        ),
        child: Text(
          text,
          style: const TextStyle(color: Colors.black, fontSize: 16),
        ),
      ),
    );
  }

  Widget chatView(String message) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        profilePic(),
        // staticPic(),
        const SizedBox(
          height: 10,
        ),
        chatBubble(message)
      ],
    );
  }

  Widget profilePic() {
    return FutureBuilder(
        future: getPic(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            return ProfilePicture(
              name: "Chat GPT",
              radius: 31,
              fontsize: 21,
              img: snapshot.data,
            );
          } else {
            return const ProfilePicture(
                name: "Loading", radius: 31, fontsize: 21);
          }
        });
  }

  Widget gptLoader() {
    OpenAI.apiKey = aiKey;

    return FutureBuilder(
      future: generateMessage(widget.word.word!),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasData && snapshot.data != null) {
          return chatView(snapshot.data);
        } else if (snapshot.hasData) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: Text("No response"),
            ),
          );
        } else {
          return SpinKitRing(
            size: 40,
            lineWidth: 8,
            color: Theme.of(context).primaryColor,
          );
        }
      },
    );
  }

  Widget detailsLoader() {
    return FutureBuilder(
      future: owlBot.define(word: widget.word.word),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasData && snapshot.data != null) {
          var word = snapshot.data;

          List<Widget> children2 = [
            gptLoader(),
            const SizedBox(
              height: 10,
            ),
          ];
          word.definitions.forEach(
            (element) {
              children2.add(variant(element.type, element.definition ?? '-',
                  element.example ?? '-'));
              children2.add(
                const SizedBox(
                  height: 10,
                ),
              );
            },
          );

          return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: children2);
        } else if (snapshot.hasData) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: Text("Word not found"),
            ),
          );
        } else {
          return SpinKitRing(
            size: 40,
            lineWidth: 8,
            color: Theme.of(context).primaryColor,
          );
        }
      },
    );
  }

  Widget definitionDetails(List<OwlBotDefinition> allDefinitions) {
    List<Widget> children = [
      Text(
        "definitions",
        style: Theme.of(context).textTheme.labelMedium,
      ),
      const SizedBox(
        height: 8,
      ),
    ];

    for (var element in allDefinitions) {
      children.add(singleDefinition(element.definition));
      children.add(
        const SizedBox(
          height: 10,
        ),
      );
    }

    return Card(
      elevation: 0,
      color: Theme.of(context).colorScheme.inverseSurface,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: children,
        ), //definition,
      ),
    );
  }

  Widget usageDetails(List<OwlBotDefinition> allExamples) {
    List<Widget> children = [
      Text(
        "used in a sentence",
        style: Theme.of(context).textTheme.labelMedium,
      ),
      const SizedBox(
        height: 8,
      ),
    ];

    for (var element in allExamples) {
      children.add(singleDefinition(element.example));
      children.add(
        const SizedBox(
          height: 10,
        ),
      );
    }

    return Card(
      elevation: 0,
      color: Theme.of(context).colorScheme.surfaceVariant,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: children,
        ), //definition,
      ),
    );
  }

  Widget wordPage() {
    return ListView(
      children: [
        detailsLoader(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("  see more"),
            Row(
              children: [
                ActionChip(
                  label: const Text("definitions"),
                  onPressed: () => _launchUrl(Uri.parse(
                      "https://www.google.com/search?q=${widget.word}+definition")),
                ),
                const SizedBox(
                  width: 5,
                ),
                ActionChip(
                  onPressed: () => _launchUrl(Uri.parse(
                      "https://www.google.com/search?tbm=isch&q=${widget.word}")),
                  label: const Text("images"),
                ),
                const SizedBox(
                  width: 5,
                ),
                ActionChip(
                  onPressed: () => _launchUrl(Uri.parse(
                      "https://www.google.com/search?tbm=vid&q=${widget.word}+definition")),
                  label: const Text("videos"),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Future<void> _launchUrl(url) async {
    if (!await launchUrl(url)) {
      throw 'Could not launch $url';
    }
  }

  Widget getFab(bool isLearned) {
    if (!isLearned) {
      return FloatingActionButton.extended(
        onPressed: () {
          DocumentReference docRef = FirebaseFirestore.instance
              .collection("words")
              .doc(widget.word.id);
          var updateInfo = {'learned': true};
          docRef.update(updateInfo);
          Navigator.pop(context);
        },
        tooltip: 'learned',
        label: const Text('mark as learned'),
        icon: const Icon(Icons.done),
      );
    } else {
      return const SizedBox();
    }
  }

  Widget fabButtons(bool isLearned) {
    List<Widget> buttons = [
      const SizedBox(
        width: 10,
      )
    ];
    if (!isLearned) {
      buttons.add(ElevatedButton(
        style: ElevatedButton.styleFrom(
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          // ignore: prefer_const_constructors
          backgroundColor: Color(0xff1a1a1a),
          foregroundColor: Theme.of(context).colorScheme.surfaceVariant,
        ),
        onPressed: () {
          DocumentReference docRef = FirebaseFirestore.instance
              .collection("words")
              .doc(widget.word.id);
          var updateInfo = {'learned': true};
          docRef.update(updateInfo);
          Navigator.pop(context);
        },
        child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
            child: Row(
              children: const [
                Icon(
                  Icons.check_circle_outline_outlined,
                  size: 30,
                ),
                SizedBox(
                  width: 10,
                ),
                Text('Learned')
              ],
            )),
      ));
      buttons.add(const SizedBox(
        width: 10,
      ));
    }
    buttons.add(ElevatedButton(
      style: ElevatedButton.styleFrom(
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        foregroundColor: const Color(0xff1a1a1a),
        backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
      ),
      onPressed: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Storybook(word: widget.word)));
      },
      child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
          child: Row(
            children: const [
              Icon(
                Icons.bedtime_outlined,
                size: 30,
              ),
              SizedBox(
                width: 10,
              ),
              Text('Story Time')
            ],
          )),
    ));

    return Container(
      decoration:
          BoxDecoration(color: Theme.of(context).canvasColor.withAlpha(0)),
      child: Row(
        children: buttons,
      ),
    );
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

  Widget speakButton() {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
            foregroundColor: const Color(0xff1a1a1a),
            backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
            shape: const CircleBorder()),
        onPressed: () {
          tts.speak(widget.word.word!);
        },
        child: const SizedBox(
          height: 50,
          width: 50,
          child: Icon(
            Icons.volume_up_outlined,
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
            Expanded(flex: 1, child: speakButton()),
          ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(headerBack(context), widget.word.word!,
          headerSpeak(widget.word.word!, tts)),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
        child: wordPage(),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: fabButtons(widget.word.isLearned == 4),
    );
  }
}
