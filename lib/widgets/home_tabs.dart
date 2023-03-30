import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:flutter/material.dart';
import 'package:smart_lamp/assets/theme.dart';

Widget tabView(TabController controller, List<Widget> tabContent,
    List<Widget> tabIndicators, BuildContext context) {
  return Padding(
    padding: const EdgeInsets.all(0.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 100,
          child: const Center(child: Text("Stuff")),
        ),
        Image.asset("lib/assets/book.png"),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          width: MediaQuery.of(context).size.width,
          color: canvas,
          child: homeTabs(controller, tabIndicators, context),
        ),
        Expanded(
          child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              color: canvas,
              child: TabBarView(controller: controller, children: tabContent)),
        )
      ],
    ),
  );
}

Widget homeTabs(TabController controller, List<Widget> tabIndicators,
    BuildContext context) {
  return ButtonsTabBar(
    controller: controller,
    backgroundColor: dark,
    labelStyle: TextStyle(color: surface, fontSize: 18),
    unselectedBackgroundColor: surface,
    unselectedLabelStyle: TextStyle(color: dark, fontSize: 18),
    radius: 100,
    contentPadding: const EdgeInsets.all(12),
    height: 60,
    tabs: tabIndicators,
  );
}

Widget tabIndicator(IconData icon, String label) {
  return Tab(
    icon: Icon(icon),
    text: label,
  );
}
