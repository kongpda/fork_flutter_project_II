import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF11151C),
        title: Text('Profile'),
      ),
      body: Container(
        color: Color(0xFF11151C),
        child: Column(
          children: [
            Text('Name: John Doe'),
            Text('Age: 25'),
            Text('Email: johndoe@example.com'),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to edit profile screen
        },
        child: Icon(Icons.edit),
      ),
    );
  }
}