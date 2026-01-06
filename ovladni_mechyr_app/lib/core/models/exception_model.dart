import 'dart:convert';

class ExceptionModel {
  ExceptionModel({
    required this.error,
  });

  final String error;

  factory ExceptionModel.fromJson(Map<String, dynamic> json) => ExceptionModel(
        error: json['error'],
      );

  factory ExceptionModel.fromRawJson(String str) =>
      ExceptionModel.fromJson(json.decode(str));

  Map<String, dynamic> toJson() => {
        "error": error,
      };
}
