// lib/features/discovery_and_connection/presentation/pages/sender_scan_page.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:sharethis/core/routes/app_routes.dart';
import 'package:sizer/sizer.dart';
import 'package:sharethis/share/gradient_app_header.dart';
import 'package:sharethis/share/custom_text_widget.dart';
import 'package:sharethis/share/custom_button.dart';
import 'package:animate_do/animate_do.dart'; // For animations

class SenderScanPage extends StatelessWidget {
  const SenderScanPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Column(
        children: [
          GradientAppHeader(
            height: 15.h, // Consistent header height
            titleKey: 'sender_scan_title', // Localized title
            // No bottomWidget needed here
          ),
          Expanded(
            child: Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 5.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FadeInUp(
                      delay: const Duration(milliseconds: 300),
                      child: Icon(
                        Icons.wifi_tethering_rounded, // Icon for scanning/connection
                        size: 20.h, // Responsive icon size
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    SizedBox(height: 3.h),
                    FadeInUp(
                      delay: const Duration(milliseconds: 500),
                      child: CustomText(
                        'sender_scanning_message'.tr(), // Localized message
                        style: CustomTextStyle.headlineMedium,
                        color: theme.colorScheme.onBackground,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(height: 3.h),
                    FadeInUp(
                      delay: const Duration(milliseconds: 700),
                      child: CircularProgressIndicator(
                        color: theme.colorScheme.secondary,
                        strokeWidth: 0.8.w, // Responsive stroke width
                      ),
                    ),
                    SizedBox(height: 5.h),
                    FadeInUp(
                      delay: const Duration(milliseconds: 900),
                      child: CustomButton(
                        text: 'cancel_button'.tr(),
                        onPressed: () {
                          context.go(AppRouteNames.mainPage);
                        },
                        backgroundColor: theme.colorScheme.error,
                        foregroundColor: theme.colorScheme.onError,
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(60.w, 6.h),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}