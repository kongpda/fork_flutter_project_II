import 'package:flutter/material.dart';
import 'package:flutter_project_ii/api_module/event_logic.dart';
import 'package:flutter_project_ii/event_splash_screen.dart';
import 'package:flutter_project_ii/profile_module/profile_screen.dart';
import 'package:provider/provider.dart';
import 'package:flutter_project_ii/auth/auth.dart';

class ProfileApp extends StatefulWidget {
  const ProfileApp({super.key});

  // Method to refresh profile data that can be called from outside
  void refreshProfile() {
    // This will be implemented in the state class
  }

  @override
  State<ProfileApp> createState() => _ProfileAppState();
}

class _ProfileAppState extends State<ProfileApp> {
  // Method to refresh the profile data
  void refreshProfileData() {
    print('ProfileApp: Refreshing profile data');
    // Refresh auth provider data
    if (mounted) {
      Provider.of<AuthProvider>(context, listen: false).fetchUserProfile();
      // Refresh events data
      Provider.of<EventLogic>(context, listen: false).readByOrganizer(context);

      // Force a rebuild of the widget
      if (mounted) {
        setState(() {
          // This will trigger a rebuild with fresh data
        });
      }
    }
  }

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
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return ProfileScreen();
          } else {
            return const EventSplashscreen();
          }
        });
  }
}
