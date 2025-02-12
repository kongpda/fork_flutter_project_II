import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/custom_button.dart';
import '../services/auth_service.dart';
import '../utils/device_utils.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;

  Future<void> _handleSignUp() async {
    setState(() => _isLoading = true);

    try {
      final deviceName = await DeviceUtils.getDeviceName();
      final result = await AuthService.signup(
        _usernameController.text,
        _emailController.text,
        _passwordController.text,
        deviceName,
      );

      if (result['success']) {
        if (mounted) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            '/home',
            (route) => false,
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(result['message'] ?? 'Registration failed')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
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
                // Back Button
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
                const SizedBox(height: 24),

                // Title
                const Text(
                  'Sign Up',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 32),

                // Username Field
                CustomTextField(
                  controller: _usernameController,
                  hintText: 'Username',
                  prefixIcon: Icons.person_outline,
                ),
                const SizedBox(height: 16),

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
                const SizedBox(height: 32),

                // Sign Up Button
                CustomButton(
                  text: _isLoading ? 'Signing Up...' : 'Sign Up',
                  onPressed: _isLoading
                      ? null
                      : () async {
                          await _handleSignUp();
                        },
                ),
                const SizedBox(height: 24),

                // Or sign up with
                const Center(
                  child: Text(
                    'Or sign up with',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
                const SizedBox(height: 24),

                // Social Sign Up Buttons
                Column(
                  children: [
                    _socialSignUpButton(
                      'Sign Up with Apple',
                      icon: const Icon(Icons.apple, size: 24),
                      onPressed: () {},
                    ),
                    const SizedBox(height: 12),
                    _socialSignUpButton(
                      'Sign Up with Google',
                      imageUrl:
                          'https://img.icons8.com/?size=100&id=17949&format=png&color=000000',
                      onPressed: () {},
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Sign In Link
                Center(
                  child: RichText(
                    text: TextSpan(
                      text: "Have an account? ",
                      style: const TextStyle(color: Colors.grey),
                      children: [
                        TextSpan(
                          text: 'Sign In',
                          style: const TextStyle(
                            color: Color(0xFF4B68FF),
                            fontWeight: FontWeight.bold,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.pop(context);
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

  Widget _socialSignUpButton(
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
