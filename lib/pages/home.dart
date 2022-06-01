import 'package:cloud_firestore/cloud_firestore.dart';
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
  int _selectedIndex = 0;
  final Stream<QuerySnapshot> wordStream = FirebaseFirestore.instance.collection('words').snapshots();
  final Stream<QuerySnapshot> luxStream = FirebaseFirestore.instance.collection('environment').snapshots();

  @override
  void initState(){
    super.initState();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget envDashboard(){
    return StreamBuilder<QuerySnapshot>(stream: luxStream, builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot,
        ){
      if (snapshot.hasError){
        return const Text("Something went wrong");
      }
      if (snapshot.connectionState == ConnectionState.waiting){
        return const Text("Loading");
      }
      final data = snapshot.requireData;
      return ListView.builder(
          padding: const EdgeInsets.all(20),
          itemCount: data.size,
          itemBuilder: (context, index){
            var reading = data.docs[index]['reading'];
            var meetsTarget = data.docs[index]['meets_target'];
            return envListing(reading, meetsTarget);
          }
      );
    }
    );
  }

  Widget learnedWordList(){
    return StreamBuilder<QuerySnapshot>(stream: wordStream, builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot,
        ){
      if (snapshot.hasError){
        return const Text("Something went wrong");
      }
      if (snapshot.connectionState == ConnectionState.waiting){
        return const Text("Loading");
      }
      final data = snapshot.requireData;
      return ListView.builder(
          padding: const EdgeInsets.all(20),
          itemCount: data.size,
          itemBuilder: (context, index){
            var word = data.docs[index]['word'];
            var isLearned = data.docs[index]['learned'];
            if(isLearned == true) {
              return learnedWord(word, isLearned);
            }else{
              return const SizedBox();
            }
          }
      );
    }
    );
  }

  Widget wordList(){
    return StreamBuilder<QuerySnapshot>(stream: wordStream, builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot,
        ){
      if (snapshot.hasError){
        return const Text("Something went wrong");
      }
      if (snapshot.connectionState == ConnectionState.waiting){
        return const Text("Loading");
      }
      final data = snapshot.requireData;
      return ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: data.size,
          itemBuilder: (context, index){
          var word = data.docs[index]['word'];
          var isLearned = data.docs[index]['learned'];
          //return Text(data.docs[index]['word']);
            if(isLearned == false) {
              return wordListing(word, isLearned);
            }else{
              return const SizedBox();
            }
          }
      );
    }
    );
  }

  Widget wordListing(String word, bool isLearned){
    return Card(
      elevation: 0,
      color: Theme.of(context).colorScheme.surfaceVariant,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
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
              icon: const Icon(Icons.chevron_right_sharp),
              iconSize: 32,
            )
          ],
        ),
      )
    );
  }

  Widget learnedWord(String word, bool isLearned){
    return Card(
        elevation: 0,
        color: Theme.of(context).colorScheme.surfaceVariant,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    word,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(width: 8,),
                  const Icon(Icons.done_sharp),
                ],
              ),
              IconButton(
                onPressed: (){
                  toDetails(word, isLearned);
                },
                icon: const Icon(Icons.chevron_right_sharp),
                iconSize: 32,
              )
            ],
          ),
        )
    );
  }

  Widget envListing(int reading, bool meetsTarget){
    if(meetsTarget){
      return Card(
          elevation: 0,
          color: Theme.of(context).colorScheme.surfaceVariant,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Text(reading.toString(), style: Theme.of(context).textTheme.headlineSmall,),
                const SizedBox(width: 8,),
                const Icon(Icons.flashlight_on_sharp)
              ],
            )
          )
      );
    }else{
      return Card(
          elevation: 0,
          color: Theme.of(context).colorScheme.surfaceVariant,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Text(reading.toString(), style: Theme.of(context).textTheme.headlineSmall,),
                const SizedBox(width: 8,),
                const Icon(Icons.flashlight_off_sharp)
              ],
            ),
          )
      );
    }
  }

  void toDetails(String word, bool isLearned){
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => WordPage(word: word, isLearned: isLearned,))
    );
  }

  Widget getView(int index){
    if(index == 1){
      return learnedWordList();
    }else if (index == 2){
      return envDashboard();
    }else{
      return wordList();
    }
  }

  PreferredSizeWidget appBar(){
    return AppBar(
      centerTitle: true,
      title: const Text("Hi, User!"),
      leading: const Padding(
        padding: EdgeInsets.all(10),
        child: CircleAvatar(
          radius: 40,
          backgroundImage: AssetImage("assets/user_pic.jpg"),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context){
    if(MediaQuery.of(context).size.width >= 600){
      return Scaffold(
        appBar: appBar(),
        body: Row(
          children: [
            NavigationRail(
              extended: MediaQuery.of(context).size.width >= 800,
              minExtendedWidth: 180,
              destinations: const [
                NavigationRailDestination(
                    icon: Icon(Icons.home_sharp),
                    label: Text("home")
                ),
                NavigationRailDestination(
                    icon: Icon(Icons.history_sharp),
                    label: Text("learned")
                ),
                NavigationRailDestination(
                    icon: Icon(Icons.light_sharp),
                    label: Text("lighting")
                ),
              ],
              selectedIndex: _selectedIndex,
              onDestinationSelected: _onItemTapped,
            ),
            Expanded(child: getView(_selectedIndex),),
          ],
        ),
      );
    }else{
      return Scaffold(
          appBar: appBar(),
          //body: getView(_selectedIndex),
          body: getView(_selectedIndex),
          bottomNavigationBar: NavigationBar(
            destinations: const [
              NavigationDestination(
                  icon: Icon(Icons.home_sharp),
                  label: "home"
              ),
              NavigationDestination(
                  icon: Icon(Icons.history_sharp),
                  label: "learned"
              ),
              NavigationDestination(
                  icon: Icon(Icons.light_sharp),
                  label: "lighting"
              ),
            ],
            selectedIndex: _selectedIndex,
            onDestinationSelected: _onItemTapped,
          )
      );
    }
  }

}