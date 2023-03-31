import 'package:dart_openai/openai.dart';

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

Future<String> generatePic(String prompt) async {
  final image = await OpenAI.instance.image
      .create(prompt: prompt, n: 1, size: OpenAIImageSize.size256);
  return image.data.first.url;
}

Future<Map<dynamic, dynamic>> generateStory(String word) async {
  String prompt =
      "Imagine I am a small child. Tell me a bedtime story about the word '$word'. Your response is 10 sentences long.";

  OpenAIChatCompletionModel model = await OpenAI.instance.chat.create(
      model: "gpt-3.5-turbo",
      messages: [
        OpenAIChatCompletionChoiceMessageModel(role: 'user', content: prompt)
      ]);

  String response = model.choices.first.message.content;

  List<String> text = response.split(".");

  Map<dynamic, dynamic> story = {};

  String imagePrompt =
      "Show me an illustration for a children's storybook to accompany the text: ";

  for (int i = 0; i < text.length; i++) {
    if (i != text.length - 1) {
      text[i] = "${text[i]}.";
    }
    if (i % 2 == 0) {
      double num = i / 2;
      print("//// FETCHING IMAGE $num ////");

      String pageText =
          (i == text.length - 1) ? text[i] : text[i] + text[i + 1];

      String url = await generatePic(imagePrompt + pageText);
      story[pageText] = url;
    }
  }
  print("//// STORY GENERATION COMPLETE ////");
  return story;
}
