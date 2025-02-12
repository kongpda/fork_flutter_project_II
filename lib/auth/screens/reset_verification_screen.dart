import 'package:flutter/material.dart';
import '../../widgets/custom_button.dart';
import './create_password_screen.dart';

class ResetVerificationScreen extends StatefulWidget {
  const ResetVerificationScreen({super.key});

  @override
  State<ResetVerificationScreen> createState() =>
      _ResetVerificationScreenState();
}

class _ResetVerificationScreenState extends State<ResetVerificationScreen> {
  final List<TextEditingController> _controllers = List.generate(
    6,
    (index) => TextEditingController(),
  );

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final boxWidth = (screenWidth - (5 * 8) - (2 * 24)) / 6;

    return Scaffold(
      backgroundColor: const Color(0xFF1A1B1E),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  // Back Button
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: const Color(0xFF2A2B2E),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back,
                          color: Colors.white, size: 20),
                      onPressed: () => Navigator.pop(context),
                      padding: EdgeInsets.zero,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Title and subtitle
                  const Text(
                    'Verification Code',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Enter the verification code that we have\nsent to your phone number',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Verification Code Fields
                  SizedBox(
                    width: double.infinity,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(
                        6,
                        (index) => Container(
                          width: boxWidth,
                          height: boxWidth,
                          margin: EdgeInsets.only(right: index != 5 ? 8 : 0),
                          decoration: BoxDecoration(
                            color: const Color(0xFF2A2B2E),
                            borderRadius: BorderRadius.circular(16),
                            border: _controllers[index].text.isNotEmpty
                                ? null
                                : index == _getNextEmptyIndex()
                                    ? Border.all(
                                        color: const Color(0xFF4B68FF),
                                        width: 2)
                                    : null,
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            _controllers[index].text,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Resend Code
                  Center(
                    child: GestureDetector(
                      onTap: () {
                        // Add resend logic here
                      },
                      child: const Text(
                        'Resend Code',
                        style: TextStyle(
                          color: Color(0xFF4B68FF),
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Continue Button
                  CustomButton(
                    text: 'Continue',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CreatePasswordScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Custom Numeric Keyboard
            Padding(
              padding: const EdgeInsets.fromLTRB(32, 0, 32, 32),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: ['1', '2', '3']
                        .map((e) => _buildKeyboardButton(e))
                        .toList(),
                  ),
                  const SizedBox(height: 32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: ['4', '5', '6']
                        .map((e) => _buildKeyboardButton(e))
                        .toList(),
                  ),
                  const SizedBox(height: 32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: ['7', '8', '9']
                        .map((e) => _buildKeyboardButton(e))
                        .toList(),
                  ),
                  const SizedBox(height: 32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildKeyboardButton('.'),
                      _buildKeyboardButton('0'),
                      _buildKeyboardButton('⌫'),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildKeyboardButton(String value) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _onKeyTap(value),
        borderRadius: BorderRadius.circular(16),
        splashColor: const Color(0xFF4B68FF).withOpacity(0.2),
        highlightColor: const Color(0xFF4B68FF).withOpacity(0.1),
        child: Container(
          width: 65,
          height: 45,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Center(
            child: value == '⌫'
                ? const Icon(
                    Icons.backspace_outlined,
                    color: Colors.white,
                    size: 24,
                  )
                : Text(
                    value,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  int _getNextEmptyIndex() {
    return _controllers.indexWhere((controller) => controller.text.isEmpty);
  }

  void _onKeyTap(String value) {
    int currentIndex = _getNextEmptyIndex();

    if (value == '⌫') {
      // Handle backspace
      if (currentIndex == -1) {
        currentIndex = 5;
      } else if (currentIndex > 0) {
        currentIndex--;
      }
      if (currentIndex >= 0) {
        _controllers[currentIndex].clear();
      }
    } else if (value != '.' && currentIndex != -1) {
      // Handle number input (ignore dot)
      _controllers[currentIndex].text = value;
    }

    setState(() {});
  }
}
