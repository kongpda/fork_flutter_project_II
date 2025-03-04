import 'package:flutter/material.dart';
import 'package:flutter_project_ii/add_event_screen.dart';
import 'package:flutter_project_ii/event_app.dart';
import 'package:flutter_project_ii/favorite_screen.dart';
import 'package:flutter_project_ii/profile_module/profile_app.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_project_ii/tickets/tickets_screen.dart';
import 'package:provider/provider.dart';
import 'package:flutter_project_ii/auth/auth.dart';
import 'package:flutter_project_ii/api_module/event_logic.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

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

  // Create references to each tab widget
  final EventApp _eventApp = EventApp();
  final FavoriteScreen _favoriteScreen = FavoriteScreen();
  final AddEventScreen _addEventScreen = AddEventScreen();
  final TicketsScreen _ticketsScreen = TicketsScreen();
  final ProfileApp _profileApp = ProfileApp();

  Widget _buildBody() {
    return IndexedStack(index: currentIndex, children: [
      _eventApp,
      _favoriteScreen,
      _addEventScreen,
      _ticketsScreen,
      _profileApp,
    ]);
  }

  int currentIndex = 0;

  Widget _buildBottomNavigationBar() {
    return NavigationBar(
      backgroundColor: Color(0xFF1A202C),
      selectedIndex: currentIndex,
      onDestinationSelected: (index) {
        // Store previous index to check if we're switching to profile tab
        final previousIndex = currentIndex;

        setState(() {
          currentIndex = index;
        });

        // If switching to profile tab (index 4), refresh the profile data
        if (index == 4 && previousIndex != 4) {
          print('Switching to profile tab, refreshing data');
          // Use Future.microtask to ensure this runs after the state is updated
          Future.microtask(() {
            // Directly refresh the auth provider data
            Provider.of<AuthProvider>(context, listen: false)
                .fetchUserProfile();
            // Refresh events data
            Provider.of<EventLogic>(context, listen: false)
                .readByOrganizer(context);
          });
        }
      },
      indicatorColor: Color(0xFF1A202C),
      overlayColor: WidgetStateColor.transparent,
      destinations: [
        NavigationDestination(
          icon: Icon(
            CupertinoIcons.house_alt,
            size: 35,
            color: Colors.grey.shade500,
          ),
          selectedIcon: Icon(
            CupertinoIcons.house_alt_fill,
            size: 35,
            color: Colors.grey.shade500,
          ),
          label: '',
        ),
        NavigationDestination(
          icon: Icon(
            Icons.favorite_border,
            size: 35,
            color: Colors.grey.shade400,
          ),
          selectedIcon: Icon(
            Icons.favorite,
            size: 35,
            color: Colors.grey.shade400,
          ),
          label: '',
        ),
        NavigationDestination(
          icon: Icon(
            Icons.add_box_outlined,
            size: 35,
            color: Colors.grey.shade400,
          ),
          selectedIcon: Icon(
            Icons.add_box,
            size: 35,
            color: Colors.grey.shade400,
          ),
          label: '',
        ),
        NavigationDestination(
          icon: Icon(
            CupertinoIcons.ticket,
            size: 35,
            color: Colors.grey.shade400,
          ),
          selectedIcon: Icon(
            CupertinoIcons.ticket_fill,
            size: 35,
            color: Colors.grey.shade400,
          ),
          label: '',
        ),
        NavigationDestination(
          icon: Icon(
            Icons.person_outline,
            size: 35,
            color: Colors.grey.shade400,
          ),
          selectedIcon: Icon(
            Icons.person,
            size: 35,
            color: Colors.grey.shade400,
          ),
          label: '',
        ),
      ],
    );
  }
}
