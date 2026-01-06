import 'package:flutter/material.dart';
import 'package:uzis_app/core/constants/app_colors.dart';

class AppStyles {
  static const text = _TextStyles();
  static const input = _InputStyles();
  static const borderRadius = _BorderRadius();
  static const table = _DataTable();
}

class _TextStyles {
  const _TextStyles();

  TextStyle get header => const TextStyle(
        fontSize: 36,
        color: AppColors.darkBlueBase,
        fontWeight: FontWeight.w800,
      );

  TextStyle get title => const TextStyle(
        fontSize: 18,
        color: AppColors.darkBlueBase,
        fontWeight: FontWeight.w600,
      );
}

class _InputStyles {
  const _InputStyles();

  TextStyle get text => const TextStyle(
        fontSize: 16,
        color: AppColors.gray900,
        fontWeight: FontWeight.w500,
      );

  TextStyle get disabledText => const TextStyle(
        fontSize: 16,
        color: AppColors.gray400,
        fontWeight: FontWeight.w500,
      );

  TextStyle get label => const TextStyle(
        fontSize: 18,
        color: Color(0xFF18181B),
        fontWeight: FontWeight.w500,
      );

  TextStyle get hint => const TextStyle(
        fontSize: 14,
        color: Color(0xFF888888),
        fontWeight: FontWeight.w400,
      );
}

class _BorderRadius {
  const _BorderRadius();

  BorderRadius get sm => BorderRadius.circular(4);
  BorderRadius get md => BorderRadius.circular(6);
  BorderRadius get lg => BorderRadius.circular(8);
  BorderRadius get xl => BorderRadius.circular(12);
}

class _DataTable {
  const _DataTable();

  TextStyle get column => const TextStyle(
        fontSize: 14,
        color: AppColors.darkBlueBase,
        fontWeight: FontWeight.w500,
      );

  TextStyle get row => const TextStyle(
        fontSize: 14,
        color: AppColors.gray800,
        fontWeight: FontWeight.w500,
      );
}
