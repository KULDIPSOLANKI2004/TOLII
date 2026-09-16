import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/app_colors.dart';
import '../constants/app_typography.dart';
import 'community_chat_screen.dart';

class CommunityModel {
  final String id;
  final String title;
  final String lastMessage;
  final String time;
  final int unreadCount;
  final IconData icon;
  final Color iconColor;
  final Color iconBgColor;
  final String avatarInitials;

  const CommunityModel({
    required this.id,
    required this.title,
    required this.lastMessage,
    required this.time,
    this.unreadCount = 0,
    required this.icon,
    required this.iconColor,
    required this.iconBgColor,
    required this.avatarInitials,
  });
}

class CommunityScreen extends StatefulWidget {
  const CommunityScreen({super.key});

  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {
  final TextEditingController _searchController = TextEditingController();

  final List<CommunityModel> _communities = const [
    CommunityModel(
      id: 'comm_1',
      title: 'Box Cricket Bhavnagar',
      lastMessage: 'Anyone playing tonight?',
      time: '8:42 PM',
      unreadCount: 3,
      icon: Icons.sports_cricket_rounded,
      iconColor: Color(0xFF0284C7),
      iconBgColor: Color(0xFFE0F2FE),
      avatarInitials: 'BC',
    ),
    CommunityModel(
      id: 'comm_2',
      title: 'Weekend Cyclists 🚴',
      lastMessage: 'Sunday morning ride?',
      time: '7:18 PM',
      unreadCount: 5,
      icon: Icons.directions_bike_rounded,
      iconColor: Color(0xFF16A34A),
      iconBgColor: Color(0xFFDCFCE7),
      avatarInitials: 'WC',
    ),
    CommunityModel(
      id: 'comm_3',
      title: 'Pickleball Players',
      lastMessage: 'Court booked for 6:30!',
      time: 'Yesterday',
      unreadCount: 2,
      icon: Icons.sports_tennis_rounded,
      iconColor: Color(0xFFD97706),
      iconBgColor: Color(0xFFFEF3C7),
      avatarInitials: 'PB',
    ),
    CommunityModel(
      id: 'comm_4',
      title: 'Bhavnagar Football',
      lastMessage: 'Need 2 more players',
      time: 'Yesterday',
      unreadCount: 0,
      icon: Icons.sports_soccer_rounded,
      iconColor: Color(0xFF7C3AED),
      iconBgColor: Color(0xFFF3E8FF),
      avatarInitials: 'BF',
    ),
    CommunityModel(
      id: 'comm_5',
      title: 'Gaming Hangout',
      lastMessage: 'Anyone up for a game?',
      time: 'Yesterday',
      unreadCount: 7,
      icon: Icons.sports_esports_rounded,
      iconColor: Color(0xFF2563EB),
      iconBgColor: Color(0xFFDBEAFE),
      avatarInitials: 'GH',
    ),
    CommunityModel(
      id: 'comm_6',
      title: 'Photography Walks',
      lastMessage: "Let's meet near Takhteshwar",
      time: 'Mon',
      unreadCount: 0,
      icon: Icons.camera_alt_outlined,
      iconColor: Color(0xFFDB2777),
      iconBgColor: Color(0xFFFCE7F3),
      avatarInitials: 'PW',
    ),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _openChat(CommunityModel community) {
    HapticFeedback.lightImpact();
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => CommunityChatScreen(
          title: community.title,
          membersCount: '8 members',
          avatarInitials: community.avatarInitials,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Top Header: Avatar + "Hey Vatsal!" + Notification Bell
              Row(
                children: [
                  // Avatar 'V'
                  Container(
                    width: 46,
                    height: 46,
                    decoration: const BoxDecoration(
                      color: AppColors.avatarGreen,
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      'V',
                      style: AppTypography.titleLarge.copyWith(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Greeting & City
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Hey Vatsal!',
                          style: AppTypography.headline.copyWith(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: const Color(0xFF0F172A),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Bhavnagar',
                          style: AppTypography.caption.copyWith(
                            fontSize: 12.5,
                            color: const Color(0xFF64748B),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Notification Bell with Badge
                  GestureDetector(
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("You're all caught up!"),
                          duration: Duration(seconds: 1),
                        ),
                      );
                    },
                    child: Container(
                      width: 42,
                      height: 42,
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
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          const Icon(
                            Icons.notifications_none_rounded,
                            size: 20,
                            color: Color(0xFF0F172A),
                          ),
                          Positioned(
                            top: 10,
                            right: 11,
                            child: Container(
                              width: 7,
                              height: 7,
                              decoration: const BoxDecoration(
                                color: Color(0xFFEA580C),
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // 2. Search Field
              Container(
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFFE2E8F0), width: 1.2),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.02),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: TextField(
                  controller: _searchController,
                  style: AppTypography.bodySubtitle.copyWith(
                    fontSize: 14,
                    color: const Color(0xFF0F172A),
                  ),
                  decoration: InputDecoration(
                    hintText: 'Search activities, people or places',
                    hintStyle: AppTypography.caption.copyWith(
                      fontSize: 13.5,
                      color: const Color(0xFF94A3B8),
                    ),
                    prefixIcon: const Icon(
                      Icons.search_rounded,
                      size: 20,
                      color: Color(0xFF64748B),
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 13),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // 3. "Your Communities" Section
              Text(
                'Your Communities',
                style: AppTypography.headline.copyWith(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF0F172A),
                ),
              ),
              const SizedBox(height: 14),

              // Communities Card List
              Container(
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
                  children: _communities.asMap().entries.map((entry) {
                    final idx = entry.key;
                    final comm = entry.value;
                    final isLast = idx == _communities.length - 1;

                    return Column(
                      children: [
                        InkWell(
                          onTap: () => _openChat(comm),
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(idx == 0 ? 18 : 0),
                            bottom: Radius.circular(isLast ? 18 : 0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
                            child: Row(
                              children: [
                                // Community Icon
                                Container(
                                  width: 44,
                                  height: 44,
                                  decoration: BoxDecoration(
                                    color: comm.iconBgColor,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    comm.icon,
                                    color: comm.iconColor,
                                    size: 22,
                                  ),
                                ),
                                const SizedBox(width: 14),

                                // Title & Last Message
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        comm.title,
                                        style: AppTypography.titleMedium.copyWith(
                                          fontSize: 14.5,
                                          fontWeight: FontWeight.w700,
                                          color: const Color(0xFF0F172A),
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        comm.lastMessage,
                                        style: AppTypography.caption.copyWith(
                                          fontSize: 12.5,
                                          color: const Color(0xFF64748B),
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),

                                // Time & Unread Badge
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      comm.time,
                                      style: AppTypography.caption.copyWith(
                                        fontSize: 11.5,
                                        fontWeight: FontWeight.w600,
                                        color: comm.unreadCount > 0
                                            ? AppColors.primary
                                            : const Color(0xFF94A3B8),
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    if (comm.unreadCount > 0)
                                      Container(
                                        width: 20,
                                        height: 20,
                                        decoration: const BoxDecoration(
                                          color: AppColors.primary,
                                          shape: BoxShape.circle,
                                        ),
                                        alignment: Alignment.center,
                                        child: Text(
                                          '${comm.unreadCount}',
                                          style: AppTypography.caption.copyWith(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w800,
                                            color: Colors.white,
                                          ),
                                        ),
                                      )
                                    else
                                      const SizedBox(height: 20),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        if (!isLast)
                          const Divider(
                            color: Color(0xFFF1F5F9),
                            height: 1,
                            indent: 74,
                          ),
                      ],
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 26),

              // 4. "Discover Communities" Section
              Text(
                'Discover Communities',
                style: AppTypography.headline.copyWith(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF0F172A),
                ),
              ),
              const SizedBox(height: 14),

              // Discover Cards Row
              Row(
                children: [
                  _buildDiscoverCard(
                    icon: Icons.sports_cricket_rounded,
                    iconColor: const Color(0xFF0284C7),
                    cardBg: const Color(0xFFE8F0FE),
                    title: 'Sports & Games',
                    onTap: () {
                      _openChat(const CommunityModel(
                        id: 'disc_1',
                        title: 'Sports & Games Community',
                        lastMessage: 'Welcome to Bhavnagar Sports!',
                        time: 'Now',
                        icon: Icons.sports_cricket_rounded,
                        iconColor: Color(0xFF0284C7),
                        iconBgColor: Color(0xFFE0F2FE),
                        avatarInitials: 'SG',
                      ));
                    },
                  ),
                  const SizedBox(width: 12),
                  _buildDiscoverCard(
                    icon: Icons.directions_bike_rounded,
                    iconColor: const Color(0xFF16A34A),
                    cardBg: const Color(0xFFE6F7ED),
                    title: 'Cycling Crew',
                    onTap: () {
                      _openChat(const CommunityModel(
                        id: 'disc_2',
                        title: 'Cycling Crew Bhavnagar',
                        lastMessage: 'Morning rides planned!',
                        time: 'Now',
                        icon: Icons.directions_bike_rounded,
                        iconColor: Color(0xFF16A34A),
                        iconBgColor: Color(0xFFDCFCE7),
                        avatarInitials: 'CC',
                      ));
                    },
                  ),
                  const SizedBox(width: 12),
                  _buildDiscoverCard(
                    icon: Icons.hiking_rounded,
                    iconColor: const Color(0xFFEA580C),
                    cardBg: const Color(0xFFFFF1E8),
                    title: 'Weekend Out',
                    onTap: () {
                      _openChat(const CommunityModel(
                        id: 'disc_3',
                        title: 'Weekend Out Crew',
                        lastMessage: 'Takhteshwar hike coming up!',
                        time: 'Now',
                        icon: Icons.hiking_rounded,
                        iconColor: Color(0xFFEA580C),
                        iconBgColor: Color(0xFFFFF1E8),
                        avatarInitials: 'WO',
                      ));
                    },
                  ),
                ],
              ),

              // Extra spacing for BottomNavBar
              SizedBox(height: MediaQuery.of(context).padding.bottom + 90),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDiscoverCard({
    required IconData icon,
    required Color iconColor,
    required Color cardBg,
    required String title,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 106,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: iconColor, size: 20),
              ),
              const SizedBox(height: 10),
              Text(
                title,
                style: AppTypography.caption.copyWith(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF0F172A),
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
