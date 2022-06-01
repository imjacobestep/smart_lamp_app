import 'package:flutter/material.dart';
import 'package:smart_lamp/main.dart';
import 'package:smart_lamp/pages/word_page.dart';

class Home extends StatefulWidget{

  @override
  HomeState createState() => HomeState();

}

class HomeState extends State<Home>{
  //vars
  List<String> words = ["apple", "banana", "car", "duck"];

  @override
  void initState(){
    super.initState();
  }

  Widget wordListing(String word, bool isLearned){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          word,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        IconButton(
          onPressed: (){
            toDetails(word, isLearned);
          },
          icon: Icon(Icons.chevron_right_sharp),
          iconSize: 32,
        )
      ],
    );
  }
  
  void toDetails(String word, bool isLearned){
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => WordPage(word: word, isLearned: isLearned,))
    );
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text("Hi, User!"),
        leading: Padding(
          padding: const EdgeInsets.all(5),
          child: CircleAvatar(
            radius: 40,
          ),
        ),
      ),
      body: ListView.separated(
          padding: const EdgeInsets.all(20),
          itemBuilder: (BuildContext context, int index){
            return wordListing(words[index], false);
          },
          separatorBuilder: (BuildContext context, int index) => const Divider(),
          itemCount: words.length
      ),
      /*body: Padding(
        padding: const EdgeInsets.all(20),
        child: wordPage(words[0], false),
      ),*/
      floatingActionButton: FloatingActionButton(
        onPressed: (){},
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }

}