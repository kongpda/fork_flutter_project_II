import 'package:flutter/cupertino.dart';
import 'package:flutter_project_ii/api_module/event_logic.dart';
import 'package:flutter_project_ii/event_app.dart';
import 'package:provider/provider.dart';

Widget omdbProvider(){
  return MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => EventLogic()),
  ],
  child: const EventApp(),
  );
}