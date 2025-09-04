import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

enum ButtonType { primary, secondary, outlined }

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final ButtonType type;
  final IconData? icon;
  final double? width;
  final double? height;

  const CustomButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.type = ButtonType.primary,
    this.icon,
    this.width,
    this.height = 48,
  });

  @override
  Widget build(BuildContext context) {
    final isEnabled = onPressed != null && !isLoading;

    return SizedBox(
      width: width ?? double.infinity,
      height: height,
      child: _buildButton(isEnabled),
    );
  }

  Widget _buildButton(bool isEnabled) {
    switch (type) {
      case ButtonType.primary:
        return ElevatedButton(
          onPressed: isEnabled ? onPressed : null,
          child: _buildButtonContent(),
        );
      case ButtonType.secondary:
        return ElevatedButton(
          onPressed: isEnabled ? onPressed : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.secondary,
          ),
          child: _buildButtonContent(),
        );
      case ButtonType.outlined:
        return OutlinedButton(
          onPressed: isEnabled ? onPressed : null,
          child: _buildButtonContent(),
        );
    }
  }

  Widget _buildButtonContent() {
    if (isLoading) {
      return const SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(AppColors.textOnPrimary),
        ),
      );
    }

    if (icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 20),
          const SizedBox(width: 8),
          Text(
            text,
            style: _getTextStyle(),
          ),
        ],
      );
    }

    return Text(
      text,
      style: _getTextStyle(),
    );
  }

  TextStyle _getTextStyle() {
    switch (type) {
      case ButtonType.primary:
      case ButtonType.secondary:
        return AppTextStyles.buttonLarge;
      case ButtonType.outlined:
        return AppTextStyles.buttonLarge.copyWith(
          color: AppColors.primary,
        );
    }
  }
}
