import 'package:shared_preferences/shared_preferences.dart';

Future<SharedPreferences> getPrefs() async {
  final defaultSettings = {
    "Use AI images": false,
    "Use AI text": false,
  };

  SharedPreferences prefs = await SharedPreferences.getInstance();

  defaultSettings.forEach((key, value) {
    if (!prefs.containsKey(key)) {
      prefs.setBool(key, value);
    }
  });

  return prefs;
}
