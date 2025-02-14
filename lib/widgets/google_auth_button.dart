import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../auth/auth.dart';
import '../main_screen.dart';

class GoogleAuthButton extends StatelessWidget {
  final String buttonText;

  const GoogleAuthButton({
    super.key,
    this.buttonText = 'Sign in with Google',
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        minimumSize: const Size.fromHeight(48),
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

          final authProvider =
              Provider.of<AuthProvider>(context, listen: false);
          final result = await authProvider.signInWithGoogle();

          // Close loading indicator
          if (!context.mounted) return;
          Navigator.pop(context);

          if (result['success']) {
            // Navigate to main screen
            if (!context.mounted) return;
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const MainScreen()),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content:
                    Text(result['message'] ?? 'Google authentication failed'),
                backgroundColor: Colors.red,
              ),
            );
          }
        } catch (e) {
          if (!context.mounted) return;
          Navigator.pop(context); // Close loading indicator
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Authentication error: ${e.toString()}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/google_logo.png',
            height: 24.0,
          ),
          const SizedBox(width: 12),
          Text(
            buttonText,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
