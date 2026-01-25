import 'dart:convert';

import 'package:uzis_app/core/constants/app_config.dart';
import 'package:uzis_app/core/models/exception_model.dart';
import 'package:uzis_app/features/auth/models/user_model.dart';
import 'package:uzis_app/features/auth/usecases/get_valid_token.dart';
import 'package:http/http.dart' as http;

class UserService {
  final baseUrl = AppConfig.baseUrl;

  Future<UserModel> fetchUser(int userId) async {
    try {
      final token = await GetValidUserToken().execute();
      final response = await http.get(
        Uri.parse("$baseUrl/users/$userId"),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        UserModel user = UserModel.fromJson(json.decode(response.body)["user"]);

        return user;
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
