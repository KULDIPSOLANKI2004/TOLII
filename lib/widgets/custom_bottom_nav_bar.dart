import 'package:flutter/material.dart';
import '../constants/app_assets.dart';
import '../constants/app_colors.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final VoidCallback? onPlusPressed;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    this.onPlusPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: true,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
        child: Container(
          height: 64,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: const Color(0xFFEDF2F7),
              width: 1.2,
            ),
            boxShadow: const [
              BoxShadow(
                color: Color(0x18000000),
                blurRadius: 20,
                spreadRadius: 0,
                offset: Offset(0, 8),
              ),
              BoxShadow(
                color: Color(0x08063E9E),
                blurRadius: 10,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // 1. Home
              _buildNavIcon(
                index: 0,
                asset: AppAssets.homeNavPng,
              ),

              // 2. Activities
              _buildNavIcon(
                index: 1,
                asset: AppAssets.activitiesNavPng,
              ),

              // 3. Center "+" Action Button
              GestureDetector(
                onTap: () {
                  if (onPlusPressed != null) {
                    onPlusPressed!();
                  } else {
                    onTap(2);
                  }
                },
                behavior: HitTestBehavior.opaque,
                child: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x35063E9E),
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  alignment: Alignment.center,
                  child: const Icon(
                    Icons.add_rounded,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
              ),

              // 4. Community
              _buildNavIcon(
                index: 3,
                asset: AppAssets.communityNavPng,
              ),

              // 5. Profile
              _buildNavIcon(
                index: 4,
                asset: AppAssets.profileNavPng,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavIcon({
    required int index,
    required String asset,
  }) {
    final isSelected = currentIndex == index;
    final color = isSelected ? AppColors.primary : const Color(0xFF94A3B8);

    return Expanded(
      child: InkWell(
        onTap: () => onTap(index),
        borderRadius: BorderRadius.circular(12),
        child: SizedBox(
          height: 48,
          child: Center(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFFEEF4FF) : Colors.transparent,
                borderRadius: BorderRadius.circular(10),
              ),
              alignment: Alignment.center,
              child: Image.asset(
                asset,
                width: 22,
                height: 22,
                fit: BoxFit.contain,
                color: color,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
