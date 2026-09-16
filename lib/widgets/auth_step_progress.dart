import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_typography.dart';

class AuthStepProgress extends StatelessWidget {
  final int currentStep; // 1 to 5
  final int totalSteps;
  final String title;
  final String subtitle;
  final Widget? trailing;

  const AuthStepProgress({
    super.key,
    required this.currentStep,
    this.totalSteps = 5,
    required this.title,
    required this.subtitle,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Step counter text: "1 of 5"
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '$currentStep of $totalSteps',
              style: AppTypography.caption.copyWith(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),
            ?trailing,
          ],
        ),
        const SizedBox(height: 8),

        // 5-Segmented horizontal progress bars
        Row(
          children: List.generate(totalSteps, (index) {
            final isCompletedOrCurrent = index < currentStep;
            return Expanded(
              child: Container(
                height: 3.5,
                margin: EdgeInsets.only(
                  right: index == totalSteps - 1 ? 0 : 7,
                ),
                decoration: BoxDecoration(
                  color: isCompletedOrCurrent
                      ? AppColors.primary
                      : const Color(0xFFE2E8F0),
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            );
          }),
        ),
        const SizedBox(height: 24),

        // Title
        Text(
          title,
          style: AppTypography.headline.copyWith(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: AppColors.textDark,
            letterSpacing: -0.3,
            height: 1.2,
          ),
        ),
        const SizedBox(height: 6),

        // Subtitle
        Text(
          subtitle,
          style: AppTypography.bodySubtitle.copyWith(
            fontSize: 13,
            color: AppColors.textSecondary,
            height: 1.35,
          ),
        ),
      ],
    );
  }
}
