import 'package:flutter/material.dart';
import 'package:text_to_speech/text_to_speech.dart';
import 'package:url_launcher/url_launcher.dart';

bool showTablet(BuildContext context) {
  bool tabletWidth = MediaQuery.of(context).size.width >= 600 ? true : false;
  bool isLandscape =
      MediaQuery.of(context).orientation == Orientation.portrait ? false : true;

  return tabletWidth && isLandscape ? true : false;
}

Future<void> launchURL(url) async {
  if (!await launchUrl(url)) {
    throw 'Could not launch $url';
  }
}

Future<void> googleSearch(String word, String searchType) async {
  switch (searchType) {
    case "standard":
      launchURL(Uri.parse("https://www.google.com/search?q=$word"));
      break;
    case "definition":
      launchURL(Uri.parse("https://www.google.com/search?q=$word+definition"));
      break;
    case "images":
      launchURL(Uri.parse("https://www.google.com/search?tbm=isch&q=$word"));
      break;
    case "videos":
      launchURL(Uri.parse(
          "https://www.google.com/search?tbm=vid&q=$word+definition"));
      break;
    case "youtube":
      launchURL(Uri.parse("https://www.youtubekids.com/search?q=$word"));
      break;
    default:
  }
}

void speakContent(String content) {
  TextToSpeech tts = TextToSpeech();
  tts.speak(content);
}
