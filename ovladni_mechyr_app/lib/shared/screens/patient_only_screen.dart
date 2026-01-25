import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:uzis_app/core/constants/app_colors.dart';

class PatientOnlyScreen extends StatelessWidget {
  const PatientOnlyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: Center(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 16,
                children: [
                  SvgPicture.asset(
                    "assets/icons/Lock.svg",
                    width: 48,
                    colorFilter: const ColorFilter.mode(
                      AppColors.gray400,
                      BlendMode.srcIn,
                    ),
                  ),
                  const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: 4,
                    children: [
                      Text(
                        "Tato aplikace je určena pouze pro pacienty.",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: AppColors.gray400,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        "Pro ostatní uživatele doporučujeme využít naše webové rozhraní.",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppColors.gray400,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
