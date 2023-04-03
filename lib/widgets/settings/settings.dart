import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_lamp/models/store.dart';

import '../../assets/theme.dart';
import '../general/placeholder_text.dart';

Widget settingsList(BuildContext context) {
  return FutureBuilder(
      future: getPrefs(),
      builder:
          (BuildContext context, AsyncSnapshot<SharedPreferences> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data != null) {
            //good return
            List<SettingsTile> tiles = [
              getTile(snapshot.requireData, "Use AI images", "Use AI images",
                  Icons.image_outlined),
              getTile(snapshot.requireData, "Use AI text", "Use AI text",
                  Icons.text_snippet_outlined)
            ];
            return SettingsList(sections: [
              SettingsSection(
                  title: Text(
                    "AI features",
                    style: TextStyle(color: dark),
                  ),
                  tiles: tiles)
            ]);
          } else {
            //bad return
            return listPlaceholder(
                "No new words", Icons.check_circle_outline_outlined, dark);
          }
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          //loading
          return listPlaceholder("Loading", Icons.cloud_sync_outlined, dark);
        } else if (snapshot.hasError) {
          //error
          return listPlaceholder(
              "Something went wrong", Icons.error_outline_outlined, dark);
        } else {
          return listPlaceholder(
              //unknown
              // ignore: unnecessary_string_escapes
              "¯\_(ツ)_/¯",
              Icons.error_outline_outlined,
              dark);
        }
      });
}

SettingsTile getTile(
    SharedPreferences prefs, String key, String label, IconData icon) {
  return SettingsTile.switchTile(
      onToggle: (value) {
        prefs.setBool(key, value);
      },
      initialValue: prefs.getBool(key) ?? false,
      leading: Icon(icon),
      title: Text(label, style: TextStyle(color: dark)));
}
