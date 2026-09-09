import 'package:flutter/material.dart';
import '../constants/app_assets.dart';
import '../constants/app_colors.dart';
import '../controllers/activities_controller.dart';
import '../models/activity_model.dart';
import '../widgets/date_picker_bottom_sheet.dart';
import '../widgets/select_activity_sheet.dart';
import '../widgets/select_location_sheet.dart';
import '../widgets/time_picker_modal.dart';
import 'activity_created_screen.dart';

class CreateActivityScreen extends StatefulWidget {
  const CreateActivityScreen({super.key});

  @override
  State<CreateActivityScreen> createState() => _CreateActivityScreenState();
}

class _CreateActivityScreenState extends State<CreateActivityScreen> {
  // 1. Grouped Card State
  String _sportTitle = 'Box Cricket';
  String _sportIcon = AppAssets.actBoxCricket;
  SportCategory _sportCategory = SportCategory.boxCricket;

  String _venueName = 'Bhavnagar';
  DateTime _selectedDate = DateTime(2025, 8, 24);
  String _dateFormatted = 'Saturday, 24 Aug';

  int _hour = 6;
  int _minute = 30;
  bool _isPm = true;
  String _timeFormatted = '6:30 PM';

  // 2. Players Counter
  int _playersNeeded = 8;

  // 3. Skill Level
  SkillLevel _selectedSkillLevel = SkillLevel.allLevels;
  final List<SkillLevel> _skillLevels = [
    SkillLevel.allLevels,
    SkillLevel.beginner,
    SkillLevel.intermediate,
    SkillLevel.advanced,
  ];

  // 4. Cost Per Person
  int _selectedCost = 100;
  final List<int> _costOptions = [0, 60, 100, 150];
  bool _splitCost = true;

  // 5. Who Can Join
  String _whoCanJoin = 'Public';
  final List<String> _joinOptions = ['Public', 'Friends', 'Invite only'];

  // 6. Note
  final TextEditingController _noteController = TextEditingController(
    text: 'Casual box cricket game. No experience needed — just come and play!',
  );

  // 7. Group Chat
  bool _createGroupChat = true;

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  void _openSelectActivity() async {
    final result = await Navigator.of(context).push<ActivitySelectionItem>(
      MaterialPageRoute(
        builder: (_) => SelectActivitySheet(currentSelected: _sportTitle),
      ),
    );
    if (result != null) {
      setState(() {
        _sportTitle = result.title;
        _sportIcon = result.iconAsset;
        _sportCategory = result.sportCategory;
      });
    }
  }

