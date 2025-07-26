import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class AppTypography {
  static TextTheme createTextTheme(BuildContext context, TextTheme baseTextTheme, double fontScaleFactor) {
    return baseTextTheme.copyWith(
      displayLarge: baseTextTheme.displayLarge?.copyWith(fontSize: 57.sp * fontScaleFactor),
      displayMedium: baseTextTheme.displayMedium?.copyWith(fontSize: 45.sp * fontScaleFactor),
      displaySmall: baseTextTheme.displaySmall?.copyWith(fontSize: 36.sp * fontScaleFactor),

      headlineLarge: baseTextTheme.headlineLarge?.copyWith(fontSize: 32.sp * fontScaleFactor),
      headlineMedium: baseTextTheme.headlineMedium?.copyWith(fontSize: 28.sp * fontScaleFactor),
      headlineSmall: baseTextTheme.headlineSmall?.copyWith(fontSize: 24.sp * fontScaleFactor),

      titleLarge: baseTextTheme.titleLarge?.copyWith(fontSize: 22.sp * fontScaleFactor),
      titleMedium: baseTextTheme.titleMedium?.copyWith(fontSize: 16.sp * fontScaleFactor),
      titleSmall: baseTextTheme.titleSmall?.copyWith(fontSize: 14.sp * fontScaleFactor),

      bodyLarge: baseTextTheme.bodyLarge?.copyWith(fontSize: 16.sp * fontScaleFactor),
      bodyMedium: baseTextTheme.bodyMedium?.copyWith(fontSize: 14.sp * fontScaleFactor),
      bodySmall: baseTextTheme.bodySmall?.copyWith(fontSize: 12.sp * fontScaleFactor),

      labelLarge: baseTextTheme.labelLarge?.copyWith(fontSize: 14.sp * fontScaleFactor),
      labelMedium: baseTextTheme.labelMedium?.copyWith(fontSize: 12.sp * fontScaleFactor),
      labelSmall: baseTextTheme.labelSmall?.copyWith(fontSize: 11.sp * fontScaleFactor),
    );
  }
}