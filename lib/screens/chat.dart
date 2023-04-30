import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:gpt_man/providers/chat_provider.dart';
import 'package:gpt_man/services/api_service.dart';
import 'package:gpt_man/services/assets_manager.dart';
import 'package:gpt_man/utils/constants.dart';
import 'package:gpt_man/utils/widgets/chat_widget.dart';
import 'package:gpt_man/utils/widgets/text_widget.dart';
import 'package:provider/provider.dart';

import '../models/chat_model.dart';
import '../providers/models_provider.dart';
import '../services/services.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  bool _isTyping = false;
  final TextEditingController _textEditingController = TextEditingController();
  late ScrollController _listScrollController;
  late FocusNode _focusNode;

  @override
  void initState() {
    _listScrollController = ScrollController();
    _focusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    _listScrollController.dispose();
    _textEditingController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final modelsProvider = Provider.of<ModelsProvider>(context, listen: false);
    final chatsProvider = Provider.of<ChatProvider>(context, listen: false);
    return Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
                onPressed: () async {
                  await Services.showModalSheet(context);
                },
                icon: const Icon(
                  Icons.more_vert_rounded,
                  color: Colors.white,
                ))
          ],
          title: const Text('GPT-Man'),
          elevation: 2,
          leading: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Image.asset(AssetsManager.openaiImage),
          ),
        ),
        body: SafeArea(
          child: Column(children: [
            Flexible(
              child: ListView.builder(
                  controller: _listScrollController,
                  itemCount: chatsProvider.chatList.length,
                  itemBuilder: (context, index) {
                    return ChatWidget(
                      msg: chatsProvider.chatList[index].msg.toString(),
                      chatIndex: chatsProvider.chatList[index].chatIndex,
                    );
                  }),
            ),
            if (_isTyping) ...[
              const SpinKitFadingFour(
                color: Colors.white,
                size: 25,
              ),
              const SizedBox(
                height: 16,
              ),
            ],
            Material(
              color: cardColor,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                        child: TextField(
                      style: const TextStyle(color: Colors.white),
                      focusNode: _focusNode,
                      decoration: const InputDecoration.collapsed(
                          hintText: "How Can I help you?",
                          hintStyle: TextStyle(color: Colors.grey)),
                      controller: _textEditingController,
                      onSubmitted: (value) async {
                        await sendMessageFCT(
                            modelsProvider: modelsProvider,
                            provider: chatsProvider);
                      },
                    )),
                    IconButton(
                        onPressed: () async {
                          await sendMessageFCT(
                              modelsProvider: modelsProvider,
                              provider: chatsProvider);
                        },
                        icon: const Icon(
                          Icons.send,
                          color: Colors.white,
                        ))
                  ],
                ),
              ),
            )
          ]),
        ));
  }

  void scrollListToEnd() {
    _listScrollController.animateTo(
        _listScrollController.position.maxScrollExtent,
        duration: const Duration(seconds: 1),
        curve: Curves.easeOut);
  }

  Future<void> sendMessageFCT(
      {required ModelsProvider modelsProvider,
      required ChatProvider provider}) async {
    if (_textEditingController.text.isEmpty) {
      return;
    }
    if (_isTyping) {
      return;
    }
    try {
      String tmpMessage = _textEditingController.text;
      setState(() {
        _isTyping = true;
        provider.addUserMessage(msg: tmpMessage);
        _textEditingController.clear();
        _focusNode.unfocus();
      });
      await provider.sendMessageGetAnswers(
          msg: tmpMessage, chosenModel: modelsProvider.getCurrentModel);
      setState(() {});
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.red,
          content: TextWidget(
            label: e.toString(),
          )));
      log('error in chat screen : $e');
    } finally {
      setState(() {
        scrollListToEnd();
        _isTyping = false;
      });
    }
  }
}
