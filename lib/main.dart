import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:material_color_generator/material_color_generator.dart';
import 'package:smart_lamp/assets/theme.dart';
import 'package:smart_lamp/pages/home.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        useMaterial3: true,
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: generateMaterialColor(color: const Color(0xFF80E977)),
        // canvasColor: canvas,
        // scaffoldBackgroundColor: canvas,
        cardTheme: CardTheme(
          color: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: BorderSide(width: 2, color: surface)),
        ),
        appBarTheme: const AppBarTheme(
          surfaceTintColor: Colors.transparent,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(30))),
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.black,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
              surfaceTintColor: Colors.transparent,
              elevation: 0,
              foregroundColor: Colors.black,
              backgroundColor: const Color(0xFFFFC700)),
        ),
      ),
      // darkTheme: ThemeData.dark(
      //   useMaterial3: true,
      // ),
      themeMode: ThemeMode.light,
      debugShowCheckedModeBanner: false,
      home: Home(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<String> words = ["apple", "banana", "car", "duck"];

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
    });
  }

  Widget wordListing(String word, bool isLearned) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          word,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.chevron_right_sharp),
          iconSize: 32,
        )
      ],
    );
  }

  Widget wordPage(String word, bool isLearned) {
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
              onPressed: () {},
              style: Theme.of(context).outlinedButtonTheme.style,
              child: const Icon(Icons.volume_up_sharp),
            )
          ],
        ), // word header
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              "definition",
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            Text(
              "This is the definition of the word.",
              style: Theme.of(context).textTheme.bodyMedium,
            )
          ],
        ), //definition
        Column(), //sentence
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
        leading: const Padding(
          padding: EdgeInsets.all(5),
          child: CircleAvatar(
            radius: 40,
          ),
        ),
      ),
      body: ListView.separated(
          padding: const EdgeInsets.all(20),
          itemBuilder: (BuildContext context, int index) {
            return wordListing(words[index], false);
          },
          separatorBuilder: (BuildContext context, int index) =>
              const Divider(),
          itemCount: words.length),
      /*body: Padding(
        padding: const EdgeInsets.all(20),
        child: wordPage(words[0], false),
      ),*/
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
