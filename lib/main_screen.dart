import 'package:flutter/material.dart';
import 'package:flutter_project_ii/favorite_screen.dart';
import 'package:flutter_project_ii/home_screen.dart';
import 'package:flutter_project_ii/profile_screen.dart';
import 'package:flutter/cupertino.dart';

class MainScreen extends StatefulWidget {
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  //const MainScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildBody() {
    return IndexedStack(
      index: currentIndex,
      children: [
        HomeScreen(),
        FavoriteScreen(),
        // TicketScreen(),
        ProfileScreen(),
      ]
    );
  }

  int currentIndex = 0;

  Widget _buildBottomNavigationBar() {
    return NavigationBar(
      
      backgroundColor: Color(0xFF11151C),
      selectedIndex: currentIndex,
      onDestinationSelected: (index) {
        setState(() {
          currentIndex = index;
        });
      },
      indicatorColor: Color(0xFF11151C),
      overlayColor: WidgetStateColor.transparent,
      destinations: [
        NavigationDestination(
          icon: Icon(CupertinoIcons.house_alt, size: 35, color: Colors.grey.shade500,),
          selectedIcon: Icon(CupertinoIcons.house_alt_fill, size: 35, color: Colors.grey.shade500,),
          label: '',
        ),
        NavigationDestination(
          icon: Icon(Icons.favorite_border, size: 35, color: Colors.grey.shade400,),
          selectedIcon: Icon(Icons.favorite, size: 35, color: Colors.grey.shade400,),
          label: '',
        ),
        NavigationDestination(
          icon: Icon(CupertinoIcons.ticket, size: 35, color: Colors.grey.shade400,),
          selectedIcon: Icon(CupertinoIcons.ticket_fill, size: 35, color: Colors.grey.shade400,),
          label: '',
        ),
        NavigationDestination(
          icon: Icon(Icons.person_outline, size: 35, color: Colors.grey.shade400,),
          selectedIcon: Icon(Icons.person, size: 35, color: Colors.grey.shade400,),
          label: '',
        ),
        
      ],
    );
  }
}