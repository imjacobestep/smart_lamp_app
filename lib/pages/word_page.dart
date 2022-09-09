import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
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

  @override
  void initState() {
    super.initState();
  }

  Widget wordPage() {
    widget.meaning ??= "meaning";
    widget.usage ??= "usage";
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(20),
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
        const SizedBox(
          height: 20,
        ),
        Card(
          elevation: 0,
          color: Theme.of(context).colorScheme.surfaceVariant,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  "definition",
                  style: Theme.of(context).textTheme.labelMedium,
                ),
                const SizedBox(
                  height: 8,
                ),
                //Text("This is the definition of the word.", style: Theme.of(context).textTheme.headlineSmall,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        widget.meaning,
                        maxLines: 10,
                        overflow: TextOverflow.ellipsis,
                        softWrap: false,
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        tts.speak(widget.meaning);
                      },
                      style: Theme.of(context).outlinedButtonTheme.style,
                      icon: const Icon(Icons.volume_up_sharp),
                    )
                  ],
                ),
              ],
            ), //definition,
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Card(
          elevation: 0,
          color: Theme.of(context).colorScheme.surfaceVariant,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  "used in a sentence",
                  style: Theme.of(context).textTheme.labelMedium,
                ),
                const SizedBox(
                  height: 8,
                ),
                //Text("This is the word used in a sentence that helps contextualize it.", style: Theme.of(context).textTheme.headlineSmall,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        widget.usage,
                        maxLines: 10,
                        overflow: TextOverflow.ellipsis,
                        softWrap: false,
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        tts.speak(widget.usage);
                      },
                      style: Theme.of(context).outlinedButtonTheme.style,
                      icon: const Icon(Icons.volume_up_sharp),
                    )
                  ],
                ),
              ],
            ), //sentence
          ),
        ),
        const SizedBox(
          height: 20,
        ),
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
        label: const Text('learned'),
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
          leading: const Padding(
            padding: EdgeInsets.all(10),
            child: CircleAvatar(
              radius: 30,
              backgroundColor: Colors.transparent,
              //backgroundImage: AssetImage("assets/user_pic.jpg"),
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: wordPage(),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: getFab(widget.isLearned));
  }
}
