import 'package:flutter/material.dart';
import 'package:flutter_project_ii/api_module/event_logic.dart';
import 'package:flutter_project_ii/auth/auth.dart';
import 'package:flutter_project_ii/auth/login_screen.dart';
import 'package:flutter_project_ii/auth/screens/forgot_password_screen.dart';
import 'package:flutter_project_ii/auth/signup_screen.dart';
import 'package:flutter_project_ii/category_module/category_service.dart';
import 'package:flutter_project_ii/main_screen.dart';
import 'package:flutter_project_ii/profile_module/language_logic.dart';
import 'package:flutter_project_ii/profile_module/profile_screen.dart';
import 'package:flutter_project_ii/start_screen.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final authProvider = AuthProvider();
  await authProvider.init();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: authProvider,
        ),
        ChangeNotifierProvider(create: (create) => LanguageLogic()),
        ChangeNotifierProvider(create: (create) => CategoryLogic()),
        ChangeNotifierProvider(create: (create) => EventLogic()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: const Color(0xFF1A1B1E),
      ),
      routes: {
        '/home': (context) => const MainScreen(),
        '/signup': (context) => const SignUpScreen(),
        '/forgot-password': (context) => const ForgotPasswordScreen(),
        '/login': (context) => const LoginScreen(),
        '/profile': (context) => const ProfileScreen(),
      },
      home: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          return authProvider.isAuthenticated
              ? const MainScreen()
              : const LoginScreen();
        },
      ),
    );
  }
}
