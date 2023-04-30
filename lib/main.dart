import 'package:flutter/material.dart';
import 'package:gpt_man/providers/chat_provider.dart';
import 'package:gpt_man/providers/models_provider.dart';
import 'package:gpt_man/screens/chat.dart';
import 'package:gpt_man/utils/constants.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_)=> ModelsProvider()),
        ChangeNotifierProvider(create: (_)=> ChatProvider())
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          scaffoldBackgroundColor: scaffoldBackgroundColor,
          appBarTheme: AppBarTheme(color: cardColor),
        ),
        home: const ChatScreen(),
      ),
    );
  }
}