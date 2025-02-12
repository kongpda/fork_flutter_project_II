import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../auth/auth.dart';
import '../main_screen.dart';

class GoogleSignInButton extends StatelessWidget {
  const GoogleSignInButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: const BorderSide(color: Colors.grey),
        ),
      ),
      onPressed: () async {
        try {
          // Show loading indicator
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => const Center(
              child: CircularProgressIndicator(),
            ),
          );

          print('Starting Google Sign In...'); // Debug log
          final result = await AuthService.signInWithGoogle();
          print('Sign In Result: $result'); // Debug log

          // Close loading indicator
          if (!context.mounted) return;
          Navigator.pop(context);

          if (result['success']) {
            // Store token in auth provider
            final token = result['data']['token'];
            final authProvider =
                Provider.of<AuthProvider>(context, listen: false);
            await authProvider.setToken(token);

            // Navigate to main screen
            if (!context.mounted) return;
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const MainScreen()),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(result['message'] ?? 'Google sign in failed'),
                backgroundColor: Colors.red,
              ),
            );
          }
        } catch (e, stackTrace) {
          print('Error during Google Sign In: $e'); // Debug log
          print('Stack trace: $stackTrace'); // Debug log

          if (!context.mounted) return;
          Navigator.pop(context); // Close loading indicator
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Sign in error: ${e.toString()}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/google_logo.png',
            height: 24.0,
          ),
          const SizedBox(width: 12.0),
          const Text(
            'Sign in with Google',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
