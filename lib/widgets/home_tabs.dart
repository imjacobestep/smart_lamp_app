import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:flutter/material.dart';
import 'package:smart_lamp/assets/theme.dart';

Widget tabView(TabController controller, List<Widget> tabContent,
    List<Widget> tabIndicators, BuildContext context) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      homeTabs(controller, tabIndicators, context),
      Expanded(child: TabBarView(controller: controller, children: tabContent))
    ],
  );
}

Widget homeTabs(TabController controller, List<Widget> tabIndicators,
    BuildContext context) {
  return ButtonsTabBar(
    controller: controller,
    backgroundColor: black,
    labelStyle: TextStyle(color: surface, fontSize: 18),
    unselectedBackgroundColor: surface,
    unselectedLabelStyle: TextStyle(color: black, fontSize: 18),
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