  void _openSelectLocation() async {
    final result = await showModalBottomSheet<LocationVenueItem>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => SelectLocationSheet(currentSelectedVenue: _venueName),
    );
    if (result != null) {
      setState(() {
        _venueName = result.name;
      });
    }
  }

  void _openDatePicker() async {
    final result = await showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => DatePickerBottomSheet(initialDate: _selectedDate),
    );
    if (result != null) {
      setState(() {
        _selectedDate = result['date'] as DateTime;
        _dateFormatted = result['formatted'] as String;
      });
    }
  }

  void _openTimePicker() async {
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (_) => TimePickerModal(
        initialHour: _hour,
        initialMinute: _minute,
        initialIsPm: _isPm,
      ),
    );
    if (result != null) {
      setState(() {
        _hour = result['hour'] as int;
        _minute = result['minute'] as int;
        _isPm = result['isPm'] as bool;
        _timeFormatted = result['formatted'] as String;
      });
    }
  }

  void _createActivity() {
    final newActivity = ActivityModel(
      id: 'act_${DateTime.now().millisecondsSinceEpoch}',
      title: _sportTitle,
      subtitle: '$_dateFormatted · $_timeFormatted · $_venueName',
      iconAsset: _sportIcon,
      sportCategory: _sportCategory,
      skillLevel: _selectedSkillLevel,
      joinedPlayers: 1,
      totalPlayers: _playersNeeded,
      pricePerPerson: _selectedCost,
      note: _noteController.text.trim(),
      date: _selectedDate,
    );

    // Add to ActivitiesController singleton
    ActivitiesController().addActivity(newActivity);

    // Push to ActivityCreatedScreen
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => ActivityCreatedScreen(activity: newActivity),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: Column(
          children: [
            // Top Navigation Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      child: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        size: 15,
                        color: AppColors.textDark,
                      ),
                    ),
                  ),
                  const Expanded(
                    child: Column(
                      children: [
                        Text(
                          'Create Activity',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textDark,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Bring people together',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF64748B),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 38), // Balanced alignment
                ],
              ),
            ),

            // Scrollable Form Body
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── 1. Grouped Information Card (Activity, Where, Date, Time) ──
                    _buildGroupedInfoCard(),
                    const SizedBox(height: 16),

                    // ── 2. Players Needed Card ──
                    _buildPlayersNeededCard(),
                    const SizedBox(height: 20),

                    // ── 3. Skill Level Section ──
                    _buildSkillLevelSection(),
                    const SizedBox(height: 20),

                    // ── 4. Cost Per Person Card ──
                    _buildCostCard(),
                    const SizedBox(height: 20),

                    // ── 5. Who Can Join Card ──
                    _buildWhoCanJoinCard(),
                    const SizedBox(height: 20),

                    // ── 6. Add a Note Section ──
                    _buildNoteSection(),
                    const SizedBox(height: 16),

                    // ── 7. Group Chat Card ──
                    _buildGroupChatCard(),
                    const SizedBox(height: 28),

                    // ── 8. Create Button CTA ──
                    _buildCreateButtonCTA(),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─────────────────────────────────────────
  // 1. Grouped Information Card
  // ─────────────────────────────────────────
  Widget _buildGroupedInfoCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE2E8F0), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Activity row
          _formItemRow(
            label: 'Activity',
            value: _sportTitle,
            iconWidget: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: const Color(0xFFEEF4FF),
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.all(6),
              child: Image.asset(_sportIcon, fit: BoxFit.contain),
            ),
            onTap: _openSelectActivity,
          ),
          const Divider(color: Color(0xFFF1F5F9), height: 1),

          // Where row
          _formItemRow(
            label: 'Where?',
            value: _venueName,
            iconWidget: const Icon(
              Icons.location_on_outlined,
              size: 22,
              color: AppColors.primary,
            ),
            onTap: _openSelectLocation,
          ),
          const Divider(color: Color(0xFFF1F5F9), height: 1),

          // Date row
          _formItemRow(
            label: 'Date',
            value: _dateFormatted,
            iconWidget: const Icon(
              Icons.calendar_today_outlined,
              size: 20,
              color: AppColors.primary,
            ),
            onTap: _openDatePicker,
          ),
          const Divider(color: Color(0xFFF1F5F9), height: 1),

          // Time row
          _formItemRow(
            label: 'Time',
            value: _timeFormatted,
            iconWidget: const Icon(
              Icons.access_time_rounded,
              size: 20,
              color: AppColors.primary,
            ),
            onTap: _openTimePicker,
          ),
          const SizedBox(height: 6),

          // Estimated duration helper
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 4),
            child: Text(
              'Estimated duration · 1 hour',
              style: TextStyle(
                fontSize: 12,
                color: Color(0xFF94A3B8),
              ),
            ),
          ),
          const SizedBox(height: 4),
        ],
      ),
    );
  }

  Widget _formItemRow({
    required String label,
    required String value,
    required Widget iconWidget,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: label,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF64748B),
                          ),
                        ),
                        const TextSpan(
                          text: ' *',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFFEA580C),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 15.5,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textDark,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            iconWidget,
            const SizedBox(width: 8),
            const Icon(
              Icons.chevron_right_rounded,
              color: Color(0xFFCBD5E1),
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  // ─────────────────────────────────────────
  // 2. Players Needed Card
  // ─────────────────────────────────────────
  Widget _buildPlayersNeededCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE2E8F0), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              RichText(
                text: const TextSpan(
                  children: [
                    TextSpan(
                      text: 'Players needed',
                      style: TextStyle(
                        fontSize: 14.5,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textDark,
                      ),
                    ),
                    TextSpan(
                      text: ' *',
                      style: TextStyle(
                        fontSize: 14.5,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFFEA580C),
                      ),
                    ),
                  ],
                ),
              ),

              // Counter (-  count  +)
              Row(
                children: [
                  GestureDetector(
                    onTap: _playersNeeded > 2
                        ? () {
                            setState(() {
                              _playersNeeded--;
                            });
                          }
                        : null,
                    child: Container(
                      width: 34,
                      height: 34,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: _playersNeeded > 2
                              ? AppColors.primary
                              : const Color(0xFFCBD5E1),
                          width: 1.5,
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Icon(
                        Icons.remove,
                        size: 16,
                        color: _playersNeeded > 2
                            ? AppColors.primary
                            : const Color(0xFFCBD5E1),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    '$_playersNeeded',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textDark,
                    ),
                  ),
                  const SizedBox(width: 16),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _playersNeeded++;
                      });
                    },
                    child: Container(
                      width: 34,
                      height: 34,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.primary,
                      ),
                      alignment: Alignment.center,
                      child: const Icon(
                        Icons.add,
                        size: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 6),
          const Text(
            'How many people can join?',
            style: TextStyle(
              fontSize: 12.5,
              color: Color(0xFF64748B),
            ),
          ),
          const SizedBox(height: 2),
          const Text(
            'Minimum players · 4',
            style: TextStyle(
              fontSize: 11.5,
              color: Color(0xFF94A3B8),
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────
  // 3. Skill Level Section
  // ─────────────────────────────────────────
  Widget _buildSkillLevelSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'SKILL LEVEL',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.6,
            color: Color(0xFF64748B),
          ),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _skillLevels.map((skill) {
            final bool isSelected = _selectedSkillLevel == skill;
            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedSkillLevel = skill;
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primary : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected
                        ? AppColors.primary
                        : const Color(0xFFE2E8F0),
                    width: 1.2,
                  ),
                ),
                child: Text(
                  skill.label,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                    color: isSelected ? Colors.white : AppColors.textDark,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  // ─────────────────────────────────────────
  // 4. Cost Per Person Card
  // ─────────────────────────────────────────
  Widget _buildCostCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE2E8F0), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'COST PER PERSON',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.6,
              color: Color(0xFF64748B),
            ),
          ),
          const SizedBox(height: 12),

          // Chips Row: Free, ₹60, ₹100, ₹150, Custom
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            child: Row(
              children: [
                ..._costOptions.map((cost) {
                  final bool isSelected = _selectedCost == cost;
                  final label = cost == 0 ? 'Free' : '₹$cost';
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedCost = cost;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 7,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected ? AppColors.primary : Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isSelected
                                ? AppColors.primary
                                : const Color(0xFFE2E8F0),
                          ),
                        ),
                        child: Text(
                          label,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight:
                                isSelected ? FontWeight.w700 : FontWeight.w600,
                            color: isSelected ? Colors.white : AppColors.textDark,
                          ),
                        ),
                      ),
                    ),
                  );
                }),

                // Custom option
                GestureDetector(
                  onTap: () async {
                    final controller = TextEditingController();
                    final customVal = await showDialog<int>(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: const Text('Enter Custom Cost'),
                        content: TextField(
                          controller: controller,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            prefixText: '₹ ',
                            hintText: 'e.g. 200',
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(ctx).pop(),
                            child: const Text('Cancel'),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              final parsed = int.tryParse(controller.text.trim());
                              Navigator.of(ctx).pop(parsed);
                            },
                            child: const Text('OK'),
                          ),
                        ],
                      ),
                    );
                    if (customVal != null && customVal >= 0) {
                      setState(() {
                        _selectedCost = customVal;
                      });
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 7,
                    ),
                    decoration: BoxDecoration(
                      color: !_costOptions.contains(_selectedCost)
                          ? AppColors.primary
                          : Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: !_costOptions.contains(_selectedCost)
                            ? AppColors.primary
                            : const Color(0xFFE2E8F0),
                      ),
                    ),
                    child: Text(
                      !_costOptions.contains(_selectedCost)
                          ? '₹$_selectedCost'
                          : 'Custom',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: !_costOptions.contains(_selectedCost)
                            ? Colors.white
                            : AppColors.textDark,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          const Divider(color: Color(0xFFF1F5F9), height: 1),
          const SizedBox(height: 12),

          // Split cost Switch Row
          Row(
            children: [
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Split cost',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textDark,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Split venue cost between players',
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
              ),
              Switch(
                value: _splitCost,
                activeThumbColor: AppColors.primary,
                onChanged: (val) {
                  setState(() {
                    _splitCost = val;
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────
  // 5. Who Can Join Card
  // ─────────────────────────────────────────
  Widget _buildWhoCanJoinCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE2E8F0), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'WHO CAN JOIN?',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.6,
              color: Color(0xFF64748B),
            ),
          ),
          const SizedBox(height: 12),

          // Segmented selector container
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(14),
            ),
            padding: const EdgeInsets.all(4),
            child: Row(
              children: _joinOptions.map((opt) {
                final bool isSelected = _whoCanJoin == opt;
                return Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _whoCanJoin = opt;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 9),
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.white : Colors.transparent,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.06),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ]
                            : null,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        opt,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight:
                              isSelected ? FontWeight.w700 : FontWeight.w500,
                          color: isSelected
                              ? AppColors.primary
                              : const Color(0xFF64748B),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 12),

          // Info message
          const Row(
            children: [
              Icon(
                Icons.info_outline_rounded,
                size: 15,
                color: Color(0xFF94A3B8),
              ),
              SizedBox(width: 6),
              Text(
                'Anyone nearby can discover and join',
                style: TextStyle(
                  fontSize: 12,
                  color: Color(0xFF94A3B8),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────
  // 6. Add a Note Section
  // ─────────────────────────────────────────
  Widget _buildNoteSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'ADD A NOTE (OPTIONAL)',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.6,
            color: Color(0xFF64748B),
          ),
        ),
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE2E8F0), width: 1.2),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          child: TextField(
            controller: _noteController,
            maxLines: 3,
            minLines: 2,
            style: const TextStyle(
              fontSize: 13.5,
              color: AppColors.textDark,
              height: 1.4,
            ),
            decoration: const InputDecoration(
              hintText: 'Add note for participants...',
              hintStyle: TextStyle(
                fontSize: 13,
                color: Color(0xFF94A3B8),
              ),
              border: InputBorder.none,
              isDense: true,
            ),
          ),
        ),
      ],
    );
  }

  // ─────────────────────────────────────────
  // 7. Group Chat Card
  // ─────────────────────────────────────────
  Widget _buildGroupChatCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE2E8F0), width: 1.2),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Create a group chat',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textDark,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Chat with players before the activity',
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFF64748B),
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: _createGroupChat,
            activeThumbColor: AppColors.primary,
            onChanged: (val) {
              setState(() {
                _createGroupChat = val;
              });
            },
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────
  // 8. Create Button CTA
  // ─────────────────────────────────────────
  Widget _buildCreateButtonCTA() {
    return Column(
      children: [
        GestureDetector(
          onTap: _createActivity,
          child: Container(
            width: double.infinity,
            height: 52,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            alignment: Alignment.center,
            child: const Text(
              'Create Activity',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Colors.white,
                letterSpacing: 0.2,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'You can edit the details later.',
          style: TextStyle(
            fontSize: 12,
            color: Color(0xFF94A3B8),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
