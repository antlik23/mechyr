import 'package:flutter/material.dart';
import 'package:uzis_app/core/constants/app_colors.dart';
import 'package:uzis_app/core/constants/app_styles.dart';

class CustomCheckbox extends StatelessWidget {
  const CustomCheckbox({
    super.key,
    required this.isChecked,
    required this.onChanged,
    this.circle = false,
  });

  final bool isChecked;
  final VoidCallback onChanged;
  final bool circle;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onChanged,
      child: Container(
        width: 20,
        height: 20,
        decoration: BoxDecoration(
          color: isChecked ? AppColors.darkBlueBase : AppColors.transparent,
          border: isChecked
              ? Border.all(color: AppColors.transparent)
              : Border.all(color: AppColors.darkBlueBase, width: 1),
          borderRadius: circle ? null : AppStyles.borderRadius.sm,
          shape: circle ? BoxShape.circle : BoxShape.rectangle,
        ),
        child: isChecked
            ? const Icon(
                Icons.check,
                color: AppColors.white,
                size: 16,
              )
            : null,
      ),
    );
  }
}
