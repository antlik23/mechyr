import 'package:flutter/material.dart';
import 'package:uzis_app/core/constants/app_colors.dart';
import 'package:uzis_app/core/constants/app_styles.dart';

class Button extends StatelessWidget {
  const Button({
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
    Color bgColor =
        shouldDisable ? AppColors.darkBlueBase50 : AppColors.darkBlueBase;

    return TextButton(
      onPressed: shouldDisable ? null : onPressed,
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all(bgColor),
        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: AppStyles.borderRadius.md,
          ),
        ),
        padding: WidgetStateProperty.all(
          const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (!isLoading)
            SizedBox(
              height: 20,
              child: Text(
                text,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          if (isLoading)
            const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                color: AppColors.white,
                strokeWidth: 2,
              ),
            ),
        ],
      ),
    );
  }
}
