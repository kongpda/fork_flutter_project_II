import 'package:flutter/cupertino.dart';
import 'package:flutter_project_ii/api_module/event_logic.dart';
import 'package:flutter_project_ii/event_app.dart';
import 'package:flutter_project_ii/main_screen.dart';
import 'package:provider/provider.dart';

Widget eventProvider(){
  return MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => EventLogic()),
  ],
  child: const EventApp(),
  );
}