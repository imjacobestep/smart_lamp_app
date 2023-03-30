// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:smart_lamp/assets/theme.dart';
import 'package:smart_lamp/widgets/home_lists.dart';
import 'package:smart_lamp/widgets/home_tabs.dart';
import 'package:smart_lamp/widgets/navbar.dart';
import 'package:status_bar_control/status_bar_control.dart';

import '../models/word.dart';
import '../proxy.dart';
import '../utilities.dart';
import '../widgets/app_bar.dart';
import '../widgets/environment.dart';
import '../widgets/word_listing.dart';

class Home extends StatefulWidget {
  Home({super.key});

  Proxy proxyModel = Proxy();
  Future<Iterable>? newWordList;
  Future<Iterable>? learnedWordList;
  Future<dynamic>? transparent;

  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> with TickerProviderStateMixin {
  //vars
  List<String> titles = ["New Words", "Learned Words", "Lighting"];
  int _selectedIndex = 0;
  final Stream<QuerySnapshot> wordStream =
      FirebaseFirestore.instance.collection('words').snapshots();
  final Stream<QuerySnapshot> luxStream =
      FirebaseFirestore.instance.collection('environment').snapshots();

  late TabController tabController;

  @override
  void initState() {
    super.initState();
    widget.transparent = StatusBarControl.setTranslucent(false);
    widget.transparent =
        StatusBarControl.setNavigationBarColor(canvas, animated: true);
    widget.transparent = StatusBarControl.setStyle(StatusBarStyle.DARK_CONTENT);
    tabController = TabController(length: 3, vsync: this, initialIndex: 0);
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget getView(int index) {
    List<Widget> tabs = [
      tabIndicator(Icons.school_outlined, "Learn"),
      tabIndicator(Icons.new_releases_outlined, "New"),
      tabIndicator(Icons.check_circle_outline_outlined, "Learned")
    ];
    List<Widget> tabContent = [
      learnWords(widget.proxyModel),
      chronologicalList(widget.proxyModel, false),
      chronologicalList(widget.proxyModel, true)
    ];

    if (index == 1) {
      return tabView(tabController, tabContent, tabs, context);
    } else if (index == 2) {
      return envDashboard2(luxStream, context);
    } else {
      return tabView(tabController, tabContent, tabs, context);
    }
  }

  Widget homeNavBar() {
    List<Widget> buttons = [
      navIcon("Words", Icons.feed_outlined, () => _onItemTapped(0),
          (_selectedIndex == 0)),
      navIcon("Stats", Icons.insights_outlined, () => _onItemTapped(1),
          (_selectedIndex == 1)),
      navIcon("Lighting", Icons.light_outlined, () => _onItemTapped(2),
          (_selectedIndex == 2))
    ];
    return navBar(buttons, _selectedIndex, context);
  }

  @override
  Widget build(BuildContext context) {
    if (showTablet(context)) {
      return DefaultTabController(
        length: 3,
        child: Scaffold(
          backgroundColor: surface,
          appBar: appBar(headerLogo(), "VocaLamp", headerProfile()),
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
        ),
      );
    } else {
      return Scaffold(
          backgroundColor: surface,
          appBar: appBar(headerLogo(), "VocaLamp", headerProfile()),
          //body: getView(_selectedIndex),
          body: getView(_selectedIndex),
          bottomNavigationBar: homeNavBar());
    }
  }
}
