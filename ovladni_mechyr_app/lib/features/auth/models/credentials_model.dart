import 'dart:convert';

class CredentialsModel {
  String email;
  String password;

  CredentialsModel({
    required this.email,
    required this.password,
  });

  factory CredentialsModel.fromJson(Map<String, dynamic> json) =>
      CredentialsModel(
        email: json["email"],
        password: json["password"],
      );

  factory CredentialsModel.fromRawJson(String str) =>
      CredentialsModel.fromJson(json.decode(str));

  Map<String, dynamic> toJson() => {
        "email": email,
        "password": password,
      };
}
