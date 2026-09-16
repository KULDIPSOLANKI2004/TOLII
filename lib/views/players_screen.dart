import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/app_colors.dart';
import '../constants/app_typography.dart';
import '../models/activity_model.dart';
import '../widgets/invite_players_sheet.dart';

class PlayersScreen extends StatefulWidget {
  final ActivityModel activity;

  const PlayersScreen({super.key, required this.activity});

  @override
  State<PlayersScreen> createState() => _PlayersScreenState();
}

class _PlayersScreenState extends State<PlayersScreen> {
  late List<PlayerModel> _playersList;

  @override
  void initState() {
    super.initState();
    _playersList = widget.activity.players ?? [
      const PlayerModel(
        id: 'p_1',
        name: 'Meet Patel',
        role: 'HOST',
        skill: 'Intermediate',
        isHost: true,
        avatarBgColor: Color(0xFF475569),
      ),
      const PlayerModel(
        id: 'p_2',
        name: 'Rohan Shah',
        role: 'MEMBER',
        skill: 'Advanced',
        avatarBgColor: Color(0xFF334155),
      ),
      const PlayerModel(
        id: 'p_3',
        name: 'Amit Gohel',
        role: 'MEMBER',
        skill: 'Intermediate',
        avatarBgColor: Color(0xFF0F172A),
      ),
      const PlayerModel(
        id: 'p_4',
        name: 'Divyesh Solanki',
        role: 'MEMBER',
        skill: 'Beginner',
        avatarBgColor: Color(0xFF2563EB),
      ),
      const PlayerModel(
        id: 'p_5',
        name: 'Hardik Vora',
        role: 'MEMBER',
        skill: 'Advanced',
        avatarBgColor: Color(0xFF64748B),
      ),
      const PlayerModel(
        id: 'p_6',
        name: 'Kunal Pandya',
        role: 'MEMBER',
        skill: 'Intermediate',
        avatarBgColor: Color(0xFF1E40AF),
      ),
    ];
  }

  void _openInviteSheet() {
    HapticFeedback.lightImpact();
    InvitePlayersBottomSheet.show(context, activity: widget.activity);
  }

  void _openManageSheet() {
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
          padding: EdgeInsets.fromLTRB(20, 14, 20, MediaQuery.of(ctx).padding.bottom + 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 38,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFCBD5E1),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Text(
                'Manage Roster',
                style: AppTypography.headline.copyWith(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF0F172A),
                ),
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: const Icon(Icons.person_add_outlined, color: AppColors.primary),
                title: const Text('Add Co-Host'),
                subtitle: const Text('Allow another player to manage this game'),
                onTap: () {
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Co-host feature coming soon!')),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.remove_circle_outline_rounded, color: Colors.redAccent),
                title: const Text('Remove Players'),
                subtitle: const Text('Manage joined attendees'),
                onTap: () {
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Select a player to remove.')),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final spotsLeft = widget.activity.totalPlayers - _playersList.length;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Top Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8FAFC),
                        shape: BoxShape.circle,
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      child: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        size: 16,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'Players',
                      style: AppTypography.headline.copyWith(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF0F172A),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(width: 38), // Balance for back button
                ],
              ),
            ),
            const Divider(color: Color(0xFFF1F5F9), height: 1),

            // Content
            Expanded(
              child: ListView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                children: [
                  // Subheader: "8 Players · 6 Open Spots" & "Invite Only"
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: '${widget.activity.totalPlayers} Players',
                              style: AppTypography.titleMedium.copyWith(
                                fontSize: 15,
                                fontWeight: FontWeight.w800,
                                color: const Color(0xFF0F172A),
                              ),
                            ),
                            TextSpan(
                              text: '  ·  ${spotsLeft > 0 ? spotsLeft : 0} Open Spots',
                              style: AppTypography.caption.copyWith(
                                fontSize: 13,
                                color: const Color(0xFF64748B),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          const Icon(
                            Icons.lock_outline_rounded,
                            size: 14,
                            color: AppColors.primary,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Invite Only',
                            style: AppTypography.caption.copyWith(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),

                  // Player Cards List
                  ..._playersList.map((player) {
                    final isHost = player.isHost;
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isHost ? const Color(0xFF2563EB) : const Color(0xFFE2E8F0),
                          width: isHost ? 1.4 : 1.0,
                        ),
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
                          // Avatar
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: player.avatarBgColor,
                              shape: BoxShape.circle,
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              player.name.isNotEmpty ? player.name[0] : 'P',
                              style: AppTypography.titleMedium.copyWith(
                                fontSize: 17,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(width: 14),

                          // Name & Skill
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  player.name,
                                  style: AppTypography.titleMedium.copyWith(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xFF0F172A),
                                  ),
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  player.skill,
                                  style: AppTypography.caption.copyWith(
                                    fontSize: 12.5,
                                    color: const Color(0xFF64748B),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Role Badge
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: isHost
                                  ? const Color(0xFFEEF4FF)
                                  : const Color(0xFFF1F5F9),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              player.role,
                              style: AppTypography.caption.copyWith(
                                fontSize: 11,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 0.4,
                                color: isHost
                                  ? AppColors.primary
                                  : const Color(0xFF64748B),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),

            // Sticky Bottom Action Buttons (Screenshot 2 right)
            Container(
              padding: EdgeInsets.fromLTRB(20, 12, 20, MediaQuery.of(context).padding.bottom + 12),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 10,
                    offset: const Offset(0, -3),
                  ),
                ],
              ),
              child: Row(
                children: [
                  // Add Players (Outlined)
                  Expanded(
                    child: GestureDetector(
                      onTap: _openInviteSheet,
                      child: Container(
                        height: 48,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: AppColors.primary,
                            width: 1.4,
                          ),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          'Add Players',
                          style: AppTypography.buttonText.copyWith(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Manage (Solid Blue)
                  Expanded(
                    child: GestureDetector(
                      onTap: _openManageSheet,
                      child: Container(
                        height: 48,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withValues(alpha: 0.25),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          'Manage',
                          style: AppTypography.buttonText.copyWith(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
