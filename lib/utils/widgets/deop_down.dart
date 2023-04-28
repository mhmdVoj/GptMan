import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gpt_man/providers/models_provider.dart';
import 'package:gpt_man/providers/models_provider.dart';
import 'package:gpt_man/services/api_service.dart';
import 'package:gpt_man/utils/constants.dart';
import 'package:gpt_man/utils/widgets/text_widget.dart';
import 'package:provider/provider.dart';

import '../../providers/models_provider.dart';

class ModelDropDownWidget extends StatefulWidget {
  const ModelDropDownWidget({Key? key}) : super(key: key);

  @override
  State<ModelDropDownWidget> createState() => _ModelDropDownWidgetState();
}

class _ModelDropDownWidgetState extends State<ModelDropDownWidget> {
  String? currentModel;

  @override
  Widget build(BuildContext context) {
    final modelsProvider = Provider.of<ModelsProvider>(context, listen: false);
    currentModel = modelsProvider.currentModel;
    return FutureBuilder(
        future: modelsProvider.getAllModels(),
        builder: (context, snapshot) {
          print(snapshot.data == null);
          if (snapshot.hasError) {
            return Center(
              child: TextWidget(
                label: snapshot.error.toString(),
              ),
            );
          }
          return snapshot.data == null || snapshot.data!.isEmpty
              ? const SizedBox.shrink()
              : FittedBox(
                  child: DropdownButton(
                      dropdownColor: scaffoldBackgroundColor,
                      iconEnabledColor: Colors.white,
                      items: List<DropdownMenuItem<String>>.generate(
                          snapshot.data!.length,
                          (index) => DropdownMenuItem(
                              value: snapshot.data![index].id,
                              child: TextWidget(
                                label: snapshot.data![index].id,
                                fontSize: 15,
                              ))),
                      value: currentModel,
                      onChanged: (value) {
                        setState(() {
                          currentModel = value.toString();
                        });
                        modelsProvider.setCurrentModel(value.toString());
                      }),
                );
        });
  }
}

/**
 * DropdownButton(
    dropdownColor: scaffoldBackgroundColor,
    iconEnabledColor: Colors.white,
    items: getModelsItem,
    value: currentModel,
    onChanged: (value) {
    setState(() {
    currentModel = value.toString();
    });
    });
 */
