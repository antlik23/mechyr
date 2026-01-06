import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:uzis_app/core/constants/app_colors.dart';
import 'package:uzis_app/core/constants/app_styles.dart';

class CustomSnackbar {
  static GlobalKey<ScaffoldMessengerState> key =
      GlobalKey<ScaffoldMessengerState>();

  static void showError(String message) {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        key.currentState!
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(
              duration: const Duration(seconds: 5),
              backgroundColor: Colors.transparent,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
              content: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.redLighter,
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x19000000),
                      spreadRadius: 2.0,
                      blurRadius: 8.0,
                      offset: Offset(2, 4),
                    )
                  ],
                  borderRadius: AppStyles.borderRadius.lg,
                ),
                child: Row(
                  spacing: 8,
                  children: [
                    SvgPicture.asset(
                      "assets/icons/CircleAlert.svg",
                      colorFilter: const ColorFilter.mode(
                        AppColors.red,
                        BlendMode.srcIn,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        message,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.red,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
      },
    );
  }

  static void showSuccess(String message) {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        key.currentState!
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(
              duration: const Duration(seconds: 5),
              backgroundColor: Colors.transparent,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
              content: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.greenLighter,
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x19000000),
                      spreadRadius: 2.0,
                      blurRadius: 8.0,
                      offset: Offset(2, 4),
                    )
                  ],
                  borderRadius: AppStyles.borderRadius.lg,
                ),
                child: Row(
                  spacing: 8,
                  children: [
                    SvgPicture.asset(
                      "assets/icons/CircleCheck.svg",
                      colorFilter: const ColorFilter.mode(
                        AppColors.green,
                        BlendMode.srcIn,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        message,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.green,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
      },
    );
  }

  static void showInfo(String message) {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        key.currentState!
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(
              duration: const Duration(seconds: 5),
              backgroundColor: Colors.transparent,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
              content: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.blueLighter,
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x19000000),
                      spreadRadius: 2.0,
                      blurRadius: 8.0,
                      offset: Offset(2, 4),
                    )
                  ],
                  borderRadius: AppStyles.borderRadius.lg,
                ),
                child: Row(
                  spacing: 8,
                  children: [
                    SvgPicture.asset(
                      "assets/icons/Info.svg",
                      colorFilter: const ColorFilter.mode(
                        AppColors.blue,
                        BlendMode.srcIn,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        message,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.blue,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
      },
    );
  }
}
