// ignore_for_file: avoid_print

import 'package:change_case/change_case.dart';
import 'package:chatview/chatview.dart';
import 'package:dart_openai/openai.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_lamp/models/store.dart';
import 'package:smart_lamp/models/story_book.dart';
import 'package:smart_lamp/models/story_page.dart';
import '../../keys.dart';

Future<String> generateMessage(String word) async {
  SharedPreferences prefs = await getPrefs();
  return prefs.getBool("Use AI text")!
      ? await generateText(
          "I want you to pretend that you are the word '$word'. Explain yourself to me as if I were a small child learning about you for the first time. Your tone is friendly and playful and your responses are not longer than 30 words. You do not prompt further responses from me.",
          "Hi there, who are you?")
      : "messageHere";
}

Future<String> generateText(String engineering, String prompt) async {
  List<OpenAIChatCompletionChoiceMessageModel> aiMessages = [
    OpenAIChatCompletionChoiceMessageModel(
        role: 'system', content: engineering),
    OpenAIChatCompletionChoiceMessageModel(role: 'user', content: prompt)
  ];

  return await generateTextResponse(aiMessages);
}

Future<String> generateTextResponse(
    List<OpenAIChatCompletionChoiceMessageModel> aiMessages) async {
  OpenAI.apiKey = aiKey;
  OpenAIChatCompletionModel model = await OpenAI.instance.chat
      .create(model: "gpt-3.5-turbo", messages: aiMessages);

  return model.choices.first.message.content;
}

Future<String> generatePic(String prompt) async {
  OpenAI.apiKey = aiKey;
  SharedPreferences prefs = await getPrefs();
  if (prefs.getBool("Use AI images")!) {
    final image = await OpenAI.instance.image
        .create(prompt: prompt, n: 1, size: OpenAIImageSize.size512);
    return image.data.first.url;
  } else {
    return "https://images.unsplash.com/photo-1504600770771-fb03a6961d33?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=882&q=80";
  }
}

Future<String> generateStoryTitle(String text) async {
  return await generateText(
      "", "Write a title for a children's book with the following text: $text");
}

Future<StoryBook> generateStory(String word) async {
  SharedPreferences prefs = await getPrefs();
  String response = prefs.getBool("Use AI text")!
      ? await generateText("",
          "Imagine I am a small child. Tell me a bedtime story about the word '$word'. Your response is 10 sentences long.")
      : "1. 2. 3. 4. 5.";

  List<String> text = response.split(".");

  List<StoryPage> pages = [];

  String title = prefs.getBool("Use AI text")!
      ? await generateStoryTitle(response)
      : "Placeholder Title";
  String cover = await generatePic(
      "Show me a cover illustration for a children's storybook titled: $title");

  for (int i = 0; i < text.length; i++) {
    if (i % 2 == 0) {
      print("//// FETCHING IMAGE ${i / 2} ////");

      String pageText = (i == text.length - 1)
          ? "${text[i]}."
          : "${text[i]}. ${text[i + 1]}.";

      String url = await generatePic(
          "Show me an illustration for a children's storybook to accompany the text: $pageText");
      pages.add(StoryPage(pageText, url));
    }
  }
  print("//// STORY GENERATION COMPLETE ////");
  return StoryBook(TitlePage(title, cover), pages);
}

List<OpenAIChatCompletionChoiceMessageModel> messagesToAI(
    List<Message> messages, String word) {
  List<OpenAIChatCompletionChoiceMessageModel> aiMessages = [
    OpenAIChatCompletionChoiceMessageModel(
        role: 'system',
        content:
            "I want you to pretend that you are the word '$word'. Explain yourself to me as if I were a small child learning about you for the first time. Your tone is friendly and playful and your responses are not longer than 30 words. You do not prompt further responses from me.")
  ];
  for (var message in messages) {
    String role = (message.sendBy != "2") ? "user" : "system";

    aiMessages.add(OpenAIChatCompletionChoiceMessageModel(
        role: role, content: message.message));
  }

  return aiMessages;
}
