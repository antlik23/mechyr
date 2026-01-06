import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:uzis_app/core/constants/app_colors.dart';
import 'package:uzis_app/core/constants/app_styles.dart';
import 'package:uzis_app/shared/widgets/button.dart';

class StartDateDiaryDialog extends StatelessWidget {
  const StartDateDiaryDialog({
    super.key,
    required this.startDate,
    required this.endDate,
  });

  final String startDate;
  final String endDate;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      insetPadding: const EdgeInsets.symmetric(horizontal: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: 16,
          children: [
            const Text(
              "Váš mikční deník ještě nezačal",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.darkBlueBase,
              ),
              textAlign: TextAlign.center,
            ),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: AppStyles.borderRadius.xl,
                border: Border.all(
                  width: 1,
                  color: const Color(0xFFE4E4E7),
                ),
              ),
              child: Column(
                spacing: 4,
                children: [
                  Row(
                    spacing: 24,
                    children: [
                      const Expanded(
                        child: Text(
                          "Deník začněte vyplňovat dne",
                          style: TextStyle(
                            fontSize: 18,
                            color: AppColors.gray900,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Text(
                        startDate,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: AppColors.darkBlueBase,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    "záznamem o druhém ranním močení (první ranní močení se v tento den nepočítá). Deník ukončete dne $endDate ráno záznamem o prvním ranním močení.",
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF71717A),
                    ),
                  ),
                ],
              ),
            ),
            Button(
              text: "Rozumím",
              onPressed: context.pop,
            )
          ],
        ),
      ),
    );
  }
}
