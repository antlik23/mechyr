import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:uzis_app/core/constants/app_colors.dart';
import 'package:uzis_app/core/constants/app_styles.dart';

class DatePickerInput extends StatefulWidget {
  const DatePickerInput({
    super.key,
    required this.controller,
    this.labelText,
    this.hintText,
    this.helperText,
    this.isTimePicker = false,
    this.initialDateTime,
    this.minDateTime,
    this.validator = _defaultValidator,
    this.isEnabled = true,
    this.onChanged,
  });

  final TextEditingController controller;
  final String? labelText;
  final String? hintText;
  final String? helperText;
  final bool isTimePicker;
  final DateTime? initialDateTime;
  final DateTime? minDateTime;
  final String? Function(String?) validator;
  final bool isEnabled;
  final Function(String)? onChanged;

  static String? _defaultValidator(String? value) {
    if (value == null || value.isEmpty) {
      return "Vyplňte povinné pole";
    }
    return null;
  }

  @override
  State<DatePickerInput> createState() => _DatePickerInputState();
}

class _DatePickerInputState extends State<DatePickerInput> {
  @override
  Widget build(BuildContext context) {
    DateTime currentDateTime = widget.initialDateTime ?? DateTime.now();

    void handleOnChangedDateTime() {
      String formattedDateTime = widget.isTimePicker
          ? DateFormat("HH:mm").format(currentDateTime)
          : DateFormat('d. M. yyyy').format(currentDateTime);

      widget.controller.text = formattedDateTime;
      widget.onChanged?.call(formattedDateTime);
    }

    void initDateTimeValue() {
      if (widget.controller.text.isNotEmpty) return;
      handleOnChangedDateTime();
    }

    return Column(
      spacing: 8,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (widget.labelText != null)
              Text(
                widget.labelText!,
                style: AppStyles.input.label,
              ),
          ],
        ),
        TextFormField(
          onTap: () {
            initDateTimeValue();
            showCupertinoModalPopup(
              context: context,
              builder: (context) {
                return CupertinoActionSheet(
                  actions: [
                    SizedBox(
                      height: 180,
                      child: CupertinoDatePicker(
                        dateOrder: DatePickerDateOrder.dmy,
                        mode: widget.isTimePicker
                            ? CupertinoDatePickerMode.time
                            : CupertinoDatePickerMode.date,
                        initialDateTime: currentDateTime,
                        showDayOfWeek: false,
                        use24hFormat: true,
                        minimumDate: widget.minDateTime,
                        onDateTimeChanged: (DateTime newDate) {
                          setState(() {
                            currentDateTime = newDate;
                            handleOnChangedDateTime();
                          });
                        },
                      ),
                    ),
                  ],
                  cancelButton: CupertinoActionSheetAction(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text(
                      'Zavřít',
                      style: TextStyle(
                        color: AppColors.red,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                );
              },
            );
          },
          controller: widget.controller,
          style: widget.isEnabled
              ? AppStyles.input.text
              : AppStyles.input.disabledText,
          decoration: InputDecoration(
            helperText: widget.helperText,
            helperStyle: AppStyles.input.hint,
            hintText: widget.hintText,
            hintStyle: AppStyles.input.hint,
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
            suffixIcon: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: widget.isTimePicker
                  ? SvgPicture.asset(
                      "assets/icons/Clock5.svg",
                      colorFilter: ColorFilter.mode(
                        widget.isEnabled
                            ? AppColors.gray500
                            : AppColors.gray400,
                        BlendMode.srcIn,
                      ),
                    )
                  : SvgPicture.asset(
                      "assets/icons/CalendarDays.svg",
                      colorFilter: ColorFilter.mode(
                        widget.isEnabled
                            ? AppColors.gray500
                            : AppColors.gray400,
                        BlendMode.srcIn,
                      ),
                    ),
            ),
          ),
          onTapOutside: (_) {
            FocusManager.instance.primaryFocus?.unfocus();
          },
          validator: widget.validator,
          readOnly: true,
          enabled: widget.isEnabled,
        ),
      ],
    );
  }
}
