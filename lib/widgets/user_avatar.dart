import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// A circular avatar showing a person's initial (or an explicit label).
class UserAvatar extends StatelessWidget {
  const UserAvatar({
    super.key,
    required this.label,
    this.radius = 24,
    this.backgroundColor = AppColors.brand,
    this.foregroundColor = Colors.white,
  });

  final String label;
  final double radius;
  final Color backgroundColor;
  final Color foregroundColor;

  /// Avatar tinted with the theme's primary container color.
  factory UserAvatar.tonal(
    BuildContext context, {
    Key? key,
    required String label,
    double radius = 24,
  }) {
    final scheme = Theme.of(context).colorScheme;
    return UserAvatar(
      key: key,
      label: label,
      radius: radius,
      backgroundColor: scheme.primaryContainer,
      foregroundColor: scheme.onPrimaryContainer,
    );
  }

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: backgroundColor,
      child: Text(
        label,
        style: TextStyle(
          color: foregroundColor,
          fontWeight: FontWeight.bold,
          fontSize: radius * 0.8,
        ),
      ),
    );
  }
}
