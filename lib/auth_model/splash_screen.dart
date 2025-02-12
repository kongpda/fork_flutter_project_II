import 'package:flutter/material.dart';

class LoginSplashscreen extends StatelessWidget {
  const LoginSplashscreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}