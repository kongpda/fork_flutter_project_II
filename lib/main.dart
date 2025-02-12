import 'package:flutter/material.dart';
import 'package:flutter_project_ii/api_module/event_logic.dart';
import 'package:flutter_project_ii/auth_model/login_logic.dart';
import 'package:flutter_project_ii/category_module/category_service.dart';
import 'package:flutter_project_ii/profile_module/language_logic.dart';
import 'package:flutter_project_ii/start_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(provider());
}

Widget provider(){
  return MultiProvider(providers: [
    ChangeNotifierProvider(create: (create) => LanguageLogic()),
    ChangeNotifierProvider(create: (create) => CategoryLogic()),
    ChangeNotifierProvider(create: (context) => LoginLogic()),
    ChangeNotifierProvider(create: (context) => EventLogic()),

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
      home: GetStartScreen(),
    );
  }
}
