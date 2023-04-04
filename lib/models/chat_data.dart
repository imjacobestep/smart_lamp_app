import 'package:chatview/chatview.dart';

class ChatData {
  static const profileImage =
      "https://images.unsplash.com/photo-1504600770771-fb03a6961d33?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=882&q=80";
  static final messageList = [
    Message(
        id: "1",
        message:
            "Hi there! This feature lets you talk to a word to learn more about it.",
        createdAt: DateTime.now(),
        sendBy: "0")
  ];
}
