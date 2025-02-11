import 'package:flutter/material.dart';

class EventSplashscreen extends StatelessWidget {
  const EventSplashscreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator()
      ),
    );
  }
}