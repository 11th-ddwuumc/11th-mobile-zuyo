import 'package:flutter/material.dart';
import 'package:movielog/theme/app_colors.dart';

class MovieLogButton extends StatelessWidget {
  const MovieLogButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.width,
    this.disabledBackgroundColor = AppColors.buttonLoading,
    this.backgroundColor = AppColors.primary500,
    this.foregroundColor = AppColors.lowest,
    this.borderRadius = 12,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final double? width;
  final Color disabledBackgroundColor;
  final Color backgroundColor;
  final Color foregroundColor;
  final double borderRadius;

  bool get _disabled => isLoading || onPressed == null;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: 44,
      child: ElevatedButton(
        onPressed: _disabled ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          disabledBackgroundColor: disabledBackgroundColor,
          foregroundColor: foregroundColor,
          disabledForegroundColor: AppColors.lowest,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ),
        child: isLoading
            ? SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                  semanticsLabel: label,
                  strokeWidth: 2,
                  color: AppColors.lowest,
                ),
              )
            : Text(label),
      ),
    );
  }
}
