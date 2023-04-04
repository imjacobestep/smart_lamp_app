// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:smart_lamp/widgets/general/spacer.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:smart_lamp/widgets/settings/settings.dart';

import '../assets/theme.dart';
import '../widgets/general/app_bar.dart';

class SettingsPage extends StatefulWidget {
  @override
  SettingsPageState createState() => SettingsPageState();

  SettingsPage({super.key});
}

class SettingsPageState extends State<SettingsPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: canvas,
      appBar: appBar(headerBack(context), "Settings", dark, getSpacer(50)),
      body: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
          child: settingsList(context)),
    );
  }
}
