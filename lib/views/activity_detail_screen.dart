import 'package:flutter/material.dart';
import '../constants/app_assets.dart';
import '../constants/app_colors.dart';
import '../constants/app_typography.dart';
import '../models/activity_model.dart';
import 'joined_screen.dart';

class ActivityDetailScreen extends StatefulWidget {
  final ActivityModel activity;

  const ActivityDetailScreen({super.key, required this.activity});

  @override
  State<ActivityDetailScreen> createState() => _ActivityDetailScreenState();
}

class _ActivityDetailScreenState extends State<ActivityDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final activity = widget.activity;
    final parts = activity.subtitle.split(' · ');
    final timeStr = parts.length > 1 ? parts[1] : '8:00 PM';
    final dateStr = parts.isNotEmpty ? parts[0] : 'Today';
    final spotsLeft = activity.totalPlayers - activity.joinedPlayers;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F9),
      body: Column(
        children: [
          // ── Scrollable body ──
          Expanded(
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                // ── 1. Blue Header with Overlapping Venue Card (ss1) ──
                SliverToBoxAdapter(
                  child: _buildHeaderWithVenueOverlay(activity, dateStr, timeStr, spotsLeft),
                ),

                // ── 2. Stats Row ──
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
                    child: _buildStatsRow(activity, timeStr, dateStr, spotsLeft),
                  ),
                ),

                // ── 3. Court Photo (all activities use Pickleball court photo) ──
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                    child: _buildCourtPhoto(activity),
                  ),
                ),

                // ── 4. Players Section (uniform cards - ss2) ──
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 22, 16, 0),
                    child: _buildPlayersSection(),
                  ),
                ),

                // ── 5. Game Chat (bubble layout - ss4) ──
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 22, 16, 0),
                    child: _buildGameChat(),
                  ),
                ),

                // ── 6. Questions ──
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 22, 16, 0),
                    child: _buildQuestions(),
                  ),
                ),

                // ── 7. About ──
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 22, 16, 0),
                    child: _buildAbout(activity),
                  ),
                ),

                // ── 8. Where you'll play (Map) ──
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 22, 16, 0),
                    child: _buildWhereYouPlay(),
                  ),
                ),

                // Bottom spacing
                const SliverToBoxAdapter(child: SizedBox(height: 100)),
              ],
            ),
          ),

          // ── Sticky Bottom CTA ──
          _buildBottomCTA(context, activity, spotsLeft),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────
  // 1. BLUE HEADER WITH OVERLAPPING VENUE CARD (ss1)
  // ─────────────────────────────────────────
  Widget _buildHeaderWithVenueOverlay(
    ActivityModel activity,
    String dateStr,
    String timeStr,
    int spotsLeft,
  ) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Blue background extending behind the top half of the venue card
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          bottom: 50,
          child: Container(
            color: AppColors.primary,
          ),
        ),

        // Foreground content: Header details + Overlapping Venue Card
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top bar: back + share
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.of(context).pop(),
                          child: Container(
                            width: 38,
                            height: 38,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.18),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.arrow_back_ios_new_rounded,
                              color: Colors.white,
                              size: 18,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {},
                          child: Container(
                            width: 38,
                            height: 38,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.18),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.ios_share_rounded,
                              color: Colors.white,
                              size: 18,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),

                    // Title + players badge
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Text(
                            activity.title,
                            style: AppTypography.headline.copyWith(
                              fontSize: 28,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                              letterSpacing: -0.4,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFECCC),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            '${activity.joinedPlayers}/${activity.totalPlayers} Players',
                            style: AppTypography.caption.copyWith(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFFD97706),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),

                    // Subtitle: date · time · location
                    Text(
                      '$dateStr · $timeStr · Bhavnagar',
                      style: AppTypography.bodySubtitle.copyWith(
                        color: Colors.white.withValues(alpha: 0.85),
                        fontSize: 13.5,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Venue card overlapping the blue boundary
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 2, 16, 0),
              child: _buildVenueCard(),
            ),
          ],
        ),
      ],
    );
  }

  // ─────────────────────────────────────────
  // 2. VENUE CARD
  // ─────────────────────────────────────────
  Widget _buildVenueCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.07),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFFEEF4FF),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.location_on_rounded,
                  color: AppColors.primary,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Bhavnagar Pickleball Arena',
                      style: AppTypography.titleMedium.copyWith(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Bhavnagar · 2.1 km away',
                      style: AppTypography.caption.copyWith(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(color: Color(0xFFF1F5F9), height: 1),
          const SizedBox(height: 10),
          Row(
            children: [
              const Icon(Icons.check_circle_rounded, size: 17, color: Color(0xFF16A34A)),
              const SizedBox(width: 6),
              Text(
                'Venue confirmed',
                style: AppTypography.caption.copyWith(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF16A34A),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────
  // 3. STATS ROW (4 columns)
  // ─────────────────────────────────────────
  Widget _buildStatsRow(ActivityModel activity, String timeStr, String dateStr, int spotsLeft) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
      child: Row(
        children: [
          // Time
          Expanded(
            child: _statCell(
              icon: AppAssets.iconClock,
              value: timeStr,
              label: dateStr,
              labelColor: AppColors.textSecondary,
            ),
          ),
          _verticalDivider(),
          // Players
          Expanded(
            child: _statCell(
              icon: AppAssets.iconUsers,
              value: '${activity.joinedPlayers}/${activity.totalPlayers} players',
              label: '$spotsLeft spots left',
              labelColor: const Color(0xFFEA580C),
            ),
          ),
          _verticalDivider(),
          // Skill
          Expanded(
            child: _statCell(
              icon: AppAssets.iconAward,
              value: activity.skillLevel.label,
              label: 'Friendly',
              labelColor: AppColors.textSecondary,
            ),
          ),
          _verticalDivider(),
          // Price
          Expanded(
            child: _statCell(
              icon: AppAssets.iconCreditCard,
              value: activity.pricePerPerson == 0 ? 'Free' : '₹${activity.pricePerPerson}',
              label: 'per person',
              labelColor: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _statCell({
    required String icon,
    required String value,
    required String label,
    required Color labelColor,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(icon, width: 22, height: 22, color: AppColors.primary),
        const SizedBox(height: 7),
        Text(
          value,
          style: AppTypography.caption.copyWith(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: AppColors.textDark,
          ),
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: AppTypography.caption.copyWith(
            fontSize: 11,
            color: labelColor,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _verticalDivider() {
    return Container(
      width: 1,
      height: 44,
      color: const Color(0xFFEFF2F6),
    );
  }

  // ─────────────────────────────────────────
  // 4. COURT PHOTO (All activities use Pickleball Court photo)
  // ─────────────────────────────────────────
  Widget _buildCourtPhoto(ActivityModel activity) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: Image.asset(
        AppAssets.pickleballCourtsPng,
        width: double.infinity,
        height: 200,
        fit: BoxFit.cover,
      ),
    );
  }

  // ─────────────────────────────────────────
  // 5. PLAYERS SECTION (Uniform cards - ss2)
  // ─────────────────────────────────────────
  Widget _buildPlayersSection() {
    final players = [
      {'initial': 'V', 'name': 'Vatsal P.', 'role': 'Host', 'color': const Color(0xFF0D47A1)},
      {'initial': 'H', 'name': 'Hetal B.', 'role': 'Intermediate', 'color': const Color(0xFFE11D48)},
      {'initial': 'A', 'name': 'Arjun M.', 'role': 'Beginner', 'color': const Color(0xFF10B981)},
      {'initial': 'P', 'name': 'Priya K.', 'role': 'Beginner', 'color': const Color(0xFFF59E0B)},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section title
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: 'Players',
                style: AppTypography.headline.copyWith(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textDark,
                ),
              ),
              TextSpan(
                text: ' · 6',
                style: AppTypography.headline.copyWith(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textDark,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Meet who\'s joining',
          style: AppTypography.bodySubtitle.copyWith(
            fontSize: 13,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 14),

        // Player cards horizontal scroll - all same uniform size (ss2)
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          child: Row(
            children: players.map((p) {
              return Container(
                width: 86,
                height: 126,
                margin: const EdgeInsets.only(right: 10),
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFEFF2F6), width: 1.2),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.03),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: p['color'] as Color,
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        p['initial'] as String,
                        style: AppTypography.titleMedium.copyWith(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      p['name'] as String,
                      style: AppTypography.caption.copyWith(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textDark,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2.5),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEFF6FF),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        p['role'] as String,
                        style: AppTypography.caption.copyWith(
                          fontSize: 10.5,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF2563EB),
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 14),

        // View all link
        GestureDetector(
          onTap: () {},
          child: Row(
            children: [
              Text(
                'View all players',
                style: AppTypography.bodySubtitle.copyWith(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: 4),
              const Icon(Icons.arrow_forward_rounded, size: 16, color: AppColors.primary),
            ],
          ),
        ),
      ],
    );
  }

  // ─────────────────────────────────────────
  // 6. GAME CHAT (Bubble layout - ss4)
  // ─────────────────────────────────────────
  Widget _buildGameChat() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Game chat',
          style: AppTypography.headline.copyWith(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: AppColors.textDark,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Talk with players before the game',
          style: AppTypography.bodySubtitle.copyWith(fontSize: 13, color: AppColors.textSecondary),
        ),
        const SizedBox(height: 14),

        // Chat messages container
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: const Color(0xFFEFF2F6), width: 1.2),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          padding: const EdgeInsets.all(14),
          child: Column(
            children: [
              _chatBubble(
                initial: 'R',
                name: 'Riya S.',
                message: 'Are we meeting at the venue directly?',
                avatarColor: const Color(0xFFE11D48),
              ),
              const SizedBox(height: 12),
              _chatBubble(
                initial: 'H',
                name: 'Hetal B.',
                message: 'Mummy ne mana ker diya!!!!',
                avatarColor: const Color(0xFF10B981),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),

        GestureDetector(
          onTap: () {},
          child: Row(
            children: [
              Text(
                'Open group chat',
                style: AppTypography.bodySubtitle.copyWith(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: 4),
              const Icon(Icons.arrow_forward_rounded, size: 16, color: AppColors.primary),
            ],
          ),
        ),
      ],
    );
  }

  Widget _chatBubble({
    required String initial,
    required String name,
    required String message,
    required Color avatarColor,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(color: avatarColor, shape: BoxShape.circle),
          alignment: Alignment.center,
          child: Text(
            initial,
            style: AppTypography.caption.copyWith(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: AppTypography.caption.copyWith(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  message,
                  style: AppTypography.caption.copyWith(
                    fontSize: 12.5,
                    color: const Color(0xFF334155),
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ─────────────────────────────────────────
  // 7. QUESTIONS
  // ─────────────────────────────────────────
  Widget _buildQuestions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Questions',
          style: AppTypography.headline.copyWith(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: AppColors.textDark,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFFEFF2F6)),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  'Anyone bringing extra paddles?',
                  style: AppTypography.bodySubtitle.copyWith(
                    fontSize: 13.5,
                    color: AppColors.textDark,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  'Ask group',
                  style: AppTypography.caption.copyWith(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ─────────────────────────────────────────
  // 8. ABOUT THIS ACTIVITY
  // ─────────────────────────────────────────
  Widget _buildAbout(ActivityModel activity) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'About this activity',
          style: AppTypography.headline.copyWith(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: AppColors.textDark,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          'Casual ${activity.title.toLowerCase()} game for players of all levels. Come meet new people, have fun and get a game going.',
          style: AppTypography.bodySubtitle.copyWith(
            fontSize: 13.5,
            height: 1.6,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 14),
        _bulletRow('Equipment:', 'Not provided'),
        const SizedBox(height: 6),
        _bulletRow('Skill level:', '${activity.skillLevel.label} friendly'),
        const SizedBox(height: 6),
        _bulletRow('Duration:', '~1 hour'),
        const SizedBox(height: 6),
        _bulletRow(
          'Players needed:',
          '${activity.totalPlayers - activity.joinedPlayers}',
        ),
      ],
    );
  }

  Widget _bulletRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 5,
          height: 5,
          margin: const EdgeInsets.only(top: 5, right: 10),
          decoration: const BoxDecoration(
            color: AppColors.textSecondary,
            shape: BoxShape.circle,
          ),
        ),
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: '$label ',
                style: AppTypography.bodySubtitle.copyWith(
                  fontSize: 13.5,
                  color: AppColors.textSecondary,
                ),
              ),
              TextSpan(
                text: value,
                style: AppTypography.bodySubtitle.copyWith(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textDark,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ─────────────────────────────────────────
  // 9. WHERE YOU'LL PLAY
  // ─────────────────────────────────────────
  Widget _buildWhereYouPlay() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Where you\'ll play',
          style: AppTypography.headline.copyWith(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: AppColors.textDark,
          ),
        ),
        const SizedBox(height: 14),

        // Map image
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Image.asset(
            AppAssets.mapImage,
            width: double.infinity,
            height: 180,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(height: 12),

        // Venue row + open in maps
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Bhavnagar Pickleball Arena',
                    style: AppTypography.titleMedium.copyWith(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '2.1 km from you',
                    style: AppTypography.caption.copyWith(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () {},
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: const Color(0xFFEEF4FF),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFBDD0F8)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.navigation_rounded, size: 15, color: AppColors.primary),
                    const SizedBox(width: 6),
                    Text(
                      'Open in Maps',
                      style: AppTypography.caption.copyWith(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ─────────────────────────────────────────
  // STICKY BOTTOM CTA
  // ─────────────────────────────────────────
  Widget _buildBottomCTA(BuildContext context, ActivityModel activity, int spotsLeft) {
    return Container(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 14,
        bottom: MediaQuery.of(context).padding.bottom + 14,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        border: const Border(top: BorderSide(color: Color(0xFFEFF2F6), width: 1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Price + spots
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    activity.pricePerPerson == 0 ? 'Free' : '₹${activity.pricePerPerson}',
                    style: AppTypography.headline.copyWith(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textDark,
                      letterSpacing: -0.3,
                    ),
                  ),
                  if (activity.pricePerPerson > 0)
                    Text(
                      ' / person',
                      style: AppTypography.caption.copyWith(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                ],
              ),
              if (spotsLeft > 0)
                Text(
                  '$spotsLeft spots left',
                  style: AppTypography.caption.copyWith(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFFEA580C),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 16),

          // Join Game button
          Expanded(
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => JoinedScreen(activity: activity),
                  ),
                );
              },
              child: Container(
                height: 52,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.35),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                alignment: Alignment.center,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Join Game',
                      style: AppTypography.buttonText.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.2,
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 18),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
