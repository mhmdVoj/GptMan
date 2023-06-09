import 'package:flutter/foundation.dart';

import '../models/chat_model.dart';
import '../services/api_service.dart';

class ChatProvider with ChangeNotifier {
  List<ChatModel> chatList = [];

  List<ChatModel> get getChatList {
    return chatList;
  }

  void addUserMessage({required String msg}) {
    chatList.add(ChatModel(msg: msg, chatIndex: 0));
    notifyListeners();
  }

  Future<void> sendMessageGetAnswers(
      {required String msg, required chosenModel}) async {
    chatList.addAll(
        await ApiService.sendMessage(message: msg, modelId: chosenModel));
    notifyListeners();
  }
}
