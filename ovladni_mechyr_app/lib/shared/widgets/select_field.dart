import 'package:flutter/material.dart';
import 'package:uzis_app/core/constants/app_colors.dart';
import 'package:uzis_app/core/constants/app_styles.dart';

class SelectField<T> extends StatelessWidget {
  const SelectField({
    super.key,
    required this.items,
    required this.formattedString,
    this.value,
    this.labelText,
    this.hintText,
    this.isEnabled = true,
    this.onChanged,
    this.validator,
  });

  final List<T> items;
  final String Function(T) formattedString;
  final T? value;
  final String? labelText;
  final String? hintText;
  final bool isEnabled;
  final void Function(T?)? onChanged;
  final String? Function(T?)? validator;

  static String? _defaultValidator<T>(T? value) {
    if (value == null) {
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
        if (labelText != null) ...[
          Text(
            labelText!,
            style: AppStyles.input.label,
          ),
        ],
        DropdownButtonFormField<T>(
          decoration: InputDecoration(
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
            enabled: isEnabled,
          ),
          value: value,
          onChanged: isEnabled ? onChanged : null,
          items: items.map((T item) {
            return DropdownMenuItem<T>(
              value: item,
              child: Text(
                formattedString(item),
                style: isEnabled
                    ? AppStyles.input.text
                    : AppStyles.input.disabledText,
              ),
            );
          }).toList(),
          dropdownColor: AppColors.white,
          hint: hintText != null
              ? Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    hintText!,
                    style: AppStyles.input.hint,
                  ),
                )
              : null,
          validator: validator ?? _defaultValidator,
        ),
      ],
    );
  }
}
