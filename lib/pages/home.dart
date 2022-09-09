import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:smart_lamp/pages/word_page.dart';

class Home extends StatefulWidget {
  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
  //vars
  List<String> titles = ["New Words", "Learned Words", "Lighting"];
  int _selectedIndex = 0;
  final Stream<QuerySnapshot> wordStream =
      FirebaseFirestore.instance.collection('words').snapshots();
  final Stream<QuerySnapshot> luxStream =
      FirebaseFirestore.instance.collection('environment').snapshots();

  @override
  void initState() {
    super.initState();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget envDashboard() {
    return StreamBuilder<QuerySnapshot>(
        stream: luxStream,
        builder: (
          BuildContext context,
          AsyncSnapshot<QuerySnapshot> snapshot,
        ) {
          if (snapshot.hasError) {
            return const Text("Something went wrong");
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text("Loading");
          }
          final data = snapshot.requireData;
          return ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: data.size,
              itemBuilder: (context, index) {
                double reading = data.docs[index]['reading'];
                var meetsTarget = data.docs[index]['meets_target'];
                return envListing(reading, meetsTarget);
              });
        });
  }

  Widget envDashboard2() {
    return StreamBuilder<QuerySnapshot>(
        stream: luxStream,
        builder: (
          BuildContext context,
          AsyncSnapshot<QuerySnapshot> snapshot,
        ) {
          if (snapshot.hasError) {
            return const Text("Something went wrong");
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text("Loading");
          }
          final data = snapshot.requireData;
          /*return ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: data.size,
              itemBuilder: (context, index) {
                double reading = data.docs[index]['reading'];
                var meetsTarget = data.docs[index]['meets_target'];
                return envTile(reading, meetsTarget);
              });*/
          return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                //childAspectRatio: 1 / 1,
                crossAxisCount: 8,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: data.size,
              padding: const EdgeInsets.all(20),
              itemBuilder: (context, index) {
                double reading = data.docs[index]['reading'];
                var meetsTarget = data.docs[index]['meets_target'];
                return envTile(reading, meetsTarget);
              });
        });
  }

  Future envPopup(double reading, int meetsTarget) async {
    String targetText = meetsTarget == 1 ? "Adequate" : "Too Dim";
    TextStyle targetStyle = meetsTarget == 1
        ? TextStyle(color: Theme.of(context).colorScheme.primary)
        : TextStyle(color: Theme.of(context).colorScheme.error);
    Color bgColor = meetsTarget == 1
        ? Theme.of(context).colorScheme.primary.withAlpha(50)
        : Theme.of(context).colorScheme.error.withAlpha(50);
    Color goodTile = Theme.of(context).colorScheme.primaryContainer;
    Color badTile = Theme.of(context).colorScheme.errorContainer;
    Color bG =
        Color.alphaBlend(bgColor, Theme.of(context).dialogBackgroundColor);

    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.transparent,
            content: Stack(
              alignment: Alignment.center,
              //mainAxisSize: MainAxisSize.min,
              clipBehavior: Clip.none,
              children: [
                Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: bG, borderRadius: BorderRadius.circular(20)),
                  width: double.infinity,
                  height: 200,
                  child: Text(
                    targetText,
                    style: targetStyle,
                    textScaleFactor: 2,
                  ),
                ),
                Positioned(
                  top: -50,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    alignment: Alignment.center,
                    //margin: const EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                        color: meetsTarget == 1 ? goodTile : badTile,
                        borderRadius: BorderRadius.circular(20)),
                    width: 100.0,
                    height: 100.0,
                    child: Text(
                      reading.toString(),
                      style: TextStyle(
                        color: Colors.white.withAlpha(150),
                      ),
                      textScaleFactor: 2,
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }

  Widget envTile(double reading, int meetsTarget) {
    Color goodTile = Theme.of(context).colorScheme.primaryContainer;
    Color badTile = Theme.of(context).colorScheme.errorContainer;

    return InkWell(
      onTap: () {
        envPopup(reading, meetsTarget);
      },
      child: Container(
        padding: const EdgeInsets.all(2),
        alignment: Alignment.center,
        child: Text(
          reading.toString(),
          style: TextStyle(color: Colors.white.withAlpha(150)),
        ),
        //margin: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
            color: meetsTarget == 1 ? goodTile : badTile,
            borderRadius: BorderRadius.circular(4)),
        width: 20.0,
        height: 20.0,
      ),
    );
  }

  Widget learnedWordList() {
    return StreamBuilder<QuerySnapshot>(
        stream: wordStream,
        builder: (
          BuildContext context,
          AsyncSnapshot<QuerySnapshot> snapshot,
        ) {
          if (snapshot.hasError) {
            return const Text("Something went wrong");
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text("Loading");
          }
          final data = snapshot.requireData;
          return ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: data.size,
              itemBuilder: (context, index) {
                var word = data.docs[index]['word'];
                var isLearned = data.docs[index]['learned'];
                var docID = data.docs[index].id;
                var meaning = data.docs[index]['definition'];
                var usage = data.docs[index]['use'];
                if (isLearned == true) {
                  return learnedWord(word, isLearned, docID, meaning, usage);
                } else {
                  return const SizedBox();
                }
              });
        });
  }

  Widget wordList() {
    return StreamBuilder<QuerySnapshot>(
        stream: wordStream,
        builder: (
          BuildContext context,
          AsyncSnapshot<QuerySnapshot> snapshot,
        ) {
          if (snapshot.hasError) {
            return const Text("Something went wrong");
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text("Loading");
          }
          final data = snapshot.requireData;
          return ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: data.size,
              itemBuilder: (context, index) {
                var word = data.docs[index]['word'];
                var isLearned = data.docs[index]['learned'];
                var docID = data.docs[index].id;
                var meaning = data.docs[index]['definition'];
                var usage = data.docs[index]['use'];
                if (isLearned == false) {
                  return wordListing(word, isLearned, docID, meaning, usage);
                } else {
                  return const SizedBox();
                }
              });
        });
  }

  Widget wordListing(
      String word, bool isLearned, String docID, String meaning, String usage) {
    //
    return Card(
      elevation: 0,
      color: Theme.of(context).colorScheme.surfaceVariant,
      child: InkWell(
        onTap: () => toDetails(word, isLearned, docID, meaning, usage),
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
                onPressed: () {
                  toDetails(word, isLearned, docID, meaning, usage);
                },
                icon: const Icon(Icons.chevron_right_sharp),
                iconSize: 32,
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget learnedWord(
      String word, bool isLearned, String docID, String meaning, String usage) {
    return Card(
      elevation: 0,
      color: Theme.of(context).colorScheme.surfaceVariant,
      child: InkWell(
        onTap: () => toDetails(word, isLearned, docID, meaning, usage),
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
                  const SizedBox(
                    width: 8,
                  ),
                  Icon(
                    Icons.done_sharp,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ],
              ),
              IconButton(
                onPressed: () {
                  toDetails(word, isLearned, docID, meaning, usage);
                },
                icon: const Icon(Icons.chevron_right_sharp),
                iconSize: 32,
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget envListing(double reading, int meetsTarget) {
    if (meetsTarget == 1) {
      return Card(
          elevation: 0,
          color: Theme.of(context).colorScheme.primaryContainer.withAlpha(50),
          child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    reading.toString(),
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  Text(
                    "ideal",
                    style:
                        TextStyle(color: Theme.of(context).colorScheme.primary),
                  ),
                ],
              )));
    } else {
      return Card(
          elevation: 0,
          color: Theme.of(context).colorScheme.errorContainer.withAlpha(50),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  reading.toString(),
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                Text(
                  "too dim",
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              ],
            ),
          ));
    }
  }

  void toDetails(
      String word, bool isLearned, String docID, String meaning, String usage) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => WordPage(
                  word: word,
                  isLearned: isLearned,
                  docID: docID,
                  meaning: meaning,
                  usage: usage,
                )));
  }

  Widget getView(int index) {
    if (index == 1) {
      return learnedWordList();
    } else if (index == 2) {
      return envDashboard2();
    } else {
      return wordList();
    }
  }

  PreferredSizeWidget appBar() {
    return AppBar(
      centerTitle: true,
      title: Text(titles[_selectedIndex]),
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
  Widget build(BuildContext context) {
    if (MediaQuery.of(context).size.width >= 600) {
      return Scaffold(
        appBar: appBar(),
        body: Row(
          children: [
            NavigationRail(
              extended: MediaQuery.of(context).size.width >= 800,
              minExtendedWidth: 180,
              destinations: const [
                NavigationRailDestination(
                    icon: Icon(Icons.home_sharp), label: Text("home")),
                NavigationRailDestination(
                    icon: Icon(Icons.history_sharp), label: Text("learned")),
                NavigationRailDestination(
                    icon: Icon(Icons.light_sharp), label: Text("lighting")),
              ],
              selectedIndex: _selectedIndex,
              onDestinationSelected: _onItemTapped,
            ),
            Expanded(
              child: getView(_selectedIndex),
            ),
          ],
        ),
      );
    } else {
      return Scaffold(
          appBar: appBar(),
          //body: getView(_selectedIndex),
          body: getView(_selectedIndex),
          bottomNavigationBar: NavigationBar(
            destinations: const [
              NavigationDestination(
                  icon: Icon(Icons.home_sharp), label: "home"),
              NavigationDestination(
                  icon: Icon(Icons.history_sharp), label: "learned"),
              NavigationDestination(
                  icon: Icon(Icons.light_sharp), label: "lighting"),
            ],
            selectedIndex: _selectedIndex,
            onDestinationSelected: _onItemTapped,
          ));
    }
  }
}
