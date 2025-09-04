import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class CustomCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? color;
  final double? elevation;
  final BorderRadius? borderRadius;
  final VoidCallback? onTap;
  final Border? border;
  final Gradient? gradient;

  const CustomCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.color,
    this.elevation = 2,
    this.borderRadius,
    this.onTap,
    this.border,
    this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveBorderRadius = borderRadius ?? BorderRadius.circular(16);

    Widget cardContent = Container(
      padding: padding ?? const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: gradient == null ? (color ?? AppColors.cardBackground) : null,
        gradient: gradient,
        borderRadius: effectiveBorderRadius,
        border: border,
      ),
      child: child,
    );

    if (onTap != null) {
      cardContent = Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: effectiveBorderRadius,
          child: cardContent,
        ),
      );
    }

    return Card(
      elevation: elevation,
      margin: margin ?? const EdgeInsets.all(8),
      shape: RoundedRectangleBorder(
        borderRadius: effectiveBorderRadius,
      ),
      child: cardContent,
    );
  }
}

class GradientCard extends StatelessWidget {
  final Widget child;
  final List<Color> gradientColors;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? elevation;
  final BorderRadius? borderRadius;
  final VoidCallback? onTap;

  const GradientCard({
    super.key,
    required this.child,
    required this.gradientColors,
    this.padding,
    this.margin,
    this.elevation = 4,
    this.borderRadius,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      padding: padding,
      margin: margin,
      elevation: elevation,
      borderRadius: borderRadius,
      onTap: onTap,
      gradient: LinearGradient(
        colors: gradientColors,
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      child: child,
    );
  }
}
