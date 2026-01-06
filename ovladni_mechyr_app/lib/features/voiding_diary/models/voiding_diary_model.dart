import 'dart:convert';

import 'package:intl/intl.dart';

class VoidingDiary {
  VoidingDiary({
    required this.id,
    required this.startDate,
    required this.duration,
    required this.bedTimeDayOne,
    required this.wakeupTimeDayOne,
    required this.bedTimeDayTwo,
    required this.wakeupTimeDayTwo,
    required this.completed,
  });

  final int id;
  final DateTime? startDate;
  final DurationType? duration;
  final DateTime? bedTimeDayOne;
  final DateTime? wakeupTimeDayOne;
  final DateTime? bedTimeDayTwo;
  final DateTime? wakeupTimeDayTwo;
  final bool? completed;

  factory VoidingDiary.fromJson(Map<String, dynamic> json) => VoidingDiary(
        id: json['id'],
        startDate: json["diary_start_date"] != null
            ? DateTime.parse(json["diary_start_date"])
            : null,
        duration: json["diary_duration_days"] != null
            ? DurationTypeExtension.fromApiInt(json["diary_duration_days"])
            : null,
        // startDate: DateTime.parse("2025-02-17T00:00:00.000"),
        // duration: DurationTypeExtension.fromApiInt(2),
        bedTimeDayOne: json["bedtime_day_one"] != null
            ? DateFormat("HH:mm").parse(json["bedtime_day_one"])
            : null,
        wakeupTimeDayOne: json["wake_up_time_day_one"] != null
            ? DateFormat("HH:mm").parse(json["wake_up_time_day_one"])
            : null,
        bedTimeDayTwo: json["bedtime_day_two"] != null
            ? DateFormat("HH:mm").parse(json["bedtime_day_two"])
            : null,
        wakeupTimeDayTwo: json["wake_up_time_day_two"] != null
            ? DateFormat("HH:mm").parse(json["wake_up_time_day_two"])
            : null,
        completed: json["completed"],
      );

  factory VoidingDiary.fromRawJson(String str) =>
      VoidingDiary.fromJson(json.decode(str));

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "diary_start_date": startDate?.toIso8601String(),
      // "diary_duration_days":
      //     duration != null ? DurationTypeExtension(duration!).toApiInt() : null,
      "diary_duration_days": DurationTypeExtension(duration!).toApiInt(),
      "bedtime_day_one":
          bedTimeDayOne != null ? DateFormat.Hm().format(bedTimeDayOne!) : null,
      "wake_up_time_day_one": wakeupTimeDayOne != null
          ? DateFormat.Hm().format(wakeupTimeDayOne!)
          : null,
      "bedtime_day_two":
          bedTimeDayTwo != null ? DateFormat.Hm().format(bedTimeDayTwo!) : null,
      "wake_up_time_day_two": wakeupTimeDayTwo != null
          ? DateFormat.Hm().format(wakeupTimeDayTwo!)
          : null,
      "completed": completed,
    };
  }
}

enum DurationType { d24, d48 }

extension DurationTypeExtension on DurationType {
  String get formattedString {
    switch (this) {
      case DurationType.d24:
        return "24 hodin";
      case DurationType.d48:
        return "48 hodin";
    }
  }

  static fromApiInt(int duration) {
    switch (duration) {
      case 1:
        return DurationType.d24;
      case 2:
        return DurationType.d48;
    }
  }

  int toApiInt() {
    switch (this) {
      case DurationType.d24:
        return 1;
      case DurationType.d48:
        return 2;
    }
  }
}
