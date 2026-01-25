import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uzis_app/features/auth/models/credentials_model.dart';
import 'package:uzis_app/features/auth/models/login_model.dart';

class UserRepository {
  UserRepository(
    this.prefs,
    this.secureStorage,
  );

  final FlutterSecureStorage secureStorage;
  final SharedPreferences prefs;

  Future<LoginModel?> getUserData() async {
    final userData = prefs.getString('user');
    if (userData == null) return null;

    return LoginModel.fromUserDataRawJson(userData);
  }

  Future<void> saveUserData(LoginModel userData) async {
    final expiresInDateTime = userData.expiresInDateTime ??
        DateTime.now().add(Duration(seconds: userData.expiresIn));

    final updatedUserData =
        userData.copyWith(expiresInDateTime: expiresInDateTime);
    await prefs.setString(
        'user', json.encode(updatedUserData.toUserDataJson()));
  }

  Future<void> clearUserData() async {
    await prefs.remove('user');
  }

  static const String _keyEmail = 'email';
  static const String _keyPassword = 'password';

  Future<void> saveCredentials(String email, String password) async {
    await secureStorage.write(key: _keyEmail, value: email);
    await secureStorage.write(key: _keyPassword, value: password);
  }

  Future<CredentialsModel?> getCredentials() async {
    final email = await secureStorage.read(key: _keyEmail);
    final password = await secureStorage.read(key: _keyPassword);
    if (email != null && password != null) {
      return CredentialsModel(email: email, password: password);
    }
    return null;
  }

  Future<void> deleteCredentials() async {
    await secureStorage.delete(key: _keyEmail);
    await secureStorage.delete(key: _keyPassword);
  }
}
