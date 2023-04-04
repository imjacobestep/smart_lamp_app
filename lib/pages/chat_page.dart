// ignore_for_file: must_be_immutable

import 'package:chatview/chatview.dart';
import 'package:flutter/material.dart';
import 'package:smart_lamp/assets/theme.dart';
import 'package:smart_lamp/models/ai.dart';
import 'package:smart_lamp/models/chat_data.dart';
import 'package:smart_lamp/models/proxy.dart';
import 'package:status_bar_control/status_bar_control.dart';

import '../widgets/general/app_bar.dart';

class ChatPage extends StatefulWidget {
  @override
  ChatPageState createState() => ChatPageState();

  String word;
  Proxy proxyModel = Proxy();
  Future<dynamic>? statusbarControl;
  String? imageURL;
  // ChatController? chatController;
  // ScrollController? scrollController;

  ChatPage({
    super.key,
    required this.word,
  });
}

class ChatPageState extends State<ChatPage> {
  late ChatController chatController = ChatController(
      initialMessageList: ChatData.messageList,
      scrollController: ScrollController(),
      chatUsers: [
        ChatUser(
            id: '0', name: "VocaLamp", profilePhoto: "lib/assets/vl_icon.png"),
        ChatUser(id: '1', name: "me"),
        ChatUser(
            id: '2',
            name: widget.word,
            profilePhoto:
                "https://images.unsplash.com/photo-1523821741446-edb2b68bb7a0?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1740&q=80")
      ]);
  int lastMessageID = 2;
  //vars
  @override
  void initState() {
    super.initState();

    widget.statusbarControl = StatusBarControl.setNavigationBarColor(canvas);
    widget.statusbarControl =
        StatusBarControl.setNavigationBarStyle(NavigationBarStyle.DARK);
    _firstAiMessage();
  }

  @override
  void dispose() {
    chatController.dispose();
    super.dispose();
  }

  Future<void> _firstAiMessage() async {
    chatController.addMessage(Message(
      id: "2",
      createdAt: DateTime.now(),
      message: await generateMessage(widget.word),
      sendBy: "2",
      messageType: MessageType.text,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: canvas,
        appBar: appBar(headerBack(context), widget.word, dark,
            headerSpeak(widget.word, context)),
        body: ChatView(
          chatController: chatController,
          currentUser: chatController.getUserFromId("1"),
          chatViewState: ChatViewState.hasMessages,
          onSendTap: _onSendTap,
          chatBackgroundConfig:
              ChatBackgroundConfiguration(backgroundColor: canvas),
          sendMessageConfig: SendMessageConfiguration(
              allowRecordingVoice: false,
              defaultSendButtonColor: dark,
              textFieldBackgroundColor: surface,
              imagePickerIconsConfig: ImagePickerIconsConfiguration(
                cameraImagePickerIcon: const SizedBox(),
                galleryImagePickerIcon: const SizedBox(),
              ),
              textFieldConfig: TextFieldConfiguration(
                  textStyle: TextStyle(color: dark),
                  hintStyle: TextStyle(color: dark))),
          chatBubbleConfig: ChatBubbleConfiguration(
              inComingChatBubbleConfig: ChatBubble(
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                      bottomRight: Radius.circular(10),
                      bottomLeft: Radius.circular(2)),
                  color: surface,
                  textStyle: TextStyle(color: dark, fontSize: 18)),
              outgoingChatBubbleConfig: ChatBubble(
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                      bottomRight: Radius.circular(2),
                      bottomLeft: Radius.circular(10)),
                  color: dark)),
        ));
  }

  // void _showHideTypingIndicator() {
  //   widget.chatController!.setTypingIndicator = !widget.chatController!.showTypingIndicator;
  // }

  void _onSendTap(
      String message, ReplyMessage replyMessage, MessageType messageType) {
    lastMessageID++;
    chatController.addMessage(
      Message(
        id: lastMessageID.toString(),
        createdAt: DateTime.now(),
        message: message,
        sendBy: "1",
        messageType: messageType,
      ),
    );
    Future.delayed(const Duration(milliseconds: 300), () async {
      lastMessageID++;
      String aiMessage = await generateTextResponse(
          messagesToAI(chatController.initialMessageList, widget.word));
      chatController.addMessage(Message(
          id: lastMessageID.toString(),
          message: aiMessage,
          createdAt: DateTime.now(),
          sendBy: "2"));
    });
  }
}
