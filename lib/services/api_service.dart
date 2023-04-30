import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:gpt_man/models/chat_model.dart';
import 'package:gpt_man/models/models_model.dart';
import 'package:gpt_man/utils/api_constants.dart';
import 'package:http/http.dart' as httpClient;

class ApiService {
  static Future<List<ModelsModel>> getModels() async {
    try {
      var response = await httpClient.get(Uri.parse("$BASE_URL/models"),
          headers: {"Authorization": "Bearer $API_KEY"});
      Map jsonResponse = jsonDecode(response.body);
      if (jsonResponse['error'] != null) {
        print(jsonResponse['error']['message']);
        throw HttpException(jsonResponse['error']['message']);
      }
      List tmp = [];
      for (var value in jsonResponse["data"]) {
        tmp.add(value);
      }
      return ModelsModel.modelsFromSnapshot(tmp);
    } catch (error) {
      print("Error : $error");
      throw const HttpException('Error Unknown!');
    }
  }

  static Future<List<ChatModel>> sendMessage(
      {required String message, required String modelId}) async {
    try {
      print('${message} :  ${modelId}');
      var response = await httpClient.post(Uri.parse("$BASE_URL/completions"),
          headers: {
            "Authorization": "Bearer $API_KEY",
            "Content-Type": "application/json"
          },
          body: jsonEncode(
              {"model": modelId, "prompt": message, "max_tokens": 100}));
      Map jsonResponse = jsonDecode(response.body);

      if (jsonResponse['error'] != null) {
        print(jsonResponse['error']['message']);
        throw HttpException(jsonResponse['error']['message']);
      }
      List<ChatModel> chatList = [];

      if (jsonResponse['choices'].length > 0) {
        chatList = List.generate(
            jsonResponse['choices'].length,
            (index) => ChatModel(
                msg: jsonResponse['choices'][index]['text'], chatIndex: 1));
      }

      return chatList;
    } catch (error) {
      print("Error : $error");
      throw const HttpException('Error Unknown!');
    }
  }
}
