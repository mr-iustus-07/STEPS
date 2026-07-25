import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_sizes.dart';

extension BuildContextExtensions on BuildContext {
  // --- Theme & Typography Shortcuts ---
  ThemeData get theme => Theme.of(this);
  TextTheme get textTheme => theme.textTheme;
  ColorScheme get colorScheme => theme.colorScheme;

  // --- Layout Shortcuts ---
  MediaQueryData get mediaQuery => MediaQuery.of(this);
  Size get screenSize => mediaQuery.size;
  double get screenWidth => screenSize.width;
  double get screenHeight => screenSize.height;

  // --- Keyboard & Focus ---
  void unfocus() => FocusScope.of(this).unfocus();

  // --- System Messages (Snackbars) ---
  /// Displays a strict, monochrome notification overlay at the bottom of the screen.
  void showSystemMessage(String message, {bool isError = false}) {
    ScaffoldMessenger.of(this)
      ..hideCurrentSnackBar() // Prevents spamming
      ..showSnackBar(
        SnackBar(
          content: Text(
            message.toUpperCase(),
            style: textTheme.bodyMedium?.copyWith(
              color: isError ? AppColors.background : AppColors.textPrimary,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.0,
            ),
          ),
          backgroundColor: isError ? AppColors.error : AppColors.surfaceHighlight,
          behavior: SnackBarBehavior.floating,
          elevation: 0,
          margin: const EdgeInsets.all(AppSizes.p16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.radiusMd),
            side: BorderSide(
              color: isError ? AppColors.error : AppColors.border,
              width: 1,
            ),
          ),
          duration: const Duration(seconds: 3),
        ),
      );
  }
}