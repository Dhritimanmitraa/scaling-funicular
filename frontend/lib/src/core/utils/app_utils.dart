import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_colors.dart';

class AppUtils {
  // Haptic Feedback
  static void lightHaptic() {
    HapticFeedback.lightImpact();
  }

  static void mediumHaptic() {
    HapticFeedback.mediumImpact();
  }

  static void heavyHaptic() {
    HapticFeedback.heavyImpact();
  }

  static void selectionHaptic() {
    HapticFeedback.selectionClick();
  }

  // Snackbar Helpers
  static void showSuccessSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  static void showErrorSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.error,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        action: SnackBarAction(
          label: 'Dismiss',
          textColor: AppColors.textOnPrimary,
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );
  }

  static void showInfoSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.info,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  // Dialog Helpers
  static Future<bool?> showConfirmDialog(
    BuildContext context, {
    required String title,
    required String content,
    String confirmText = 'Confirm',
    String cancelText = 'Cancel',
    bool isDestructive = false,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(cancelText),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(
              confirmText,
              style: TextStyle(
                color: isDestructive ? AppColors.error : AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Focus Helpers
  static void unfocus(BuildContext context) {
    FocusScope.of(context).unfocus();
  }

  static void focusNext(BuildContext context) {
    FocusScope.of(context).nextFocus();
  }

  // Screen Size Helpers
  static Size getScreenSize(BuildContext context) {
    return MediaQuery.of(context).size;
  }

  static bool isSmallScreen(BuildContext context) {
    return getScreenSize(context).width < 600;
  }

  static bool isTablet(BuildContext context) {
    return getScreenSize(context).width >= 600;
  }

  // Safe Area Helpers
  static EdgeInsets getSafeAreaInsets(BuildContext context) {
    return MediaQuery.of(context).padding;
  }

  // Theme Helpers
  static bool isDarkMode(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark;
  }

  // Number Formatters
  static String formatNumber(int number) {
    if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(1)}M';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}K';
    }
    return number.toString();
  }

  static String formatPercentage(double value) {
    return '${(value * 100).round()}%';
  }

  // Debounce Helper
  static Timer? _debounceTimer;
  
  static void debounce(Duration delay, VoidCallback callback) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(delay, callback);
  }

  // Log Helper
  static void log(String message, {String? tag}) {
    debugPrint('[${tag ?? 'APP'}] $message');
  }
}

class Timer {
  static Timer periodic(Duration period, void Function(Timer) callback) {
    return Timer.periodic(period, callback);
  }

  static Timer(Duration duration, VoidCallback callback) {
    return Timer(duration, callback);
  }

  void cancel() {
    // Implementation would be here
  }
}
