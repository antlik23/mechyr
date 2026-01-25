import 'dart:convert';

import 'package:uzis_app/features/auth/models/user_model.dart';

class LoginModel {
  LoginModel({
    required this.accessToken,
    required this.refreshToken,
    required this.expiresIn,
    required this.user,
    expiresInDateTime,
  }) : expiresInDateTime = expiresInDateTime ??
            DateTime.now().add(Duration(seconds: expiresIn));

  String? accessToken;
  String refreshToken;
  int expiresIn;
  UserModel user;
  DateTime? expiresInDateTime;

  copyWith({
    String? accessToken,
    String? refreshToken,
    int? expiresIn,
    UserModel? user,
    DateTime? expiresInDateTime,
  }) {
    return LoginModel(
      accessToken: accessToken ?? this.accessToken,
      refreshToken: refreshToken ?? this.refreshToken,
      expiresIn: expiresIn ?? this.expiresIn,
      expiresInDateTime: expiresInDateTime ?? this.expiresInDateTime,
      user: user ?? this.user,
    );
  }

  factory LoginModel.fromJson(Map<String, dynamic> json) => LoginModel(
        accessToken: json["access_token"],
        refreshToken: json["refresh_token"],
        expiresIn: json["expires_in"],
        user: UserModel.fromJson(json["user"]),
      );

  factory LoginModel.fromRawJson(String str) =>
      LoginModel.fromJson(json.decode(str));

  Map<String, dynamic> toJson() => {
        "access_token": accessToken,
        "refresh_token": refreshToken,
        "expires_in": expiresIn,
        "user": user.toJson(),
      };

  factory LoginModel.fromUserDataJson(Map<String, dynamic> json) => LoginModel(
        accessToken: json["access_token"],
        refreshToken: json["refresh_token"],
        expiresIn: json["expires_in"],
        expiresInDateTime: json["expiresInDateTime"] != null
            ? DateTime.parse(json["expiresInDateTime"])
            : null,
        user: UserModel.fromJson(json["user"]),
      );

  factory LoginModel.fromUserDataRawJson(String str) =>
      LoginModel.fromUserDataJson(json.decode(str));

  Map<String, dynamic> toUserDataJson() => {
        "access_token": accessToken,
        "refresh_token": refreshToken,
        "expires_in": expiresIn,
        "expiresInDateTime": expiresInDateTime?.toIso8601String(),
        "user": user.toJson(),
      };
}
