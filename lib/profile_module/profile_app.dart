import 'package:flutter/material.dart';
import 'package:flutter_project_ii/api_module/event_logic.dart';
import 'package:flutter_project_ii/event_splash_screen.dart';
import 'package:flutter_project_ii/profile_module/profile_screen.dart';
import 'package:provider/provider.dart';

class ProfileApp extends StatefulWidget {
  const ProfileApp({super.key});

  @override
  State<ProfileApp> createState() => _ProfileAppState();
}

class _ProfileAppState extends State<ProfileApp> {
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
      future: context.read<EventLogic>().readByOrganizer(context),
      builder: (context, snapshot){
        if(snapshot.connectionState == ConnectionState.done){
          return ProfileScreen();
        }else{
          return const EventSplashscreen();
        }
      });
  }
  
}