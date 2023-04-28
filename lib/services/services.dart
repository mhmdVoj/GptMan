import 'package:flutter/material.dart';
import 'package:gpt_man/utils/widgets/deop_down.dart';

import '../utils/constants.dart';
import '../utils/widgets/text_widget.dart';

class Services {
  static Future<void> showModalSheet(context) async {
    showModalBottomSheet(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
        backgroundColor: scaffoldBackgroundColor,
        context: context,
        builder: (context) {
          return  Padding(
            padding: EdgeInsets.all(18.0),
            child: Row(
              children: [
                
                Flexible(
                    child: TextWidget(
                  label: "Chosen Model : ",
                  fontSize: 16,
                )),
                SizedBox(width: 4,),
                Flexible(
                    flex: 2,
                    child: ModelDropDownWidget())
              ],
            ),
          );
        });
  }
}
