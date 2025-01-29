import 'package:flutter/material.dart';

class MainScreen extends StatelessWidget {
  //const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Main Screen'),
      ),
      body: _buildBody(),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildBody() {
    return IndexedStack(
      index: currentIndex,
      children: [
        // HomeScreen(),
        // FavoriteScreen(),
        // TicketScreen(),
        // ProfileScreen(),
      ]
    );
  }

  int currentIndex = 0;
  BottomNavigationBar _buildBottomNavigationBar() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      items: const[
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined, size: 35,),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.favorite_border, size: 35,),
          label: 'Favorite',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.paste_rounded, size: 35,),
          label: 'Ticket',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outlined, size: 35,),
          label: 'Profile',
        ),
      ],
      currentIndex: currentIndex,
      selectedItemColor: Colors.blue,
    );
  }
}