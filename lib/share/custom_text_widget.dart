import 'package:flutter/material.dart';

enum CustomTextStyle {
  headlineLarge,
  headlineMedium,
  headlineSmall,
  bodyLarge,
  bodyMedium,
  bodySmall,
  titleLarge,
  titleMedium,
  titleSmall,
  labelLarge,
  labelMedium,
  labelSmall,
}

class CustomText extends StatelessWidget {
  final String text;
  final CustomTextStyle? style;
  final Color? color;
  final TextAlign? textAlign;
  final TextOverflow? overflow;
  final int? maxLines;
  final FontWeight? fontWeight;
  final double? fontSize;

  const CustomText(
      this.text, {
        super.key,
        this.style,
        this.color,
        this.textAlign,
        this.overflow,
        this.maxLines,
        this.fontWeight,
        this.fontSize,
      });

  TextStyle _getTextStyle(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    switch (style) {
      case CustomTextStyle.headlineLarge:
        return theme.headlineLarge!;
      case CustomTextStyle.headlineMedium:
        return theme.headlineMedium!;
      case CustomTextStyle.headlineSmall:
        return theme.headlineSmall!;
      case CustomTextStyle.bodyLarge:
        return theme.bodyLarge!;
      case CustomTextStyle.bodyMedium:
        return theme.bodyMedium!;
      case CustomTextStyle.bodySmall:
        return theme.bodySmall!;
      case CustomTextStyle.titleLarge:
        return theme.titleLarge!;
      case CustomTextStyle.titleMedium:
        return theme.titleMedium!;
      case CustomTextStyle.titleSmall:
        return theme.titleSmall!;
      case CustomTextStyle.labelLarge:
        return theme.labelLarge!;
      case CustomTextStyle.labelMedium:
        return theme.labelMedium!;
      case CustomTextStyle.labelSmall:
        return theme.labelSmall!;
      default:
        return theme.bodyMedium!;
    }
  }

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = _getTextStyle(context);

    if (color != null) {
      textStyle = textStyle.copyWith(color: color);
    }
    if (fontWeight != null) {
      textStyle = textStyle.copyWith(fontWeight: fontWeight);
    }
    if (fontSize != null) {
      textStyle = textStyle.copyWith(fontSize: fontSize);
    }

    return Text(
      text,
      style: textStyle,
      textAlign: textAlign,
      overflow: overflow,
      maxLines: maxLines,
    );
  }
}