import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uzis_app/core/services/notification_service.dart';
import 'package:uzis_app/core/services/user_service.dart';
import 'package:uzis_app/core/services/voiding_service.dart';
import 'package:uzis_app/features/auth/models/user_model.dart';
import 'package:uzis_app/features/auth/repositories/user_repository.dart';
import 'package:uzis_app/features/auth/usecases/get_valid_token.dart';
import 'package:uzis_app/features/voiding_diary/models/voiding_diary_model.dart';
import 'package:uzis_app/features/doctor/models/doctor_model.dart';
import 'package:uzis_app/features/doctor/services/doctor_service.dart';

class AuthNotifier extends ChangeNotifier {
  bool _isLogged = false;
  String? _initialLocation;
  List<UserRole> _userRoles = [];
  String? _uncompletedDiaryId;
  bool _isConnected = true;
  ContactStatus? _assignmentStatus;
  int? _assignedDoctorId;
  String? _assignedDoctorName;
  late StreamSubscription<List<ConnectivityResult>> subscription;

  bool get isLogged => _isLogged;
  String? get initialLocation => _initialLocation;
  List<UserRole> get userRoles => _userRoles;
  bool get isConnected => _isConnected;
  String? get uncompletedDiaryId => _uncompletedDiaryId;
  ContactStatus? get assignmentStatus => _assignmentStatus;
  int? get assignedDoctorId => _assignedDoctorId;
  String? get assignedDoctorName => _assignedDoctorName;
  bool get hasAssignedDoctor => _assignedDoctorId != null;

  AuthNotifier() {
    subscription = Connectivity().onConnectivityChanged.listen((
      List<ConnectivityResult> result,
    ) {
      final bool wifi = result.contains(ConnectivityResult.wifi);
      final bool mobile = result.contains(ConnectivityResult.mobile);
      final bool ethernet = result.contains(ConnectivityResult.ethernet);
      _isConnected = wifi || mobile || ethernet;

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

      // Load assigned doctor info
      _assignedDoctorId = userData.user.doctorId;
      _assignedDoctorName = userData.user.doctorName;

      if (userData.user.roles.contains(UserRole.patient)) {
        if (!isConnected) return;

        try {
          VoidingDiary? latestVoidingDiary =
              await VoidingService().fetchLatestVoidingDiary();
          if (latestVoidingDiary == null ||
              latestVoidingDiary.completed == true) {
            _initialLocation = "/";
            _uncompletedDiaryId = null;
            await NotificationService().cancelNotification(
              NotificationService.endDiaryId,
            );
          } else {
            _initialLocation =
                "/voiding-diary/${latestVoidingDiary.id.toString()}";
            _uncompletedDiaryId = latestVoidingDiary.id.toString();
          }
        } catch (e) {
          _initialLocation = "/";
          _uncompletedDiaryId = null;
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

  Future<void> refreshAssignmentStatus() async {
    // Assignment status is not currently used in the app
    // If needed in the future, implement proper endpoint on backend
    _assignmentStatus = null;
    notifyListeners();
  }

  Future<void> setAssignmentStatus(ContactStatus? value) async {
    _assignmentStatus = value;
    notifyListeners();
  }

  Future<void> refreshDoctorAssignment() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      const secureStorage = FlutterSecureStorage();
      final userData = await UserRepository(prefs, secureStorage).getUserData();

      if (userData != null) {
        _assignedDoctorId = userData.user.doctorId;
        _assignedDoctorName = userData.user.doctorName;
        notifyListeners();
      }
    } catch (e) {
      // Silently fail - keep existing values
    }
  }

  /// Refreshes user data from API and updates local storage
  /// This ensures we have the latest doctor assignment info and voiding diary status
  Future<void> refreshUserFromApi() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      const secureStorage = FlutterSecureStorage();
      final userData = await UserRepository(prefs, secureStorage).getUserData();

      if (userData == null) return;

      // Fetch fresh user data from API
      final userService = UserService();
      final freshUser = await userService.fetchUser(userData.user.id);

      // Update assigned doctor info
      _assignedDoctorId = freshUser.doctorId;
      _assignedDoctorName = freshUser.doctorName;

      // Update voiding diary status if user is a patient
      if (freshUser.roles.contains(UserRole.patient)) {
        try {
          VoidingDiary? latestVoidingDiary =
              await VoidingService().fetchLatestVoidingDiary();
          if (latestVoidingDiary == null ||
              latestVoidingDiary.completed == true) {
            _initialLocation = "/";
            _uncompletedDiaryId = null;
            await NotificationService().cancelNotification(
              NotificationService.endDiaryId,
            );
          } else {
            _initialLocation =
                "/voiding-diary/${latestVoidingDiary.id.toString()}";
            _uncompletedDiaryId = latestVoidingDiary.id.toString();
          }
        } catch (e) {
          // Keep existing diary state if fetch fails
        }
      }

      // Save updated user data to local storage
      final updatedUserData = userData.copyWith(user: freshUser);
      await UserRepository(prefs, secureStorage).saveUserData(updatedUserData);

      notifyListeners();
    } catch (e) {
      // Silently fail - keep existing values
    }
  }
}
