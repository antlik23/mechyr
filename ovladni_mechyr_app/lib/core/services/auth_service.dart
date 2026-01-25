import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:uzis_app/core/constants/app_config.dart';
import 'package:uzis_app/core/models/exception_model.dart';
import 'package:uzis_app/features/auth/models/login_model.dart';

class AuthService {
  final baseUrl = AppConfig.baseUrl;

  Future<LoginModel> login(String email, String password) async {
    try {
      final data = {"email": email, "password": password};
      final response = await http.post(
        Uri.parse("$baseUrl/login"),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode(data),
      );

      if (response.statusCode == 200) {
        LoginModel userData = LoginModel.fromJson(json.decode(response.body));

        return userData;
      } else {
        ExceptionModel exception =
            ExceptionModel.fromJson(json.decode(response.body));
        throw exception.error;
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<LoginModel?> refreshToken(String token) async {
    try {
      final http.Response response = await http.post(
        Uri.parse('$baseUrl/refresh'),
        headers: <String, String>{
          "Content-Type": "application/json",
          "Accept": "application/json",
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        LoginModel userData = LoginModel.fromJson(json.decode(response.body));
        return userData;
      } else if (response.statusCode == 401) {
        return null;
      } else {
        ExceptionModel exception =
            ExceptionModel.fromJson(json.decode(response.body));
        throw exception.error;
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> passwordForgot(String email) async {
    try {
      final http.Response response = await http.post(
        Uri.parse('$baseUrl/users/password_forgot'),
        headers: <String, String>{
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: json.encode({
          "user": {"email": email},
        }),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        ExceptionModel exception =
            ExceptionModel.fromJson(json.decode(response.body));
        throw exception.error;
      }
    } catch (e) {
      rethrow;
    }
  }
}
