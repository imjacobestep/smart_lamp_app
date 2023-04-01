// ignore_for_file: avoid_print

import 'package:change_case/change_case.dart';
import 'package:dart_openai/openai.dart';
import 'package:smart_lamp/models/story_book.dart';
import 'package:smart_lamp/models/story_page.dart';

Future<String> generateMessage(String word) async {
  String engineering =
      "I want you to pretend that you are the word '$word'. Explain yourself to me as if I were a small child learning about you for the first time. Your tone is friendly and playful and your responses are not longer than 30 words. You do not prompt further responses from me.";
  String prompt = "Hi there, who are you?";

  OpenAIChatCompletionModel model =
      await OpenAI.instance.chat.create(model: "gpt-3.5-turbo", messages: [
    OpenAIChatCompletionChoiceMessageModel(
        role: 'system', content: engineering),
    OpenAIChatCompletionChoiceMessageModel(role: 'user', content: prompt)
  ]);

  return model.choices.first.message.content;
}

Future<String> generateText(String engineering, String prompt)async{
  OpenAIChatCompletionModel model =
      await OpenAI.instance.chat.create(model: "gpt-3.5-turbo", messages: [
    OpenAIChatCompletionChoiceMessageModel(
        role: 'system', content: engineering),
    OpenAIChatCompletionChoiceMessageModel(role: 'user', content: prompt)
  ]);

  return model.choices.first.message.content;
}

Future<String> generatePic(String prompt) async {
  return "https://images.unsplash.com/photo-1504600770771-fb03a6961d33?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=882&q=80";
  final image = await OpenAI.instance.image
      .create(prompt: prompt, n: 1, size: OpenAIImageSize.size256);
  return image.data.first.url;
}

Future<String> generateStoryTitle(String text) async {
  return await generateText("", "Write a title for a children's book with the following text: $text");
}

Future<StoryBook> generateStory(String word) async {
  
  String response = await generateText("", "Imagine I am a small child. Tell me a bedtime story about the word '$word'. Your response is 10 sentences long.");

  List<String> text = response.split(".");

  List<StoryPage> pages = [];

  String title = await generateStoryTitle(response);
  String cover = await generatePic(
      "Show me a cover illustration for a children's storybook titled: $title");

  for (int i = 0; i < text.length; i++) {
    if (i % 2 == 0) {
      print("//// FETCHING IMAGE ${i / 2} ////");

      String pageText =
          (i == text.length - 1) ? "${text[i]}." : "${text[i]}. ${text[i + 1]}."";

      String url = await generatePic(
          "Show me an illustration for a children's storybook to accompany the text: $pageText");
      pages.add(StoryPage(pageText.toSentenceCase(), url));
    }
  }
  print("//// STORY GENERATION COMPLETE ////");
  return StoryBook(TitlePage(title, cover), pages);
}
