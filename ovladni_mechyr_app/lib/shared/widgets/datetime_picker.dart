import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:uzis_app/core/constants/app_colors.dart';
import 'package:uzis_app/core/constants/app_styles.dart';

class DateTimePicker extends StatefulWidget {
  DateTimePicker({
    super.key,
    required this.controller,
    this.labelText,
    this.hintText,
    this.helperText,
    this.helpText,
    this.isTimePicker = false,
    DateTime? initialDateTime,
    TimeOfDay? initialTime,
    this.minDateTime,
    this.maxDateTime,
    this.validator = _defaultValidator,
    this.isEnabled = true,
    this.onChanged,
  })  : initialDateTime = initialDateTime ?? DateTime.now(),
        initialTime = initialTime ?? TimeOfDay.now();

  final TextEditingController controller;
  final String? labelText;
  final String? hintText;
  final String? helperText;
  final String? helpText;
  final bool isTimePicker;
  final DateTime initialDateTime;
  final TimeOfDay initialTime;
  final DateTime? minDateTime;
  final DateTime? maxDateTime;
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
  State<DateTimePicker> createState() => _DateTimePickerState();
}

class _DateTimePickerState extends State<DateTimePicker> {
  late DateTime currentDateTime;
  late TimeOfDay currentTime;

  @override
  void initState() {
    super.initState();
    if (!widget.isTimePicker) initDateTimeValue();
  }

  void handleOnChangedDateTime(DateTime pickedDateTime) {
    String formattedDateTime = DateFormat('d. M. yyyy').format(pickedDateTime);

    setState(() {
      widget.controller.text = formattedDateTime;
      widget.onChanged?.call(formattedDateTime);
    });
  }

  void initDateTimeValue() {
    if (widget.controller.text.isEmpty) {
      currentDateTime = widget.initialDateTime;
      return;
    }

    DateTime parsedDate =
        DateFormat("d. M. yyyy").parse(widget.controller.text);
    if (widget.maxDateTime != null && parsedDate.isAfter(widget.maxDateTime!)) {
      currentDateTime = widget.maxDateTime!;
    } else if (widget.minDateTime != null &&
        parsedDate.isBefore(widget.minDateTime!)) {
      currentDateTime = widget.minDateTime!;
    } else {
      currentDateTime = parsedDate;
    }
    handleOnChangedDateTime(currentDateTime);
  }

  Future<void> openDatePicker() async {
    initDateTimeValue();

    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      initialDate: currentDateTime,
      firstDate: widget.minDateTime ?? DateTime(2000),
      lastDate: widget.maxDateTime ??
          currentDateTime.add(const Duration(days: 365 * 5)),
      helpText: widget.helpText ?? "Vyberte datum",
      confirmText: "Potvrdit",
      cancelText: "Zavřít",
    );
    if (pickedDate == null) return;
    handleOnChangedDateTime(pickedDate);
  }

  void initTimeValue() {
    if (widget.controller.text.isNotEmpty) {
      DateTime parsedTime = DateFormat("HH:mm").parse(widget.controller.text);
      currentTime = TimeOfDay.fromDateTime(parsedTime);
      return;
    } else {
      currentTime = widget.initialTime;
    }
  }

  void handleOnChangedTime(TimeOfDay pickedTime) {
    String formattedTime = pickedTime.format(context);
    setState(() {
      widget.controller.text = formattedTime;
      widget.onChanged?.call(formattedTime);
    });
  }

  Future<void> openTimePicker() async {
    initTimeValue();
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialEntryMode: TimePickerEntryMode.inputOnly,
      initialTime: currentTime,
      helpText: widget.helpText ?? "Zadejte čas",
      confirmText: "Potvrdit",
      cancelText: "Zavřít",
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child!,
        );
      },
    );

    if (pickedTime == null) return;
    handleOnChangedTime(pickedTime);
  }

  Future<void> openPicker() async {
    if (widget.isTimePicker) {
      await openTimePicker();
    } else {
      await openDatePicker();
    }
  }

  @override
  Widget build(BuildContext context) {
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
          onTap: openPicker,
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
              child: SvgPicture.asset(
                widget.isTimePicker
                    ? "assets/icons/Clock5.svg"
                    : "assets/icons/CalendarDays.svg",
                colorFilter: ColorFilter.mode(
                  widget.isEnabled ? AppColors.gray500 : AppColors.gray400,
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
