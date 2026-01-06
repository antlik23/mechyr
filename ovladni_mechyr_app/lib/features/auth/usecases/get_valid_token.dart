import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uzis_app/core/routes/auth_routes.dart';
import 'package:uzis_app/core/services/auth_service.dart';
import 'package:uzis_app/core/utils/custom_snackbar.dart';
import 'package:uzis_app/features/auth/repositories/user_repository.dart';
import 'package:uzis_app/main.dart';

class GetValidUserToken {
  Future<String?> execute() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    const secureStorage = FlutterSecureStorage();

    final user = await UserRepository(prefs, secureStorage).getUserData();
    if (user == null ||
        user.accessToken == null ||
        user.expiresInDateTime == null) {
      return null;
    }

    if (DateTime.now().isBefore(user.expiresInDateTime!)) {
      return user.accessToken;
    }

    // Token expired -> try to refresh
    final res = await AuthService().refreshToken(user.refreshToken);
    if (res != null) {
      final updatedUser = user.copyWith(
        accessToken: res.accessToken,
        refreshToken: res.refreshToken,
        expiresIn: res.expiresIn,
        expiresInDateTime: DateTime.now().add(Duration(seconds: res.expiresIn)),
      );

      await UserRepository(prefs, secureStorage).saveUserData(updatedUser);
      return res.accessToken;
    } else {
      await UserRepository(prefs, secureStorage).clearUserData();

      final context = navigatorKey.currentContext;
      if (context != null && context.mounted) {
        context.go(AuthRoutes.Login);
        CustomSnackbar.showInfo(
            "Vaše přihlášení vypršelo, přihlaste se prosím znovu.");
      }
      return null;
    }
  }
}
