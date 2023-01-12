import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:owlbot_dart/owlbot_dart.dart';
import 'package:text_to_speech/text_to_speech.dart';
import 'package:url_launcher/url_launcher.dart';

class WordPage extends StatefulWidget {
  @override
  WordPageState createState() => WordPageState();

  String word;
  bool isLearned;
  String docID;
  String meaning;
  String usage;

  WordPage(
      {required this.word,
      required this.isLearned,
      required this.docID,
      required this.meaning,
      required this.usage});
}

class WordPageState extends State<WordPage> {
  //vars
  TextToSpeech tts = TextToSpeech();

  final OwlBot owlBot =
      OwlBot(token: "7d44c42271f690c92881e042e82805561355dc56");

  @override
  void initState() {
    super.initState();
  }

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
      color: Theme.of(context).colorScheme.surfaceVariant,
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

  Widget detailsLoader() {
    return FutureBuilder(
      future: owlBot.define(word: widget.word),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasData && snapshot.data != null) {
          var word = snapshot.data;

          List<Widget> children1 = [
            const SizedBox(
              height: 20,
            ),
            definitionDetails(word.definitions),
            const SizedBox(
              height: 20,
            ),
            usageDetails(word.definitions),
            const SizedBox(
              height: 20,
            ),
          ];

          List<Widget> children2 = [];
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
        } else {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: Text("Word not found"),
            ),
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

    allDefinitions.forEach(
      (element) {
        children.add(singleDefinition(element.definition));
        children.add(
          const SizedBox(
            height: 10,
          ),
        );
      },
    );

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

    allExamples.forEach(
      (element) {
        children.add(singleDefinition(element.example));
        children.add(
          const SizedBox(
            height: 10,
          ),
        );
      },
    );

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
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 16, 0, 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.word,
                style: Theme.of(context).textTheme.displaySmall,
              ),
              IconButton(
                onPressed: () {
                  tts.speak(widget.word);
                },
                padding: const EdgeInsets.all(15),
                style: Theme.of(context).outlinedButtonTheme.style,
                icon: const Icon(Icons.volume_up_sharp),
              )
            ],
          ),
        ), // word header
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

  Future<void> _launchUrl(_url) async {
    if (!await launchUrl(_url)) {
      throw 'Could not launch $_url';
    }
  }

  Widget getFab(bool isLearned) {
    if (!isLearned) {
      return FloatingActionButton.extended(
        onPressed: () {
          DocumentReference docRef =
              FirebaseFirestore.instance.collection("words").doc(widget.docID);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: const Text("Details"),
        ),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
          child: wordPage(),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: getFab(widget.isLearned));
  }
}
