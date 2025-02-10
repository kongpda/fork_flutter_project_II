import 'package:flutter/material.dart';
import 'package:flutter_project_ii/category_module/all_category.dart';
import 'package:flutter_project_ii/category_module/category_service.dart';
import 'package:flutter_project_ii/event_splash_screen.dart';
import 'package:provider/provider.dart';

class CategoryApp extends StatefulWidget {
  const CategoryApp({super.key});

  @override
  State<CategoryApp> createState() => _CategoryAppState();
}

class _CategoryAppState extends State<CategoryApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: _buildLoadingScreen(),
    );
  }

  Widget _buildLoadingScreen() {
    return FutureBuilder(
      future: context.read<CategoryLogic>().fetchCategory(),
      builder: (context, snapshot){
        if(snapshot.connectionState == ConnectionState.done){
          return AllCategoryScreen();
        }else{
          return const EventSplashscreen();
        }
      });
  }
  
}