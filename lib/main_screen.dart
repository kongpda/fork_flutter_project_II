import 'package:flutter/material.dart';
import 'package:flutter_project_ii/favorite_screen.dart';
import 'package:flutter_project_ii/home_screen.dart';
import 'package:flutter_project_ii/profile_screen.dart';

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
    return BottomNavigationBar(
      backgroundColor: Color(0xFF11151C),
      type: BottomNavigationBarType.fixed,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      items: const[
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined, size: 35),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.favorite_border, size: 35),
          label: 'Favorite',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.paste_rounded, size: 35),
          label: 'Ticket',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outlined, size: 35),
          label: 'Profile',
        ),
      ],
      currentIndex: currentIndex,
      selectedItemColor: Colors.blue,
      unselectedItemColor: Colors.grey,
      onTap: (index){
        setState(() {
          currentIndex = index;
        });
      },
    );
  }
}