import 'package:flutter/material.dart';
import 'package:rihl/core/app_colors.dart';
import 'package:rihl/core/constants.dart';

enum CustomButtonVariant { primary, secondary }

/// Full-width button used for every main action in the app.
///
/// While [isLoading] is true it shows a spinner and ignores taps.
class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = CustomButtonVariant.primary,
    this.isLoading = false,
    this.icon,
  });

  final String label;
  final VoidCallback? onPressed;
  final CustomButtonVariant variant;
  final bool isLoading;
  final IconData? icon;

  bool get _isPrimary => variant == CustomButtonVariant.primary;

  @override
  Widget build(BuildContext context) {
    final foreground = _isPrimary ? AppColors.surface : AppColors.primary;
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppSizes.borderRadius),
      side: _isPrimary
          ? BorderSide.none
          : const BorderSide(color: AppColors.primary),
    );

    final child = isLoading
        ? SizedBox(
            height: 22,
            width: 22,
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              color: foreground,
            ),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 20),
                const SizedBox(width: 8),
              ],
              Flexible(
                child: Text(
                  label,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: AppSizes.bodyLarge,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          );

    final VoidCallback? handler = isLoading ? null : onPressed;
    final size = const Size.fromHeight(AppSizes.buttonHeight);

    return SizedBox(
      width: double.infinity,
      height: AppSizes.buttonHeight,
      child: _isPrimary
          ? ElevatedButton(
              onPressed: handler,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: foreground,
                disabledBackgroundColor: isLoading
                    ? AppColors.primary
                    : AppColors.disabled,
                disabledForegroundColor: foreground,
                minimumSize: size,
                elevation: 0,
                shape: shape,
              ),
              child: child,
            )
          : OutlinedButton(
              onPressed: handler,
              style: OutlinedButton.styleFrom(
                foregroundColor: foreground,
                minimumSize: size,
                shape: shape,
              ),
              child: child,
            ),
    );
  }
}
