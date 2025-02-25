import 'package:flutter/material.dart';
import 'package:flutter_project_ii/api_module/event_logic.dart';
import 'package:flutter_project_ii/event_splash_screen.dart';
import 'package:flutter_project_ii/home_screen.dart';
import 'package:provider/provider.dart';

class EventApp extends StatefulWidget {
  const EventApp({super.key});

  @override
  State<EventApp> createState() => _EventAppState();
}

class _EventAppState extends State<EventApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: _buildLoadingScreen(),
      theme: ThemeData(
        colorScheme: const ColorScheme.dark(),
      ),
    );
  }

  Widget _buildLoadingScreen() {
    return FutureBuilder(
      future: context.read<EventLogic>().read(context),
      builder: (context, snapshot){
        if(snapshot.connectionState == ConnectionState.done){
          return HomeScreen();
        }else{
          return const EventSplashscreen();
        }
      });
  }
  
}