import 'package:flutter/material.dart';

class AppSizes {
  AppSizes._();

  // Spacing & Padding (8-point grid system)
  static const double p4 = 4.0;
  static const double p8 = 8.0;
  static const double p12 = 12.0;
  static const double p16 = 16.0;
  static const double p20 = 20.0;
  static const double p24 = 24.0;
  static const double p32 = 32.0;
  static const double p48 = 48.0;
  static const double p64 = 64.0;

  // Border Radius
  static const double radiusSm = 4.0;
  static const double radiusMd = 8.0;
  static const double radiusLg = 12.0;
  static const double radiusXl = 16.0;
  static const double radiusMax = 999.0; // Fully rounded (pills/circles)

  // Icon Sizes
  static const double iconSm = 16.0;
  static const double iconMd = 24.0;
  static const double iconLg = 32.0;
  static const double iconXl = 48.0;

  // Common UI Elements
  static const double buttonHeight = 56.0;
  static const double cardElevation = 0.0; // Flat design for monochrome
  
  // Layout utilities
  static const gapH4 = SizedBox(width: p4);
  static const gapH8 = SizedBox(width: p8);
  static const gapH12 = SizedBox(width: p12);
  static const gapH16 = SizedBox(width: p16);
  static const gapH24 = SizedBox(width: p24);
  static const gapH32 = SizedBox(width: p32);

  static const gapV4 = SizedBox(height: p4);
  static const gapV8 = SizedBox(height: p8);
  static const gapV12 = SizedBox(height: p12);
  static const gapV16 = SizedBox(height: p16);
  static const gapV24 = SizedBox(height: p24);
  static const gapV32 = SizedBox(height: p32);
  static const gapV48 = SizedBox(height: p48);
}