import 'package:flutter/material.dart';
import 'package:smart_lamp/main.dart';
import 'package:smart_lamp/pages/home.dart';
import 'package:flutter_tts/flutter_tts.dart';

class WordPage extends StatefulWidget{

  @override
  WordPageState createState() => WordPageState();

  String word;
  bool isLearned;
  final flutterTts = FlutterTts();

  WordPage({required this.word, required this.isLearned});

}

class WordPageState extends State<WordPage>{
  //vars

  @override
  void initState(){
    super.initState();
  }



  Widget wordPage(String word, bool isLearned){
    return Column(

      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              word,
              style: Theme.of(context).textTheme.displaySmall,
            ),
            OutlinedButton(
              onPressed: () {},
              style: Theme.of(context).outlinedButtonTheme.style,
              child: const Icon(Icons.volume_up_sharp),
            )
          ],
        ),// word header
        const SizedBox(height: 20,),
        Card(
          elevation: 0,
          color: Theme.of(context).colorScheme.surfaceVariant,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text("definition", style: Theme.of(context).textTheme.headlineSmall,),
                const SizedBox(height: 8,),
                Text("This is the definition of the word.", style: Theme.of(context).textTheme.bodyMedium,),
              ],
            ),//definition,
          ),
        ),
        const SizedBox(height: 20,),
        Card(
          elevation: 0,
          color: Theme.of(context).colorScheme.surfaceVariant,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text("used in a sentence", style: Theme.of(context).textTheme.headlineSmall,),
                const SizedBox(height: 8,),
                Text("This is the word used in a sentence that helps contextualize it.", style: Theme.of(context).textTheme.bodyMedium,),
              ],
            ),//sentence
          ),
        ),
      ],
    );
  }

  Widget getFab(bool isLearned){
    if(!isLearned){
      return FloatingActionButton.extended(
        onPressed: (){},
        tooltip: 'learned',
        label: const Text('learned'),
        icon: const Icon(Icons.done),
      );
    }else return const SizedBox();
  }

  @override
  Widget build(BuildContext context){
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
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: wordPage(widget.word, widget.isLearned),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: getFab(widget.isLearned)
    );
  }

}