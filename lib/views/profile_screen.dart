import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/app_colors.dart';
import '../constants/app_typography.dart';
import '../controllers/activities_controller.dart';
import '../models/activity_model.dart';
import 'activity_detail_screen.dart';
import 'edit_profile_screen.dart';
import 'welcome_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _selectedSport = 'Cricket';
  final List<String> _sports = ['Cricket', 'Badminton', 'Football', 'Pickleball'];

  String _userName = 'Arjun Mehta';
  final String _userHandle = '@arjunm';
  final String _userLocation = 'Mumbai, India';

  void _openEditProfile() async {
    HapticFeedback.lightImpact();
    final nameParts = _userName.split(' ');
    final firstName = nameParts.isNotEmpty ? nameParts[0] : 'Arjun';
    final lastName = nameParts.length > 1 ? nameParts.sublist(1).join(' ') : 'Mehta';

    final result = await Navigator.of(context).push<Map<String, dynamic>>(
      MaterialPageRoute(
        builder: (_) => EditProfileScreen(
          initialFirstName: firstName,
          initialLastName: lastName,
        ),
      ),
    );

    if (result != null && mounted) {
      setState(() {
        _userName = '${result['firstName']} ${result['lastName']}'.trim();
      });
    }
  }

  void _openActivityDetail(ActivityModel activity) {
    HapticFeedback.lightImpact();
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ActivityDetailScreen(activity: activity),
      ),
    );
  }

  void _openGoogleFitSheet() {
    HapticFeedback.lightImpact();
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: EdgeInsets.fromLTRB(24, 14, 24, MediaQuery.of(ctx).padding.bottom + 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 38,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: const Color(0xFFCBD5E1),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF7ED),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    alignment: Alignment.center,
                    child: const Icon(
                      Icons.local_fire_department_rounded,
                      color: Color(0xFFEA580C),
                      size: 26,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Google Fit Integration',
                          style: AppTypography.headline.copyWith(
                            fontSize: 17,
                            fontWeight: FontWeight.w800,
                            color: const Color(0xFF0F172A),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Sync workout and health metrics',
                          style: AppTypography.caption.copyWith(
                            fontSize: 12.5,
                            color: const Color(0xFF64748B),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              Text(
                'Connecting your Google Fit tracks your active minutes, calorie burn, and match intensity across all your activities automatically.',
                style: AppTypography.bodySubtitle.copyWith(
                  fontSize: 13.5,
                  height: 1.5,
                  color: const Color(0xFF475569),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 13),
                        side: const BorderSide(color: Color(0xFFCBD5E1)),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () => Navigator.pop(ctx),
                      child: const Text('Not Now', style: TextStyle(color: Color(0xFF475569), fontWeight: FontWeight.w700)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        padding: const EdgeInsets.symmetric(vertical: 13),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () {
                        Navigator.pop(ctx);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Google Fit connected successfully!'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      },
                      child: const Text('Connect', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void _showLogoutDialog() {
    HapticFeedback.lightImpact();
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text(
            'Log Out',
            style: AppTypography.headline.copyWith(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: const Color(0xFF0F172A),
            ),
          ),
          content: Text(
            'Are you sure you want to log out of Tolii?',
            style: AppTypography.bodySubtitle.copyWith(
              fontSize: 14,
              color: const Color(0xFF64748B),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel', style: TextStyle(color: Color(0xFF64748B), fontWeight: FontWeight.w600)),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => const WelcomeScreen()),
                  (route) => false,
                );
              },
              child: const Text(
                'Log Out',
                style: TextStyle(color: Color(0xFFDC2626), fontWeight: FontWeight.w700),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = ActivitiesController();

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        bottom: false,
        child: ListenableBuilder(
          listenable: controller,
          builder: (context, _) {
            final userGames = controller.userActivities;

            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. Top Header: "My Profile" + Settings Gear Button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'My Profile',
                        style: AppTypography.headline.copyWith(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFF0F172A),
                          letterSpacing: -0.3,
                        ),
                      ),
                      GestureDetector(
                        onTap: _openEditProfile,
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            border: Border.all(color: const Color(0xFFE2E8F0)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.03),
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.settings_outlined,
                            size: 20,
                            color: Color(0xFF0F172A),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // 2. Profile Identity Card (Screenshot 3)
                  Row(
                    children: [
                      // Avatar
                      Container(
                        width: 68,
                        height: 68,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color(0xFF2563EB),
                          border: Border.all(color: Colors.white, width: 2.5),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.06),
                              blurRadius: 10,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          _userName.isNotEmpty ? _userName[0] : 'A',
                          style: AppTypography.headline.copyWith(
                            fontSize: 26,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),

                      // User Info
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _userName,
                              style: AppTypography.titleLarge.copyWith(
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                                color: const Color(0xFF0F172A),
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              _userHandle,
                              style: AppTypography.caption.copyWith(
                                fontSize: 13,
                                color: const Color(0xFF64748B),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(
                                  Icons.location_on_rounded,
                                  size: 14,
                                  color: Color(0xFF94A3B8),
                                ),
                                const SizedBox(width: 3),
                                Text(
                                  _userLocation,
                                  style: AppTypography.caption.copyWith(
                                    fontSize: 12,
                                    color: const Color(0xFF64748B),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // 3. Stats Row Card (42 PLAYED · 18 WINS · ⭐ 4.8 RATING)
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.02),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        _buildStatColumn('42', 'PLAYED'),
                        _buildStatDivider(),
                        _buildStatColumn('18', 'WINS'),
                        _buildStatDivider(),
                        _buildStatColumn('4.8', 'RATING', isRating: true),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // 4. MY SPORTS Section
                  Text(
                    'MY SPORTS',
                    style: AppTypography.caption.copyWith(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.6,
                      color: const Color(0xFF64748B),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    child: Row(
                      children: _sports.map((sport) {
                        final isSelected = sport == _selectedSport;
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedSport = sport;
                            });
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 180),
                            margin: const EdgeInsets.only(right: 10),
                            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8.5),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppColors.primary
                                  : const Color(0xFFEEF4FF),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              sport,
                              style: AppTypography.caption.copyWith(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: isSelected
                                    ? Colors.white
                                    : const Color(0xFF2563EB),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 22),

                  // 5. Active Level Card
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.02),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Active Level',
                          style: AppTypography.titleMedium.copyWith(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            color: const Color(0xFF0F172A),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildActiveLevelItem(
                              icon: Icons.local_fire_department_outlined,
                              label: 'Warming up',
                              isActive: false,
                            ),
                            _buildActiveLevelItem(
                              icon: Icons.local_fire_department_rounded,
                              label: 'Active',
                              isActive: true,
                            ),
                            _buildActiveLevelItem(
                              icon: Icons.local_fire_department_outlined,
                              label: 'Super Active',
                              isActive: false,
                            ),
                            _buildActiveLevelItem(
                              icon: Icons.local_fire_department_outlined,
                              label: 'On fire',
                              isActive: false,
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        // Indicator Bar
                        Stack(
                          children: [
                            Container(
                              height: 5,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: const Color(0xFFEEF2F6),
                                borderRadius: BorderRadius.circular(3),
                              ),
                            ),
                            FractionallySizedBox(
                              widthFactor: 0.45,
                              child: Container(
                                height: 5,
                                decoration: BoxDecoration(
                                  color: AppColors.primary,
                                  borderRadius: BorderRadius.circular(3),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),

                  // 6. Link your Google Fit Card
                  GestureDetector(
                    onTap: _openGoogleFitSheet,
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.02),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFF7ED),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            alignment: Alignment.center,
                            child: const Icon(
                              Icons.local_fire_department_rounded,
                              color: Color(0xFFF97316),
                              size: 26,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Link your Google Fit',
                                  style: AppTypography.titleMedium.copyWith(
                                    fontSize: 14.5,
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xFF0F172A),
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'Set a goal for yourself and track your progress on a weekly basis',
                                  style: AppTypography.caption.copyWith(
                                    fontSize: 11.5,
                                    height: 1.35,
                                    color: const Color(0xFF64748B),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // 7. Upcoming Games (Screenshot 3 & Host Wiring)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Upcoming Games',
                        style: AppTypography.headline.copyWith(
                          fontSize: 17.5,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFF0F172A),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: Text(
                          'See all',
                          style: AppTypography.caption.copyWith(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // Games List
                  ...userGames.map((game) {
                    final parts = game.subtitle.split(' · ');
                    final timeText = parts.length > 1 ? '${parts[0]} · ${parts[1]}' : game.subtitle;
                    final venueText = game.venueName ?? (parts.length > 2 ? parts[2] : 'Bhavnagar Arena');
                    final progress = game.progress;

                    return GestureDetector(
                      onTap: () => _openActivityDetail(game),
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(color: const Color(0xFFE2E8F0)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.02),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                // Sport Icon Box
                                Container(
                                  width: 44,
                                  height: 44,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFEEF4FF),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  padding: const EdgeInsets.all(8),
                                  child: Image.asset(
                                    game.iconAsset,
                                    fit: BoxFit.contain,
                                    errorBuilder: (ctx, err, stack) => const Icon(
                                      Icons.sports_cricket_rounded,
                                      color: AppColors.primary,
                                      size: 22,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 14),

                                // Title & Time
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        game.title,
                                        style: AppTypography.titleMedium.copyWith(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w700,
                                          color: const Color(0xFF0F172A),
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        timeText,
                                        style: AppTypography.caption.copyWith(
                                          fontSize: 12,
                                          color: const Color(0xFF64748B),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),

                            // Venue Row
                            Row(
                              children: [
                                const Icon(
                                  Icons.location_on_rounded,
                                  size: 14,
                                  color: Color(0xFF94A3B8),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  venueText,
                                  style: AppTypography.caption.copyWith(
                                    fontSize: 12,
                                    color: const Color(0xFF64748B),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            const Divider(color: Color(0xFFF1F5F9), height: 1),
                            const SizedBox(height: 10),

                            // Players & Progress
                            Row(
                              children: [
                                // Mini avatar stack
                                SizedBox(
                                  width: 32,
                                  height: 20,
                                  child: Stack(
                                    children: [
                                      Container(
                                        width: 18,
                                        height: 18,
                                        decoration: const BoxDecoration(
                                          color: Color(0xFF94A3B8),
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                      Positioned(
                                        left: 10,
                                        child: Container(
                                          width: 18,
                                          height: 18,
                                          decoration: BoxDecoration(
                                            color: const Color(0xFF2563EB),
                                            shape: BoxShape.circle,
                                            border: Border.all(color: Colors.white, width: 1.5),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  '${game.joinedPlayers}/${game.totalPlayers} players',
                                  style: AppTypography.caption.copyWith(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xFF0F172A),
                                  ),
                                ),
                                const Spacer(),

                                // Progress Indicator Pill
                                Container(
                                  width: 80,
                                  height: 5,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFEEF2F6),
                                    borderRadius: BorderRadius.circular(3),
                                  ),
                                  alignment: Alignment.centerLeft,
                                  child: FractionallySizedBox(
                                    widthFactor: progress.clamp(0.05, 1.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: AppColors.primary,
                                        borderRadius: BorderRadius.circular(3),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                  const SizedBox(height: 20),

                  // 8. Recent Activity (Screenshot 4)
                  Text(
                    'Recent Activity',
                    style: AppTypography.headline.copyWith(
                      fontSize: 17.5,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildRecentActivityItem(
                    icon: Icons.emoji_events_outlined,
                    iconBgColor: const Color(0xFFE6F7F0),
                    iconColor: const Color(0xFF10B981),
                    title: 'Won a Football match',
                    subtitle: '3 days ago',
                  ),
                  const SizedBox(height: 10),
                  _buildRecentActivityItem(
                    icon: Icons.groups_outlined,
                    iconBgColor: const Color(0xFFEEF4FF),
                    iconColor: const Color(0xFF2563EB),
                    title: 'Joined Pickleball group',
                    subtitle: '1 week ago',
                  ),
                  const SizedBox(height: 24),

                  // 9. Squads (Screenshot 4)
                  Text(
                    'Squads',
                    style: AppTypography.headline.copyWith(
                      fontSize: 17.5,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      // Squad Card 1
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: const Color(0xFFE2E8F0)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.02),
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 38,
                                height: 38,
                                decoration: const BoxDecoration(
                                  color: Color(0xFF0A2540),
                                  shape: BoxShape.circle,
                                ),
                                alignment: Alignment.center,
                                child: const Icon(
                                  Icons.sports_cricket_rounded,
                                  color: Colors.white,
                                  size: 18,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Mumbai Cricket Club',
                                      style: AppTypography.titleMedium.copyWith(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w700,
                                        color: const Color(0xFF0F172A),
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 1),
                                    Text(
                                      'Gota · 181 Members',
                                      style: AppTypography.caption.copyWith(
                                        fontSize: 11,
                                        color: const Color(0xFF64748B),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),

                      // Squad Badge 2
                      Container(
                        width: 50,
                        height: 60,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: const Color(0xFFE2E8F0)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.02),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        alignment: Alignment.center,
                        child: Container(
                          width: 34,
                          height: 34,
                          decoration: const BoxDecoration(
                            color: Color(0xFF94A3B8),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.shield_outlined,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 28),

                  // 10. Log Out Button (Screenshot 4)
                  GestureDetector(
                    onTap: _showLogoutDialog,
                    child: Container(
                      width: double.infinity,
                      height: 50,
                      decoration: BoxDecoration(
                        color: const Color(0xFFDC2626), // Solid red
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFFDC2626).withValues(alpha: 0.28),
                            blurRadius: 10,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        'Log Out',
                        style: AppTypography.buttonText.copyWith(
                          fontSize: 15.5,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),

                  // Extra bottom padding to clear CustomBottomNavBar
                  SizedBox(height: MediaQuery.of(context).padding.bottom + 90),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildStatColumn(String value, String label, {bool isRating = false}) {
    return Expanded(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (isRating) ...[
                const Icon(
                  Icons.star_rounded,
                  color: Color(0xFFF59E0B),
                  size: 20,
                ),
                const SizedBox(width: 3),
              ],
              Text(
                value,
                style: AppTypography.headline.copyWith(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF0F172A),
                ),
              ),
            ],
          ),
          const SizedBox(height: 3),
          Text(
            label,
            style: AppTypography.caption.copyWith(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
              color: const Color(0xFF64748B),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatDivider() {
    return Container(
      width: 1,
      height: 32,
      color: const Color(0xFFE2E8F0),
    );
  }

  Widget _buildActiveLevelItem({
    required IconData icon,
    required String label,
    required bool isActive,
  }) {
    return Column(
      children: [
        Icon(
          icon,
          size: 22,
          color: isActive ? AppColors.primary : const Color(0xFF94A3B8),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: AppTypography.caption.copyWith(
            fontSize: 11,
            fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
            color: isActive ? AppColors.primary : const Color(0xFF64748B),
          ),
        ),
      ],
    );
  }

  Widget _buildRecentActivityItem({
    required IconData icon,
    required Color iconBgColor,
    required Color iconColor,
    required String title,
    required String subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: iconBgColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTypography.titleMedium.copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: AppTypography.caption.copyWith(
                    fontSize: 12,
                    color: const Color(0xFF64748B),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
