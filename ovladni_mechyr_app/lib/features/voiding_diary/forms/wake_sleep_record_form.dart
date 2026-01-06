import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uzis_app/core/constants/app_colors.dart';
import 'package:uzis_app/features/voiding_diary/models/voiding_diary_model.dart';
import 'package:uzis_app/shared/widgets/datetime_picker.dart';

class WakeSleepForm extends StatelessWidget {
  const WakeSleepForm({
    super.key,
    required this.formKey,
    required this.sleepTimeDayOne,
    required this.wakeupTimeDayOne,
    required this.sleepTimeDayTwo,
    required this.wakeupTimeDayTwo,
    required this.isEnabled,
    required this.isLoading,
    required this.days,
    required this.voidingDiary,
    this.isEnd = false,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController sleepTimeDayOne;
  final TextEditingController wakeupTimeDayOne;
  final TextEditingController sleepTimeDayTwo;
  final TextEditingController wakeupTimeDayTwo;
  final bool isEnabled;
  final bool isLoading;
  final int days;
  final VoidingDiary voidingDiary;
  final bool isEnd;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          SingleChildScrollView(
            child: Column(
              spacing: 16,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      DateFormat('d. M. yyyy').format(voidingDiary.startDate!),
                      style: const TextStyle(
                        fontSize: 16,
                        color: AppColors.darkBlueBase,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                Row(
                  spacing: 8,
                  children: [
                    Expanded(
                      child: DateTimePicker(
                        controller: wakeupTimeDayOne,
                        labelText: "Čas probuzení",
                        hintText: "Zadejte čas",
                        helpText: "Zadejte čas probuzení",
                        isTimePicker: true,
                        isEnabled: isEnabled,
                        initialTime: wakeupTimeDayOne.text.isEmpty
                            ? TimeOfDay.now()
                            : TimeOfDay.fromDateTime(DateFormat("HH:mm")
                                .parse(wakeupTimeDayOne.text)),
                        validator: (value) {
                          if (isEnd && (value == null || value.isEmpty)) {
                            return "Vyplňte povinné pole";
                          }
                          return null;
                        },
                      ),
                    ),
                    Expanded(
                      child: DateTimePicker(
                        controller: sleepTimeDayOne,
                        labelText: "Čas usnutí",
                        hintText: "Zadejte čas",
                        helpText: "Zadejte čas usnutí",
                        isTimePicker: true,
                        isEnabled: isEnabled,
                        initialTime: sleepTimeDayOne.text.isEmpty
                            ? TimeOfDay.now()
                            : TimeOfDay.fromDateTime(
                                DateFormat("HH:mm").parse(sleepTimeDayOne.text),
                              ),
                        validator: (value) {
                          if (isEnd && (value == null || value.isEmpty)) {
                            return "Vyplňte povinné pole";
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                if (days == 2) ...[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        DateFormat('d. M. yyyy').format(
                          voidingDiary.startDate!.add(Duration(days: days - 1)),
                        ),
                        style: const TextStyle(
                          fontSize: 16,
                          color: AppColors.darkBlueBase,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    spacing: 8,
                    children: [
                      Expanded(
                        child: DateTimePicker(
                          controller: wakeupTimeDayTwo,
                          labelText: "Čas probuzení",
                          hintText: "Zadejte čas",
                          helpText: "Zadejte čas probuzení",
                          isTimePicker: true,
                          isEnabled: isEnabled,
                          initialTime: wakeupTimeDayTwo.text.isEmpty
                              ? TimeOfDay.now()
                              : TimeOfDay.fromDateTime(
                                  DateFormat("HH:mm")
                                      .parse(wakeupTimeDayTwo.text),
                                ),
                          validator: (value) {
                            if (isEnd && (value == null || value.isEmpty)) {
                              return "Vyplňte povinné pole";
                            }
                            return null;
                          },
                        ),
                      ),
                      Expanded(
                        child: DateTimePicker(
                          controller: sleepTimeDayTwo,
                          labelText: "Čas usnutí",
                          hintText: "Zadejte čas",
                          helpText: "Zadejte čas usnutí",
                          isTimePicker: true,
                          isEnabled: isEnabled,
                          initialTime: sleepTimeDayTwo.text.isEmpty
                              ? TimeOfDay.now()
                              : TimeOfDay.fromDateTime(
                                  DateFormat("HH:mm")
                                      .parse(sleepTimeDayTwo.text),
                                ),
                          validator: (value) {
                            if (isEnd && (value == null || value.isEmpty)) {
                              return "Vyplňte povinné pole";
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
