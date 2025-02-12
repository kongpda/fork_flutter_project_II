import 'package:flutter/material.dart';

class AuthTextField extends StatelessWidget {
  final String? hintText;
  final IconData? prefixIcon;
  final bool isPassword;
  final TextEditingController? controller;
  final String? Function(String?)? validator;

  const AuthTextField({
    super.key,
    this.hintText,
    this.prefixIcon,
    this.isPassword = false,
    this.controller,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF2A2B2E),
        borderRadius: BorderRadius.circular(16),
      ),
      child: TextFormField(
        controller: controller,
        obscureText: isPassword,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(color: Colors.grey),
          prefixIcon: Icon(prefixIcon, color: Colors.grey),
          suffixIcon: isPassword
              ? IconButton(
                  icon:
                      const Icon(Icons.visibility_outlined, color: Colors.grey),
                  onPressed: () {
                    // Toggle password visibility
                  },
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 16,
          ),
        ),
        validator: validator,
      ),
    );
  }
}
