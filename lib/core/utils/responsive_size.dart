import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class ResponsiveSize {
  static const double _mobileMaxWidth = 600.0;
  static const double _tabletMaxWidth = 1200.0;

  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < _mobileMaxWidth;
  }

  static bool isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= _mobileMaxWidth && width < _tabletMaxWidth;
  }

  static bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= _tabletMaxWidth;
  }

  static EdgeInsets getScreenPadding(BuildContext context) {
    if (isDesktop(context)) {
      return EdgeInsets.symmetric(horizontal: 15.w, vertical: 4.h);
    } else if (isTablet(context)) {
      return EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h);
    } else {
      return EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h);
    }
  }
}