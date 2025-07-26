import 'package:flutter/material.dart';

class CustomTextButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color? textColor;
  final ButtonStyle? style;

  const CustomTextButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.textColor,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return TextButton(
      onPressed: onPressed,
      style: style ?? TextButton.styleFrom(
        foregroundColor: textColor ?? theme.colorScheme.primary, // Uses primary color from theme
      ),
      child: Text(text),
    );
  }
}