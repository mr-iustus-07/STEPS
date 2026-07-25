import 'package:flutter/material.dart';

class ResponsiveLayout extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget desktop;

  const ResponsiveLayout({
    super.key,
    required this.mobile,
    this.tablet,
    required this.desktop,
  });

  // Locked Professional Breakpoints
  static const double mobileLimit = 768.0;
  static const double tabletLimit = 1200.0;

  static bool isMobile(BuildContext context) =>
      MediaQuery.sizeOf(context).width < mobileLimit;

  static bool isTablet(BuildContext context) =>
      MediaQuery.sizeOf(context).width >= mobileLimit &&
      MediaQuery.sizeOf(context).width < tabletLimit;

  static bool isDesktop(BuildContext context) =>
      MediaQuery.sizeOf(context).width >= tabletLimit;

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.sizeOf(context).width;
    
    if (width >= tabletLimit) {
      return desktop;
    } else if (width >= mobileLimit && tablet != null) {
      return tablet!;
    } else {
      return mobile;
    }
  }
}