import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uzis_app/core/services/notification_service.dart';
import 'package:uzis_app/core/services/voiding_service.dart';
import 'package:uzis_app/features/auth/models/user_model.dart';
import 'package:uzis_app/features/auth/repositories/user_repository.dart';
import 'package:uzis_app/features/auth/usecases/get_valid_token.dart';
import 'package:uzis_app/features/voiding_diary/models/voiding_diary_model.dart';

class AuthNotifier extends ChangeNotifier {
  bool _isLogged = false;
  String? _initialLocation;
  List<UserRole> _userRoles = [];
  String? _uncompletedDiaryId;
  bool _isConnected = true;
  late StreamSubscription<List<ConnectivityResult>> subscription;

  bool get isLogged => _isLogged;
  String? get initialLocation => _initialLocation;
  List<UserRole> get userRoles => _userRoles;
  bool get isConnected => _isConnected;
  String? get uncompletedDiaryId => _uncompletedDiaryId;

  AuthNotifier() {
    subscription = Connectivity()
        .onConnectivityChanged
        .listen((List<ConnectivityResult> result) {
      final bool wifi = result.contains(ConnectivityResult.wifi);
      final bool mobile = result.contains(ConnectivityResult.mobile);
      _isConnected = wifi || mobile;

      notifyListeners();
    });
  }

  Future<void> loadUser() async {
    String? token = await GetValidUserToken().execute();

    if (token == null) {
      _isLogged = false;
      _initialLocation = "/login";
      _uncompletedDiaryId = null;
    } else {
      _isLogged = true;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      const secureStorage = FlutterSecureStorage();
      final userData = await UserRepository(prefs, secureStorage).getUserData();
      _userRoles = userData!.user.roles;

      if (userData.user.roles.contains(UserRole.patient)) {
        if (!isConnected) return;

        VoidingDiary? latestVoidingDiary =
            await VoidingService().fetchLatestVoidingDiary();
        if (latestVoidingDiary == null ||
            latestVoidingDiary.completed == true) {
          _initialLocation = "/";
          _uncompletedDiaryId = null;
          await NotificationService()
              .cancelNotification(NotificationService.endDiaryId);
        } else {
          _initialLocation =
              "/voiding-diary/${latestVoidingDiary.id.toString()}";
          _uncompletedDiaryId = latestVoidingDiary.id.toString();
        }
      } else {
        _initialLocation = "/patient-only";
      }
    }

    notifyListeners();
  }

  Future<void> setIsLogged(bool value) async {
    _isLogged = value;
    notifyListeners();
  }

  Future<void> setUserRoles(List<UserRole> userRoles) async {
    _userRoles = userRoles;
    notifyListeners();
  }

  Future<void> setUncompletedDiaryId(String? value) async {
    _uncompletedDiaryId = value;
    notifyListeners();
  }
}
