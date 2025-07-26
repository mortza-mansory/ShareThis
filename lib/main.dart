// lib/main.dart
import 'package:flutter/material.dart';
import 'package:sharethis/core/di/injection_container.dart' as di;
import 'package:sharethis/core/providers/app_providers.dart';
import 'package:sharethis/core/providers/theme_provider.dart';
import 'package:sharethis/core/routes/app_routes.dart';
import 'package:sharethis/core/theme/app_themes.dart';
import 'package:sizer/sizer.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await di.init();
  runApp(
    EasyLocalization(
      supportedLocales: const [
        Locale('en'),
        Locale('fa'),
      ],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AppProviders(
      child: Sizer(
        builder: (context, orientation, deviceType) {
          return ChangeNotifierProvider(
            create: (context) => ThemeProvider(),
            child: Builder(
              builder: (innerContext) {
                final themeProvider = Provider.of<ThemeProvider>(innerContext);
                return MaterialApp.router(
                  title: 'app_title'.tr(),
                  debugShowCheckedModeBanner: false,
                  theme: CustomAppThemes.lightTheme(innerContext),
                  darkTheme: CustomAppThemes.darkTheme(innerContext),
                  themeMode: themeProvider.themeMode,
                  routerConfig: appRouter,
                  locale: innerContext.locale,
                  supportedLocales: innerContext.supportedLocales,
                  localizationsDelegates: innerContext.localizationDelegates,
                );
              },
            ),
          );
        },
      ),
    );
  }
}