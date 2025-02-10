import 'package:flutter/material.dart';
import 'package:flutter_project_ii/language_logic.dart';
import 'package:flutter_project_ii/main_screen.dart';
import 'package:flutter_project_ii/start_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(provider());
}

Widget provider(){
  return MultiProvider(providers: [
    ChangeNotifierProvider(create: (create) => LanguageLogic()),
  ],
  child: MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MainScreen(),
    );
  }
}
