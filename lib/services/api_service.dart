
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:gpt_man/models/models_model.dart';
import 'package:gpt_man/utils/api_constants.dart';
import 'package:http/http.dart' as httpClient;

class ApiService {
  static Future<List<ModelsModel>> getModels() async {
    try {
     var response =await  httpClient.get(Uri.parse("$BASE_URL/models"),headers: {
        "Authorization" : "Bearer $API_KEY"
      });
     Map jsonResponse = jsonDecode(response.body);
     if(jsonResponse['error'] != null) {
       print(jsonResponse['error']['message']);
       throw HttpException(jsonResponse['error']['message']);
     }
     List tmp = [];
     for (var value in  jsonResponse["data"]) {
       tmp.add(value);
       log('value is : ${value['id']}');
     }
     return ModelsModel.modelsFromSnapshot(tmp);
    }catch(error) {
      print("Error : $error");
      throw const HttpException('Error Unknow!');
    }
  }
}