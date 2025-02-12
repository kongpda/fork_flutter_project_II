import 'package:flutter/material.dart';
import 'package:flutter_project_ii/auth_model/login_logic.dart';
import 'package:flutter_project_ii/auth_model/login_model.dart';
import 'package:flutter_project_ii/auth_model/splash_screen.dart';
import 'package:flutter_project_ii/login_screen.dart';
import 'package:flutter_project_ii/main_screen.dart';
import 'package:provider/provider.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {

  Future _readData() async {
    await Future.delayed(const Duration(seconds: 1), () {});
    await context.read<LoginLogic>().read();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _readData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          LoginResponseModel responseModel =
              context.watch<LoginLogic>().getResponseModel;
          if (responseModel.token == null) {
            return LoginScreen();
          }
          else{
            debugPrint("responseModel.token: ${responseModel.token}");
            return MainScreen();
          }
        } else {
          return const LoginSplashscreen();
        }
      },
    );
  }

  
}