import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:sharethis/core/utils/responsive_size.dart';

class CustomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onItemSelected;

  const CustomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    double fixedWidth = 35.w;
    double bottomPadding = 3.h;

    return Padding(
      padding: EdgeInsets.only(bottom: bottomPadding),
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: fixedWidth),
          child: Material(
            elevation: 12.0,
            borderRadius: BorderRadius.circular(30.0),
            color: theme.colorScheme.surface.withOpacity(0.95),
            shadowColor: theme.colorScheme.shadow,
            child: Container(
              height: 7.h,
              padding: EdgeInsets.symmetric(horizontal: 5.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.home_rounded,
                      size: 7.w,
                      color: currentIndex == 0
                          ? theme.colorScheme.primary
                          : theme.colorScheme.onSurface.withOpacity(0.6),
                    ),
                    onPressed: () => onItemSelected(0),
                    tooltip: 'home_tab'.tr(),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.settings_rounded,
                      size: 7.w,
                      color: currentIndex == 1
                          ? theme.colorScheme.primary
                          : theme.colorScheme.onSurface.withOpacity(0.6),
                    ),
                    onPressed: () => onItemSelected(1),
                    tooltip: 'settings_tab'.tr(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}