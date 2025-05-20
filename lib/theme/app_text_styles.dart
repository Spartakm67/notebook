import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppTextStyles {
  static ThemeData _theme(BuildContext context) => Theme.of(context);

  static TextStyle bigCardTextStyle(BuildContext context) {
    final theme = _theme(context);
    return theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.onPrimary,
      fontWeight: FontWeight.bold,
      fontSize: 24.sp,
      letterSpacing: 2.0.w,
    );
  }

  static TextStyle buttonTextStyle(BuildContext context) {
    final theme = _theme(context);
    return theme.textTheme.labelLarge!.copyWith(
      fontSize: 16.sp,
      fontWeight: FontWeight.w600,
      color: theme.colorScheme.primary,
    );
  }

  static TextStyle titleStyle(BuildContext context) {
    final theme = _theme(context);
    return theme.textTheme.titleLarge!.copyWith(
      fontSize: 20.sp,
      fontWeight: FontWeight.w700,
      color: theme.colorScheme.primary,
    );
  }

  static TextStyle pureTextStyle(BuildContext context) {
    final theme = _theme(context);
    return theme.textTheme.titleLarge!.copyWith(
      fontSize: 16.sp,
      fontWeight: FontWeight.w700,
      color: theme.colorScheme.primary,
    );
  }
}
