import 'package:flutter/cupertino.dart';
import 'package:gpt_man/services/api_service.dart';

import '../models/models_model.dart';

class ModelsProvider with ChangeNotifier {
  String currentModel = "text-davinci-003";

  List<ModelsModel> modelsList = [];

  List<ModelsModel> get getModelList {
    return modelsList;
  }

  String get getCurrentModel {
    return currentModel;
  }

  void setCurrentModel(String newModel) {
    currentModel = newModel;
    notifyListeners();
  }

  Future<List<ModelsModel>> getAllModels() async {
    modelsList = await ApiService.getModels();
    return modelsList;
  }
}
