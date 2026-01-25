import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uzis_app/core/constants/app_colors.dart';
import 'package:uzis_app/core/constants/app_styles.dart';

class InputField extends StatelessWidget {
  const InputField({
    super.key,
    required this.controller,
    this.labelText,
    this.hintText,
    this.secondaryLabel,
    this.onSecondaryLabelTap,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.autovalidateMode = AutovalidateMode.disabled,
    this.inputFormatters,
    this.helperText,
    this.validator = _defaultValidator,
    this.isEnabled = true,
    this.onChanged,
  });

  final TextEditingController controller;
  final String? labelText;
  final String? hintText;
  final String? secondaryLabel;
  final VoidCallback? onSecondaryLabelTap;
  final bool obscureText;
  final TextInputType keyboardType;
  final AutovalidateMode autovalidateMode;
  final List<TextInputFormatter>? inputFormatters;
  final String? helperText;
  final String? Function(String?) validator;
  final bool isEnabled;
  final void Function(String?)? onChanged;

  static String? _defaultValidator(String? value) {
    if (value == null || value.isEmpty) {
      return "Vyplňte povinné pole";
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 8,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (labelText != null)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                labelText!,
                style: AppStyles.input.label,
              ),
            ],
          ),
        TextFormField(
          controller: controller,
          style:
              isEnabled ? AppStyles.input.text : AppStyles.input.disabledText,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: AppStyles.input.hint,
            helperText: helperText,
            helperStyle: AppStyles.input.hint,
            filled: true,
            fillColor: AppColors.white,
            border: OutlineInputBorder(
              borderRadius: AppStyles.borderRadius.md,
              borderSide: const BorderSide(
                color: AppColors.gray100,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: AppStyles.borderRadius.md,
              borderSide: const BorderSide(
                color: AppColors.gray100,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: AppStyles.borderRadius.md,
              borderSide: const BorderSide(
                color: AppColors.darkBlueBase,
                width: 2,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: AppStyles.borderRadius.md,
              borderSide: const BorderSide(
                color: AppColors.red,
              ),
            ),
            errorStyle: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: AppColors.red,
            ),
            errorMaxLines: 3,
            disabledBorder: OutlineInputBorder(
              borderRadius: AppStyles.borderRadius.md,
              borderSide: const BorderSide(
                color: AppColors.gray100,
              ),
            ),
          ),
          onTapOutside: (_) {
            FocusManager.instance.primaryFocus?.unfocus();
          },
          obscureText: obscureText,
          validator: validator,
          keyboardType: keyboardType,
          autovalidateMode: autovalidateMode,
          inputFormatters: inputFormatters,
          onChanged: onChanged,
          enabled: isEnabled,
        ),
        if (secondaryLabel != null)
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: onSecondaryLabelTap,
                child: Text(
                  secondaryLabel!,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.gray500,
                    fontWeight: FontWeight.w400,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
      ],
    );
  }
}
