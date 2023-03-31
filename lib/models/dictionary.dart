import 'package:owlbot_dart/owlbot_dart.dart';
import 'package:smart_lamp/keys.dart';

Future<dynamic> getDefinitions(String word) async {
  final OwlBot owlBot = OwlBot(token: dictionaryKey);
  return owlBot.define(word: word);
}
