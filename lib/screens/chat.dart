import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:gpt_man/services/api_service.dart';
import 'package:gpt_man/services/assets_manager.dart';
import 'package:gpt_man/utils/constants.dart';
import 'package:gpt_man/utils/widgets/chat_widget.dart';
import 'package:gpt_man/utils/widgets/text_widget.dart';

import '../services/services.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final bool _isTyping = true;
  late TextEditingController _textEditingController;

  @override
  void initState() {
    _textEditingController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
                onPressed: () async {
                  await Services.showModalSheet(context);
                },
                icon: Icon(
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
                  itemCount: 6,
                  itemBuilder: (context, index) {
                    return ChatWidget(
                      msg: chatMessages[index]["msg"].toString(),
                      chatIndex: int.parse(
                          chatMessages[index]["chatIndex"].toString()),
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
              Material(
                color: cardColor,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                          child: TextField(
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration.collapsed(
                            hintText: "How Can I help you?",
                            hintStyle: TextStyle(color: Colors.grey)),
                        controller: _textEditingController,
                        onSubmitted: (value) {
                          // todo send message
                        },
                      )),
                      IconButton(
                          onPressed: () {
                            ApiService.getModels();
                          },
                          icon: Icon(
                            Icons.send,
                            color: Colors.white,
                          ))
                    ],
                  ),
                ),
              )
            ]
          ]),
        ));
  }
}
