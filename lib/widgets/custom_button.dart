import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final Function()? onPressed;
  final bool isOutlined;
  final Icon? icon;
  final String? imageUrl;
  final Color? backgroundColor;
  final Color? textColor;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isOutlined = false,
    this.icon,
    this.imageUrl,
    this.backgroundColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ??
              (isOutlined ? Colors.transparent : const Color(0xFF4B68FF)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          side: isOutlined ? const BorderSide(color: Color(0xFF4B68FF)) : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) icon!,
            if (imageUrl != null) Image.network(imageUrl!, height: 24),
            if (icon != null || imageUrl != null) const SizedBox(width: 12),
            Text(
              text,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: textColor ??
                    (isOutlined ? const Color(0xFF4B68FF) : Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
