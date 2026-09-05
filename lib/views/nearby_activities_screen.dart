import 'package:flutter/material.dart';
import '../constants/app_assets.dart';
import '../constants/app_colors.dart';
import '../constants/app_typography.dart';
import '../controllers/activities_controller.dart';
import '../widgets/activity_card.dart';
import '../widgets/date_selector_strip.dart';
import '../widgets/filter_chips_bar.dart';
import '../widgets/filters_bottom_sheet.dart';

class NearbyActivitiesScreen extends StatefulWidget {
  const NearbyActivitiesScreen({super.key});

  @override
  State<NearbyActivitiesScreen> createState() => _NearbyActivitiesScreenState();
}

class _NearbyActivitiesScreenState extends State<NearbyActivitiesScreen> {
  late final ActivitiesController _controller;

  @override
  void initState() {
    super.initState();
    _controller = ActivitiesController();
    _controller.addListener(_onControllerUpdate);
  }

  void _onControllerUpdate() {
    setState(() {});
  }

  @override
  void dispose() {
    _controller.removeListener(_onControllerUpdate);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Top Header Bar
              _buildHeader(),
              const SizedBox(height: 20),

              // 2. Date Selector Bar
              DateSelectorStrip(
                dates: _controller.dates,
                selectedIndex: _controller.selectedDateIndex,
                onDateSelected: _controller.selectDate,
              ),
              const SizedBox(height: 18),

              // 3. Filter Chips Row
              FilterChipsBar(
                filters: _controller.filters,
                onFilterSelected: _controller.toggleFilter,
                onTunePressed: () {
                  FiltersBottomSheet.show(context);
                },
              ),
              const SizedBox(height: 26),

              // 4. Section Header: Nearby activities + See all
              _buildSectionHeader(),
              const SizedBox(height: 14),

              // 5. Activity Cards List
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _controller.activities.length,
                separatorBuilder: (context, index) => const SizedBox(height: 14),
                itemBuilder: (context, index) {
                  final activity = _controller.activities[index];
                  return ActivityCard(
                    activity: activity,
                  );
                },
              ),
              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hey ${_controller.userName}!',
              style: AppTypography.headline.copyWith(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              _controller.selectedLocation,
              style: AppTypography.bodySubtitle.copyWith(
                color: AppColors.textSecondary,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        Row(
          children: [
            // Notification Bell Button
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.borderLight, width: 1.0),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x06000000),
                    blurRadius: 6,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Image.asset(
                    AppAssets.notificationPng,
                    width: 22,
                    height: 22,
                    fit: BoxFit.contain,
                  ),
                  Positioned(
                    top: 10,
                    right: 12,
                    child: Container(
                      width: 7,
                      height: 7,
                      decoration: const BoxDecoration(
                        color: Color(0xFFFF5722),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            // Avatar circle with 'V'
            Container(
              width: 44,
              height: 44,
              decoration: const BoxDecoration(
                color: AppColors.avatarGreen,
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Text(
                _controller.userName.isNotEmpty ? _controller.userName[0] : 'V',
                style: AppTypography.titleMedium.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 19,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSectionHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Nearby activities',
          style: AppTypography.headline.copyWith(
            fontWeight: FontWeight.w800,
            fontSize: 19,
            color: AppColors.textDark,
            letterSpacing: -0.3,
          ),
        ),
        InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: () {},
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
            child: Row(
              children: [
                Text(
                  'See all',
                  style: AppTypography.caption.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                    fontSize: 13.5,
                  ),
                ),
                const SizedBox(width: 4),
                const Icon(
                  Icons.arrow_forward_rounded,
                  size: 16,
                  color: AppColors.primary,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
