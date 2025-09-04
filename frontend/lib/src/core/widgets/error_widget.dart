import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import 'custom_button.dart';

class AppErrorWidget extends StatelessWidget {
  final String title;
  final String message;
  final String? actionText;
  final VoidCallback? onAction;
  final IconData? icon;

  const AppErrorWidget({
    super.key,
    this.title = 'Something went wrong',
    required this.message,
    this.actionText = 'Retry',
    this.onAction,
    this.icon = Icons.error_outline,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 80,
              color: AppColors.error,
            ),
            const SizedBox(height: 24),
            
            Text(
              title,
              style: AppTextStyles.h3.copyWith(
                color: AppColors.error,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            
            Text(
              message,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            
            if (actionText != null && onAction != null) ...[
              const SizedBox(height: 32),
              CustomButton(
                text: actionText!,
                onPressed: onAction,
                type: ButtonType.outlined,
                width: 150,
                icon: Icons.refresh,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
