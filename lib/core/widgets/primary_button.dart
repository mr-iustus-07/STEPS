import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_sizes.dart';

class PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isOutlined;
  final IconData? icon;

  const PrimaryButton({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
    this.isOutlined = false,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    // Disable button if it's loading or explicitly disabled (onPressed == null)
    final bool isDisabled = onPressed == null || isLoading;

    final Widget buttonContent = Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (isLoading) ...[
          SizedBox(
            height: AppSizes.iconSm,
            width: AppSizes.iconSm,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: isOutlined ? AppColors.textPrimary : AppColors.background,
            ),
          ),
          AppSizes.gapH12,
        ] else if (icon != null) ...[
          Icon(icon, size: AppSizes.iconMd),
          AppSizes.gapH8,
        ],
        Text(
          label.toUpperCase(),
          style: theme.textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
            color: isDisabled 
                ? AppColors.textDisabled 
                : (isOutlined ? AppColors.textPrimary : AppColors.background),
          ),
        ),
      ],
    );

    if (isOutlined) {
      return OutlinedButton(
        onPressed: isDisabled ? null : onPressed,
        style: OutlinedButton.styleFrom(
          minimumSize: const Size.fromHeight(AppSizes.buttonHeight),
          side: BorderSide(
            color: isDisabled ? AppColors.border : AppColors.accent,
            width: 1.5,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.radiusMd),
          ),
        ),
        child: buttonContent,
      );
    }

    return ElevatedButton(
      onPressed: isDisabled ? null : onPressed,
      style: ElevatedButton.styleFrom(
        minimumSize: const Size.fromHeight(AppSizes.buttonHeight),
        backgroundColor: AppColors.accent,
        disabledBackgroundColor: AppColors.surfaceHighlight,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        ),
      ),
      child: buttonContent,
    );
  }
}