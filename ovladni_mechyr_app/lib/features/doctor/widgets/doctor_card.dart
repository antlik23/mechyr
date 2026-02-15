import 'package:flutter/material.dart';
import 'package:uzis_app/core/constants/app_colors.dart';
import 'package:uzis_app/core/constants/app_styles.dart';
import 'package:uzis_app/features/doctor/models/doctor_model.dart';

class DoctorCard extends StatelessWidget {
  const DoctorCard({
    super.key,
    required this.doctor,
    required this.onTap,
    this.isAssigned = false,
  });

  final DoctorModel doctor;
  final VoidCallback onTap;
  final bool isAssigned;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: AppStyles.borderRadius.xl,
        border: isAssigned
            ? Border.all(
                color: AppColors.green,
                width: 2,
              )
            : null,
        boxShadow: [
          BoxShadow(
            color: AppColors.gray400.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: AppStyles.borderRadius.xl,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            doctor.fullName ?? 'Neznámý lékař',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: AppColors.gray900,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (isAssigned)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFD1FAE5),
                              borderRadius: AppStyles.borderRadius.xl,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: const [
                                Icon(
                                  Icons.check_circle,
                                  size: 14,
                                  color: AppColors.green,
                                ),
                                SizedBox(width: 4),
                                Text(
                                  'Váš lékař',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: AppColors.green,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        if (!doctor.isContactable && !isAssigned)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.redLighter,
                              borderRadius: AppStyles.borderRadius.xl,
                            ),
                            child: const Text(
                              'Není k dispozici',
                              style: TextStyle(
                                fontSize: 12,
                                color: AppColors.red,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.blueLighter,
                        borderRadius: AppStyles.borderRadius.lg,
                      ),
                      child: Text(
                        doctor.specializationLabel,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.darkBlueBase,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    if (doctor.workplace != null &&
                        doctor.workplace!.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(
                            Icons.business,
                            size: 16,
                            color: AppColors.gray500,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              doctor.workplace!,
                              style: const TextStyle(
                                fontSize: 13,
                                color: AppColors.gray700,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                    if (doctor.city != null && doctor.city!.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(
                            Icons.location_on,
                            size: 16,
                            color: AppColors.gray500,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              doctor.city!,
                              style: const TextStyle(
                                fontSize: 13,
                                color: AppColors.gray700,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right,
                color: AppColors.gray500,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
