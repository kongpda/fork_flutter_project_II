import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project_ii/main_screen.dart';
import '../widgets/custom_text_field.dart';
import 'signup_screen.dart';
import '../widgets/custom_button.dart';
import 'screens/forgot_password_screen.dart';
import 'package:provider/provider.dart';
import 'auth.dart';
import '../utils/device_utils.dart';
import '../services/auth_service.dart';
import '../widgets/google_sign_in_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: const Color(0xFF1A1B1E),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Welcome Text
                const Text(
                  'Hey! Welcome back',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Sign In to your account',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 32),

                // Email Field
                CustomTextField(
                  controller: _emailController,
                  hintText: 'Email',
                  prefixIcon: Icons.email_outlined,
                ),
                const SizedBox(height: 16),

                // Password Field
                CustomTextField(
                  controller: _passwordController,
                  hintText: 'Password',
                  prefixIcon: Icons.lock_outline,
                  isPassword: true,
                  obscureText: _obscurePassword,
                  onTogglePassword: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                ),
                const SizedBox(height: 16),

                // Forgot Password
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ForgotPasswordScreen(),
                        ),
                      );
                    },
                    child: const Text(
                      'Forgot Password?',
                      style: TextStyle(
                        color: Color(0xFF4B68FF),
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Sign In Button
                CustomButton(
                  text: 'Sign In',
                  onPressed: () async {
                    final email = _emailController.text.trim();
                    final password = _passwordController.text;

                    if (email.isEmpty || password.isEmpty) {
                      if (!mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Please fill in all fields')),
                      );
                      return;
                    }

                    // Store context before async gap
                    final navigator = Navigator.of(context);
                    final scaffoldMessenger = ScaffoldMessenger.of(context);

                    // Show loading indicator
                    if (!mounted) return;
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) => const Center(
                        child: CircularProgressIndicator(),
                      ),
                    );

                    try {
                      final deviceName = await DeviceUtils.getDeviceName();
                      final result =
                          await AuthService.login(email, password, deviceName);

                      // Close loading indicator
                      if (!mounted) return;
                      navigator.pop();

                      if (result['success']) {
                        if (!mounted) return;
                        // Store token in your auth provider
                        final token = result['data']['token'];
                        final authProvider =
                            Provider.of<AuthProvider>(context, listen: false);
                        await authProvider.setToken(token);

                        navigator.pushReplacement(
                          MaterialPageRoute(
                              builder: (context) => const MainScreen()),
                        );
                      } else {
                        scaffoldMessenger.showSnackBar(
                          SnackBar(
                            content: Text(result['message'] ??
                                'Invalid email or password'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    } catch (e) {
                      // Close loading indicator
                      if (!mounted) return;
                      navigator.pop();

                      scaffoldMessenger.showSnackBar(
                        const SnackBar(
                          content: Text('An error occurred. Please try again.'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                ),
                const SizedBox(height: 24),

                // Or login with
                const Center(
                  child: Text(
                    'Or login with',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
                const SizedBox(height: 24),

                // Social Login Buttons
                Column(
                  children: [
                    _socialLoginButton(
                      'Log In with Apple',
                      icon: const Icon(Icons.apple, size: 24),
                      onPressed: () {},
                    ),
                    const SizedBox(height: 12),
                    const GoogleSignInButton(),
                  ],
                ),
                const SizedBox(height: 24),

                // Sign Up Link
                Center(
                  child: RichText(
                    text: TextSpan(
                      text: "Don't have an account? ",
                      style: const TextStyle(color: Colors.grey),
                      children: [
                        TextSpan(
                          text: 'Sign Up',
                          style: const TextStyle(
                            color: Color(0xFF4B68FF),
                            fontWeight: FontWeight.bold,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const SignUpScreen(),
                                ),
                              );
                            },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _socialLoginButton(
    String text, {
    Icon? icon,
    String? imageUrl,
    required VoidCallback onPressed,
  }) {
    return CustomButton(
      text: text,
      onPressed: onPressed,
      isOutlined: true,
      icon: icon,
      imageUrl: imageUrl,
      textColor: Colors.black,
      backgroundColor: Colors.white,
    );
  }
}
