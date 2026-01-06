import 'package:flutter/material.dart';
import 'package:uzis_app/core/constants/app_colors.dart';
import 'package:uzis_app/core/constants/app_styles.dart';

class ButtonOutlined extends StatelessWidget {
  const ButtonOutlined({
    super.key,
    required this.text,
    required this.onPressed,
    this.isDisabled = false,
    this.isLoading = false,
  });

  final String text;
  final VoidCallback onPressed;
  final bool isDisabled;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final bool shouldDisable = isDisabled || isLoading;
    Color borderColor =
        shouldDisable ? AppColors.darkBlueBase50 : AppColors.darkBlueBase;
    Color textColor =
        shouldDisable ? AppColors.darkBlueBase50 : AppColors.darkBlueBase;

    return OutlinedButton(
      onPressed: shouldDisable ? null : onPressed,
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all(AppColors.white),
        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: AppStyles.borderRadius.md,
          ),
        ),
        padding: WidgetStateProperty.all(
          const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        ),
        side: WidgetStateProperty.all(
          BorderSide(color: borderColor),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (!isLoading)
            Text(
              text,
              style: TextStyle(
                fontSize: 14,
                color: textColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          if (isLoading)
            const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                color: AppColors.darkBlueBase50,
                strokeWidth: 2,
              ),
            ),
        ],
      ),
    );
  }
}
