import 'package:flutter/material.dart';
import 'package:smart_lamp/main.dart';
import 'package:smart_lamp/pages/home.dart';

class WordPage extends StatefulWidget{

  @override
  WordPageState createState() => WordPageState();

  String word;
  bool isLearned;

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
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              word,
              style: Theme.of(context).textTheme.displaySmall,
            ),
            OutlinedButton(
              onPressed: (){},
              child: Icon(Icons.volume_up_sharp),
              style: Theme.of(context).outlinedButtonTheme.style,
            )
          ],
        ),// word header
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text("definition", style: Theme.of(context).textTheme.headlineSmall,),
            Text("This is the definition of the word.", style: Theme.of(context).textTheme.bodyMedium,)
          ],
        ),//definition
        Column(
        ),//sentence
      ],
    );
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text("Details"),
        leading: Padding(
          padding: const EdgeInsets.all(5),
          child: CircleAvatar(
            radius: 40,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: wordPage(widget.word, widget.isLearned),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){},
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }

}