import 'package:flutter/material.dart';
import 'package:flutter_project_ii/auth_model/loading_screen.dart';
import 'package:flutter_project_ii/login_screen.dart';
import 'package:provider/provider.dart';
import 'package:flutter_project_ii/auth/auth.dart';

class GetStartScreen extends StatelessWidget {
  const GetStartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(20),
        color: Color(0xFF11151C),
        child: Column(
          children: [
            SizedBox(height: 20),
            Container(
              margin: const EdgeInsets.only(top: 200),
              child:
                  Image.asset('assets/Wegocolor.png', width: 230, height: 230),
            ),
            SizedBox(height: 20),
            Column(
              children: [
                Text('A place for extraordinary peaple in the world',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 30, color: Colors.white)),
                SizedBox(height: 20),
                Text(
                    "Let's find the next unforgettable event near you with just one of our best apps",
                    textAlign: TextAlign.center,
                    style:
                        TextStyle(fontSize: 18, color: Colors.grey.shade700)),
              ],
            ),
            SizedBox(height: 30),
            SizedBox(
              height: 60,
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  await Provider.of<AuthProvider>(context, listen: false)
                      .completeOnboarding();
                  if (context.mounted) {
                    Navigator.pushReplacementNamed(context, '/login');
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF0466C8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text('Get Started',
                    style: TextStyle(fontSize: 20, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
