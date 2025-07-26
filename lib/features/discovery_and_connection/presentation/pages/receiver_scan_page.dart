import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:sharethis/core/routes/app_routes.dart';
import 'package:sizer/sizer.dart';
import 'package:sharethis/share/gradient_app_header.dart';
import 'package:sharethis/share/custom_text_widget.dart';
import 'package:sharethis/share/custom_button.dart';
import 'package:animate_do/animate_do.dart';

class ReceiverScanPage extends StatelessWidget {
  const ReceiverScanPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Column(
        children: [
          GradientAppHeader(
            height: 15.h,
            titleKey: 'receiver_scan_title',
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
                        Icons.devices_other_rounded, // Icon for waiting for connection
                        size: 20.h,
                        color: theme.colorScheme.secondary,
                      ),
                    ),
                    SizedBox(height: 3.h),
                    FadeInUp(
                      delay: const Duration(milliseconds: 500),
                      child: CustomText(
                        'receiver_waiting_message'.tr(), // Localized message
                        style: CustomTextStyle.headlineMedium,
                        color: theme.colorScheme.onBackground,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(height: 3.h),
                    FadeInUp(
                      delay: const Duration(milliseconds: 700),
                      child: CircularProgressIndicator(
                        color: theme.colorScheme.primary,
                        strokeWidth: 0.8.w,
                      ),
                    ),
                    SizedBox(height: 5.h),
                    FadeInUp(
                      delay: const Duration(milliseconds: 900),
                      child: CustomButton(
                        text: 'cancel_button'.tr(),
                        onPressed: () {
                          context.go(AppRouteNames.mainPage); // Go back to main page
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