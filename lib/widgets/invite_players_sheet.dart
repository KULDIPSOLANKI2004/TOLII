import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/app_colors.dart';
import '../constants/app_typography.dart';
import '../controllers/activities_controller.dart';
import '../models/activity_model.dart';

class InvitePlayersBottomSheet extends StatefulWidget {
  final ActivityModel? activity;

  const InvitePlayersBottomSheet({super.key, this.activity});

  static Future<void> show(BuildContext context, {ActivityModel? activity}) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => InvitePlayersBottomSheet(activity: activity),
    );
  }

  @override
  State<InvitePlayersBottomSheet> createState() =>
      _InvitePlayersBottomSheetState();
}

class _InvitePlayersBottomSheetState extends State<InvitePlayersBottomSheet> {
  final TextEditingController _searchController = TextEditingController();
  final Set<String> _invitedIds = <String>{};

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _toggleInvite(String id, String name) {
    HapticFeedback.lightImpact();
    setState(() {
      if (_invitedIds.contains(id)) {
        _invitedIds.remove(id);
      } else {
        _invitedIds.add(id);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Invite sent to $name!'),
            duration: const Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    });
  }

  void _onQuickShare(String action) {
    HapticFeedback.lightImpact();
    String message = '';
    switch (action) {
      case 'public':
        message = 'Activity visibility set to Public!';
        break;
      case 'squads':
        message = 'Shared with your Squads!';
        break;
      case 'copy':
        Clipboard.setData(ClipboardData(
          text: 'Join my ${widget.activity?.title ?? 'game'} on Tolii! https://tolii.app/act/${widget.activity?.id ?? '123'}',
        ));
        message = 'Invite link copied to clipboard!';
        break;
      case 'external':
        message = 'Share dialog opened!';
        break;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = ActivitiesController();
    final quickInvites = controller.quickInvites;
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.fromLTRB(20, 10, 20, MediaQuery.of(context).padding.bottom + 20 + bottomInset),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag Handle
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

          // Header: Title + Close Button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Invite Players',
                style: AppTypography.headline.copyWith(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF0F172A),
                ),
              ),
              GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    shape: BoxShape.circle,
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: const Icon(
                    Icons.close_rounded,
                    size: 16,
                    color: Color(0xFF64748B),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Search Field
          Container(
            height: 46,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE2E8F0), width: 1.2),
            ),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search for players...',
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
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
          const SizedBox(height: 20),

          // QUICK SHARE OPTIONS Header
          Text(
            'QUICK SHARE OPTIONS',
            style: AppTypography.caption.copyWith(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.6,
              color: const Color(0xFF64748B),
            ),
          ),
          const SizedBox(height: 14),

          // 4 Action Buttons in a Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildShareOption(
                icon: Icons.language_rounded,
                label: 'Switch to\nPublic',
                onTap: () => _onQuickShare('public'),
              ),
              _buildShareOption(
                icon: Icons.groups_rounded,
                label: 'Squads',
                onTap: () => _onQuickShare('squads'),
              ),
              _buildShareOption(
                icon: Icons.link_rounded,
                label: 'Copy Link',
                onTap: () => _onQuickShare('copy'),
              ),
              _buildShareOption(
                icon: Icons.share_outlined,
                label: 'Share\nExternal',
                onTap: () => _onQuickShare('external'),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // QUICK INVITES Header
          Text(
            'QUICK INVITES',
            style: AppTypography.caption.copyWith(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.6,
              color: const Color(0xFF64748B),
            ),
          ),
          const SizedBox(height: 12),

          // Quick Invites List
          ...quickInvites.map((player) {
            final isInvited = _invitedIds.contains(player.id);
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
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
                  const SizedBox(width: 12),

                  // Name & Games Together Subtitle
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          player.name,
                          style: AppTypography.titleMedium.copyWith(
                            fontSize: 14.5,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF0F172A),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          player.subtitle ?? '3 games together',
                          style: AppTypography.caption.copyWith(
                            fontSize: 12,
                            color: const Color(0xFF64748B),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Invite Button
                  GestureDetector(
                    onTap: () => _toggleInvite(player.id, player.name),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 7,
                      ),
                      decoration: BoxDecoration(
                        color: isInvited ? const Color(0xFFEEF4FF) : AppColors.primary,
                        borderRadius: BorderRadius.circular(10),
                        border: isInvited
                            ? Border.all(color: AppColors.primary, width: 1.2)
                            : null,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (isInvited) ...[
                            const Icon(
                              Icons.check_rounded,
                              size: 14,
                              color: AppColors.primary,
                            ),
                            const SizedBox(width: 4),
                          ],
                          Text(
                            isInvited ? 'Invited' : 'Invite',
                            style: AppTypography.buttonText.copyWith(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: isInvited ? AppColors.primary : Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildShareOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            alignment: Alignment.center,
            child: Icon(
              icon,
              size: 22,
              color: const Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: AppTypography.caption.copyWith(
              fontSize: 11,
              height: 1.2,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF475569),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
