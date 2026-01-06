import 'dart:convert';

import 'package:uzis_app/core/models/pagination_model.dart';

class VoidingRecords {
  Pagination? pagination;
  List<VoidingRecord>? voidingRecords;

  VoidingRecords({
    this.pagination,
    this.voidingRecords,
  });

  factory VoidingRecords.fromJson(Map<String, dynamic> json) => VoidingRecords(
        pagination: json["pagination"] == null
            ? null
            : Pagination.fromJson(json["pagination"]),
        voidingRecords: json["voiding_records"] == null
            ? []
            : List<VoidingRecord>.from(
                json["voiding_records"]!.map((x) => VoidingRecord.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "pagination": pagination?.toJson(),
        "voiding_records": voidingRecords == null
            ? []
            : List<dynamic>.from(voidingRecords!.map((x) => x.toJson())),
      };
}

class VoidingRecord {
  // output
  final bool? sleptBeforeAndAfter;
  final bool? urineLeakage;
  final UrineLeakageType? urineLeakageType;
  final int? urgeStrength;
  final int? urineVolume;
  // input
  final BeverageType? beverageType;
  final int? fluidIntake;
  // common
  final int? id;
  final DateTime? recordedAt;
  final RecordType? recordType;

  VoidingRecord({
    this.id,
    this.recordedAt,
    this.sleptBeforeAndAfter,
    this.urineLeakage,
    this.urineLeakageType,
    this.urgeStrength,
    this.urineVolume,
    this.beverageType,
    this.fluidIntake,
    this.recordType,
  });

  factory VoidingRecord.fromRawJson(String str) =>
      VoidingRecord.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory VoidingRecord.fromJson(Map<String, dynamic> json) => VoidingRecord(
        id: json["id"],
        recordedAt: json["recorded_at"] != null
            ? DateTime.parse(json["recorded_at"])
            : null,
        sleptBeforeAndAfter: json["slept_before_and_after"],
        urineLeakage: json["urine_leakage"],
        urineLeakageType: json["urine_leakage_type"] != null
            ? UrineLeakageTypeExtension.fromApiString(
                json["urine_leakage_type"])
            : null,
        urgeStrength: json["urge_strength"],
        urineVolume: json["urine_volume"],
        beverageType: json["beverage_type"] != null
            ? BeverageTypeExtension.fromApiString(json["beverage_type"])
            : null,
        fluidIntake: json["fluid_intake"],
        recordType: json["record_type"] != null
            ? RecordTypeExtension.fromApiString(json["record_type"])
            : null,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "recorded_at": recordedAt?.toIso8601String(),
        "slept_before_and_after": sleptBeforeAndAfter,
        "urine_leakage": urineLeakage,
        "urine_leakage_type": urineLeakageType != null
            ? UrineLeakageTypeExtension(urineLeakageType!).toApiString()
            : null,
        "urge_strength": urgeStrength,
        "urine_volume": urineVolume,
        "beverage_type": beverageType != null
            ? BeverageTypeExtension(beverageType!).toApiString()
            : null,
        "fluid_intake": fluidIntake,
        "record_type": recordType != null
            ? RecordTypeExtension.toApiString(recordType!)
            : null,
      };
}

enum BeverageType {
  clearWater,
  fizzyWater,
  mineralWater,
  hotBeverage,
  sweetDrink,
  citrusDrink,
  alcohol,
  other
}

extension BeverageTypeExtension on BeverageType {
  String get formattedString {
    switch (this) {
      case BeverageType.clearWater:
        return "Voda čistá";
      case BeverageType.fizzyWater:
        return "Voda sycená";
      case BeverageType.mineralWater:
        return "Voda minerální";
      case BeverageType.hotBeverage:
        return "Káva a čaj";
      case BeverageType.sweetDrink:
        return 'Energetické nápoje a kola';
      case BeverageType.citrusDrink:
        return 'Citrusové nápoje';
      case BeverageType.alcohol:
        return "Alkohol";
      case BeverageType.other:
        return "Ostatní";
    }
  }

  static fromApiString(String beverage) {
    switch (beverage) {
      case "clear_water":
        return BeverageType.clearWater;
      case "fizzy_water":
        return BeverageType.fizzyWater;
      case "mineral_water":
        return BeverageType.mineralWater;
      case "hot_beverage":
        return BeverageType.hotBeverage;
      case "sweet_drink":
        return BeverageType.sweetDrink;
      case "citrus_drink":
        return BeverageType.citrusDrink;
      case "alcohol":
        return BeverageType.alcohol;
      case "other":
        return BeverageType.other;
    }
  }

  String toApiString() {
    switch (this) {
      case BeverageType.clearWater:
        return "clear_water";
      case BeverageType.fizzyWater:
        return "fizzy_water";
      case BeverageType.mineralWater:
        return "mineral_water";
      case BeverageType.hotBeverage:
        return "hot_beverage";
      case BeverageType.sweetDrink:
        return "sweet_drink";
      case BeverageType.citrusDrink:
        return "citrus_drink";
      case BeverageType.alcohol:
        return "alcohol";
      case BeverageType.other:
        return "other";
    }
  }
}

enum UrineLeakageType {
  stressful,
  urgent,
}

extension UrineLeakageTypeExtension on UrineLeakageType {
  static fromApiString(String urineLeakage) {
    switch (urineLeakage) {
      case "stressful":
        return UrineLeakageType.stressful;
      case "urgent":
        return UrineLeakageType.urgent;
    }
  }

  String toApiString() {
    switch (this) {
      case UrineLeakageType.stressful:
        return "stressful";
      case UrineLeakageType.urgent:
        return "urgent";
    }
  }

  static toApiStringFromInt(int urineLeakage) {
    switch (urineLeakage) {
      case 0:
        return "stressful";
      case 1:
        return "urgent";
    }
  }

  static toInt(UrineLeakageType? urineLeakage) {
    switch (urineLeakage) {
      case UrineLeakageType.stressful:
        return 0;
      case UrineLeakageType.urgent:
        return 1;
      default:
        return null;
    }
  }
}

enum RecordType { input, output }

extension RecordTypeExtension on RecordType {
  String get formattedString {
    switch (this) {
      case RecordType.input:
        return "Příjem";
      case RecordType.output:
        return "Močení";
    }
  }

  static fromApiString(String type) {
    switch (type) {
      case "input":
        return RecordType.input;
      case "output":
        return RecordType.output;
    }
  }

  static toApiString(RecordType type) {
    switch (type) {
      case RecordType.input:
        return "input";
      case RecordType.output:
        return "output";
    }
  }
}
