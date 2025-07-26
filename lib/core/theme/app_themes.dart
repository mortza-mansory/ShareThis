// lib/core/theme/app_themes.dart
import 'package:flutter/material.dart';
import 'package:sharethis/core/utils/app_typography.dart';
import 'package:sharethis/core/utils/responsive_size.dart';
import 'package:provider/provider.dart'; // Import Provider to access ThemeProvider
import 'package:sharethis/core/providers/theme_provider.dart'; // Import ThemeProvider

class CustomAppThemes {
  static const Color primaryColor = Color(0xFF01497C);
  static const Color primaryVariantColor = Color(0xFF013A6B);
  static const Color secondaryColor = Color(0xFF2C7DA0);
  static const Color secondaryVariantColor = Color(0xFF2A6F97);
  static const Color accentColorLight = Color(0xFF61A5C2);
  static const Color accentColorLighter = Color(0xFF89C2D9);
  static const Color accentColorDark = Color(0xFF012A4A);

  static ThemeData _createTheme(BuildContext context, bool isDark) {
    final baseColorScheme = isDark ? ColorScheme.dark() : ColorScheme.light();
    final TextTheme baseTextTheme = isDark ? ThemeData.dark().textTheme : ThemeData.light().textTheme;

    // Get the fontScaleFactor from ThemeProvider
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false); // listen: false to avoid rebuilding ThemeProvider itself
    final double currentFontScaleFactor = themeProvider.fontScaleFactor;

    final Color scaffoldBgColor = isDark ? const Color(0xFF011525) : Colors.grey[100]!;

    final colorScheme = baseColorScheme.copyWith(
      primary: primaryColor,
      onPrimary: Colors.white,
      primaryContainer: primaryVariantColor,
      onPrimaryContainer: Colors.white,

      secondary: secondaryColor,
      onSecondary: Colors.white,
      secondaryContainer: secondaryVariantColor,
      onSecondaryContainer: Colors.white,

      tertiary: accentColorLight,
      onTertiary: Colors.black,

      surface: isDark ? accentColorDark : Colors.white,
      onSurface: isDark ? Colors.white70 : Colors.black87,

      background: isDark ? const Color(0xFF011C30) : accentColorLighter,
      onBackground: isDark ? Colors.white70 : Colors.black87,

      error: Colors.red.shade600,
      onError: Colors.white,

      surfaceVariant: isDark ? primaryVariantColor.withOpacity(0.5) : accentColorLighter.withOpacity(0.5),
      onSurfaceVariant: isDark ? Colors.white54 : Colors.black54,

      outline: primaryColor.withOpacity(0.5),
      shadow: isDark ? Colors.black.withOpacity(ResponsiveSize.isDesktop(context) ? 0.7 : 0.5) : Colors.grey.withOpacity(ResponsiveSize.isDesktop(context) ? 0.4 : 0.2),

      inverseSurface: isDark ? Colors.white : accentColorDark,
      onInverseSurface: isDark ? Colors.black : Colors.white,

      inversePrimary: isDark ? accentColorLight : primaryColor,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: scaffoldBgColor,
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.primary,
        foregroundColor: Colors.white,
        elevation: 4,
        centerTitle: true,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: colorScheme.secondary,
        foregroundColor: colorScheme.onSecondary,
      ),
      textTheme: AppTypography.createTextTheme(context, baseTextTheme, currentFontScaleFactor), // Pass fontScaleFactor
      buttonTheme: ButtonThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        buttonColor: colorScheme.secondary,
        textTheme: ButtonTextTheme.primary,
      ),
      cardTheme: CardThemeData(
        color: colorScheme.surface,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colorScheme.surfaceVariant.withOpacity(0.5),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: colorScheme.outline.withOpacity(0.5)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: colorScheme.primary, width: 2.0),
        ),
        labelStyle: TextStyle(color: colorScheme.onSurface),
        hintStyle: TextStyle(color: colorScheme.onSurface.withOpacity(0.6)),
      ),
    );
  }

  static ThemeData lightTheme(BuildContext context) => _createTheme(context, false);
  static ThemeData darkTheme(BuildContext context) => _createTheme(context, true);
}