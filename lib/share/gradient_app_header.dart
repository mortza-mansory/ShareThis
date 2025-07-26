import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sharethis/share/custom_text_widget.dart';
import 'package:sizer/sizer.dart';
import 'package:provider/provider.dart';
import 'package:sharethis/core/providers/theme_provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../features/file_selection/presentaion/bloc/global_file_selection/global_file_selection_bloc.dart';
import '../features/file_selection/presentaion/bloc/global_file_selection/global_file_selection_state.dart';
// import 'package:sharethis/share/selected_files_modal_sheet.dart'; // دیگر نیازی به این import نیست

class GradientAppHeader extends StatelessWidget {
  final double height;
  final String titleKey;
  final Widget? bottomWidget;
  final bool showGlobalSelectionCounter;
  final Function(int count)? onGlobalSelectionTap; // جدید: callback برای کلیک روی نشانگر

  const GradientAppHeader({
    super.key,
    required this.height,
    required this.titleKey,
    this.bottomWidget,
    this.showGlobalSelectionCounter = false,
    this.onGlobalSelectionTap, // اضافه شده
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Container(
      height: height,
      width: 100.w,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            theme.colorScheme.primaryContainer.withOpacity(0.8),
            theme.colorScheme.primary.withOpacity(0.6),
            theme.colorScheme.secondaryContainer.withOpacity(0.7),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(5,5,5,0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (GoRouter.of(context).canPop())
                    IconButton(
                      onPressed: () {
                        context.pop();
                      },
                      icon: Icon(Icons.arrow_back_ios, color: theme.colorScheme.onPrimaryContainer),
                    )
                  else
                    SizedBox(width: 8.w),

                  Expanded(
                    child: CustomText(
                      titleKey.tr(),
                      style: CustomTextStyle.titleLarge,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onPrimaryContainer,
                      textAlign: (GoRouter.of(context).canPop() || showGlobalSelectionCounter) ? TextAlign.start : TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),

                  // نشانگر تعداد فایل‌های انتخاب شده سراسری
                  if (showGlobalSelectionCounter)
                    BlocBuilder<GlobalFileSelectionBloc, GlobalFileSelectionState>(
                      builder: (context, state) {
                        final count = state.selectedFiles.length;
                        return GestureDetector(
                          onTap: () {
                            if (onGlobalSelectionTap != null) {
                              onGlobalSelectionTap!(count); // فراخوانی callback
                            } else if (count > 0) {
                              // اگر callback تنظیم نشده بود، به صورت پیش‌فرض یک SnackBar نمایش بده
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Selected files: $count')),
                              );
                            }
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                            decoration: BoxDecoration(
                              color: count > 0 ? theme.colorScheme.secondary : theme.colorScheme.surfaceVariant.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(20.0),
                              border: Border.all(color: theme.colorScheme.onPrimaryContainer.withOpacity(0.5)),
                            ),
                            child: CustomText(
                              count.toString(),
                              style: CustomTextStyle.labelLarge,
                              color: count > 0 ? theme.colorScheme.onSecondary : theme.colorScheme.onSurfaceVariant,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                      },
                    ),
                ],
              ),
              if (bottomWidget != null)
                Expanded(
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: bottomWidget!,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}