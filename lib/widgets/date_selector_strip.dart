import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_typography.dart';
import '../models/activity_model.dart';

class DateSelectorStrip extends StatelessWidget {
  final List<DateItemModel> dates;
  final int selectedIndex;
  final ValueChanged<int> onDateSelected;
  final String monthText;

  const DateSelectorStrip({
    super.key,
    required this.dates,
    required this.selectedIndex,
    required this.onDateSelected,
    this.monthText = 'AUG',
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 72,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Month Badge (AUG rotated 90 degrees counter-clockwise matching Figma)
          Container(
            width: 40,
            height: 66,
            decoration: BoxDecoration(
              color: const Color(0xFFE8EEF8),
              borderRadius: BorderRadius.circular(16),
            ),
            alignment: Alignment.center,
            child: RotatedBox(
              quarterTurns: 3,
              child: Text(
                monthText,
                style: AppTypography.caption.copyWith(
                  fontWeight: FontWeight.w800,
                  fontSize: 12,
                  color: AppColors.primary,
                  letterSpacing: 1.2,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),

          // Date Pills List
          Expanded(
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemCount: dates.length,
              separatorBuilder: (context, index) => const SizedBox(width: 4),
              itemBuilder: (context, index) {
                final dateItem = dates[index];
                final isSelected = index == selectedIndex;

                return GestureDetector(
                  onTap: () => onDateSelected(index),
                  behavior: HitTestBehavior.opaque,
                  child: SizedBox(
                    width: 44,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          dateItem.dayName,
                          style: AppTypography.caption.copyWith(
                            fontSize: 10,
                            fontWeight:
                                isSelected ? FontWeight.w700 : FontWeight.w500,
                            color: isSelected
                                ? AppColors.primary
                                : AppColors.textTertiary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          width: 34,
                          height: 34,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isSelected
                                ? AppColors.primary
                                : Colors.transparent,
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            dateItem.dayNumber,
                            style: AppTypography.titleMedium.copyWith(
                              fontSize: 14.5,
                              fontWeight: isSelected
                                  ? FontWeight.w700
                                  : FontWeight.w600,
                              color:
                                  isSelected ? Colors.white : AppColors.textDark,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
