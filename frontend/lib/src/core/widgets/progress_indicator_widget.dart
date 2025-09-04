import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

class CircularProgressWidget extends StatelessWidget {
  final double progress; // 0.0 to 1.0
  final double size;
  final double strokeWidth;
  final Color? backgroundColor;
  final Color? valueColor;
  final Widget? child;

  const CircularProgressWidget({
    super.key,
    required this.progress,
    this.size = 80,
    this.strokeWidth = 6,
    this.backgroundColor,
    this.valueColor,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CircularProgressIndicator(
            value: progress,
            strokeWidth: strokeWidth,
            backgroundColor: backgroundColor ?? AppColors.lightGray,
            valueColor: AlwaysStoppedAnimation<Color>(
              valueColor ?? AppColors.primary,
            ),
          ),
          if (child != null)
            child!
          else
            Text(
              '${(progress * 100).round()}%',
              style: AppTextStyles.bodyMedium.copyWith(
                fontWeight: FontWeight.bold,
                color: valueColor ?? AppColors.primary,
              ),
            ),
        ],
      ),
    );
  }
}

class LinearProgressWidget extends StatelessWidget {
  final double progress; // 0.0 to 1.0
  final String? label;
  final String? trailing;
  final Color? backgroundColor;
  final Color? valueColor;

  const LinearProgressWidget({
    super.key,
    required this.progress,
    this.label,
    this.trailing,
    this.backgroundColor,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null || trailing != null)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (label != null)
                Text(
                  label!,
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              if (trailing != null)
                Text(
                  trailing!,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
            ],
          ),
        if (label != null || trailing != null) const SizedBox(height: 8),
        
        LinearProgressIndicator(
          value: progress,
          backgroundColor: backgroundColor ?? AppColors.lightGray,
          valueColor: AlwaysStoppedAnimation<Color>(
            valueColor ?? AppColors.primary,
          ),
        ),
      ],
    );
  }
}

class StepProgressWidget extends StatelessWidget {
  final int currentStep;
  final int totalSteps;
  final List<String>? stepLabels;

  const StepProgressWidget({
    super.key,
    required this.currentStep,
    required this.totalSteps,
    this.stepLabels,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: List.generate(totalSteps, (index) {
            final isActive = index <= currentStep;
            final isCompleted = index < currentStep;
            
            return Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 4,
                      decoration: BoxDecoration(
                        color: isActive ? AppColors.primary : AppColors.lightGray,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  if (index < totalSteps - 1) const SizedBox(width: 4),
                ],
              ),
            );
          }),
        ),
        const SizedBox(height: 8),
        
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(totalSteps, (index) {
            final isActive = index <= currentStep;
            final isCompleted = index < currentStep;
            
            return Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: isCompleted 
                    ? AppColors.success 
                    : isActive 
                        ? AppColors.primary 
                        : AppColors.lightGray,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: isCompleted
                    ? const Icon(
                        Icons.check,
                        size: 16,
                        color: AppColors.textOnPrimary,
                      )
                    : Text(
                        '${index + 1}',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: isActive ? AppColors.textOnPrimary : AppColors.textSecondary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            );
          }),
        ),
        
        if (stepLabels != null) ...[
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: stepLabels!.asMap().entries.map((entry) {
              final index = entry.key;
              final label = entry.value;
              final isActive = index <= currentStep;
              
              return Expanded(
                child: Text(
                  label,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: isActive ? AppColors.primary : AppColors.textSecondary,
                    fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                  ),
                  textAlign: TextAlign.center,
                ),
              );
            }).toList(),
          ),
        ],
      ],
    );
  }
}
