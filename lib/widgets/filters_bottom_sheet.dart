import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_typography.dart';

class FiltersBottomSheet extends StatefulWidget {
  const FiltersBottomSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const FiltersBottomSheet(),
    );
  }

  @override
  State<FiltersBottomSheet> createState() => _FiltersBottomSheetState();
}

class _FiltersBottomSheetState extends State<FiltersBottomSheet> {
  String _selectedActivity = 'All';
  String _selectedWhen = 'Today';
  String _selectedTime = 'Any Time';
  double _distanceKm = 2.0;
  String _selectedSkill = 'Any Level';
  String _selectedPlayers = 'Any';
  String _selectedPrice = 'Free';

  final List<String> _activities = [
    'All',
    'Sports',
    'Fitness',
    'Social',
    'Gaming',
    'Food & Café',
    'Other',
  ];

  final List<String> _whenOptions = [
    'Today',
    'Tomorrow',
    'This Weekend',
    'Choose Date',
  ];

  final List<String> _timeOptions = [
    'Any Time',
    'Morning',
    'Afternoon',
    'Evening',
    'Night',
  ];

  final List<String> _skillLevels = [
    'Any Level',
    'Beginner',
    'Intermediate',
    'Advanced',
  ];

  final List<String> _playersOptions = [
    'Any',
    '1–2 spots',
    '3–5 spots',
    '6+ spots',
  ];

  final List<String> _priceOptions = [
    'Free',
    '₹1–100',
    '₹100–250',
    '₹250+',
  ];

  void _clearAll() {
    setState(() {
      _selectedActivity = 'All';
      _selectedWhen = 'Today';
      _selectedTime = 'Any Time';
      _distanceKm = 2.0;
      _selectedSkill = 'Any Level';
      _selectedPlayers = 'Any';
      _selectedPrice = 'Free';
    });
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final maxHeight = mediaQuery.size.height * 0.90;

    return Container(
      constraints: BoxConstraints(maxHeight: maxHeight),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(28),
          topRight: Radius.circular(28),
        ),
      ),
      child: SafeArea(
        bottom: true,
        child: Column(
          children: [
            // Top Header
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: InkWell(
                      onTap: () => Navigator.of(context).pop(),
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: const Color(0xFFE5E7EB),
                            width: 1.2,
                          ),
                        ),
                        child: const Icon(
                          Icons.arrow_back_ios_new_rounded,
                          size: 16,
                          color: AppColors.textDark,
                        ),
                      ),
                    ),
                  ),
                  Text(
                    'Filters',
                    style: AppTypography.headline.copyWith(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textDark,
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1, color: Color(0xFFF1F5F9)),

            // Scrollable Filters Body
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 1. Activity Section
                    _buildSectionTitle('Activity'),
                    const SizedBox(height: 10),
                    _buildChipGroup(
                      options: _activities,
                      selected: _selectedActivity,
                      onSelect: (val) => setState(() => _selectedActivity = val),
                    ),
                    const SizedBox(height: 24),

                    // 2. When Section
                    _buildSectionTitle('When'),
                    const SizedBox(height: 10),
                    _buildChipGroup(
                      options: _whenOptions,
                      selected: _selectedWhen,
                      hasCalendarIcon: true,
                      onSelect: (val) async {
                        if (val == 'Choose Date') {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime.now().add(const Duration(days: 90)),
                          );
                          if (picked != null) {
                            setState(() => _selectedWhen = 'Choose Date');
                          }
                        } else {
                          setState(() => _selectedWhen = val);
                        }
                      },
                    ),
                    const SizedBox(height: 24),

                    // 3. Time Section
                    _buildSectionTitle('Time'),
                    const SizedBox(height: 10),
                    _buildChipGroup(
                      options: _timeOptions,
                      selected: _selectedTime,
                      onSelect: (val) => setState(() => _selectedTime = val),
                    ),
                    const SizedBox(height: 24),

                    // 4. Distance Section
                    _buildSectionTitle('Distance'),
                    const SizedBox(height: 6),
                    SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        trackHeight: 3.5,
                        activeTrackColor: AppColors.primary,
                        inactiveTrackColor: const Color(0xFFE2E8F0),
                        thumbColor: AppColors.primary,
                        thumbShape: const RoundSliderThumbShape(
                          enabledThumbRadius: 9,
                        ),
                        overlayColor: AppColors.primary.withValues(alpha: 0.15),
                        overlayShape: const RoundSliderOverlayShape(
                          overlayRadius: 18,
                        ),
                      ),
                      child: Slider(
                        value: _distanceKm,
                        min: 1.0,
                        max: 25.0,
                        onChanged: (val) => setState(() => _distanceKm = val),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Within ${_distanceKm.round()} km',
                            style: AppTypography.caption.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w700,
                              fontSize: 12.5,
                            ),
                          ),
                          Text(
                            '25 km',
                            style: AppTypography.caption.copyWith(
                              color: AppColors.textSecondary,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // 5. Skill Level Section
                    _buildSectionTitle('Skill Level'),
                    const SizedBox(height: 10),
                    _buildChipGroup(
                      options: _skillLevels,
                      selected: _selectedSkill,
                      onSelect: (val) => setState(() => _selectedSkill = val),
                    ),
                    const SizedBox(height: 24),

                    // 6. Players Needed Section
                    _buildSectionTitle('Players Needed'),
                    const SizedBox(height: 10),
                    _buildChipGroup(
                      options: _playersOptions,
                      selected: _selectedPlayers,
                      onSelect: (val) => setState(() => _selectedPlayers = val),
                    ),
                    const SizedBox(height: 24),

                    // 7. Price Section
                    _buildSectionTitle('Price'),
                    const SizedBox(height: 10),
                    _buildChipGroup(
                      options: _priceOptions,
                      selected: _selectedPrice,
                      onSelect: (val) => setState(() => _selectedPrice = val),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),

            // Bottom Buttons Bar
            Container(
              padding: const EdgeInsets.fromLTRB(20, 14, 20, 16),
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(
                  top: BorderSide(
                    color: Color(0xFFF1F5F9),
                    width: 1.0,
                  ),
                ),
              ),
              child: Row(
                children: [
                  // Clear All Button
                  TextButton(
                    onPressed: _clearAll,
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                    child: Text(
                      'Clear all',
                      style: AppTypography.buttonText.copyWith(
                        color: AppColors.primary,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),

                  // Apply Button
                  Expanded(
                    child: SizedBox(
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: Text(
                          'Apply',
                          style: AppTypography.buttonText.copyWith(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
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

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: AppTypography.titleMedium.copyWith(
        fontSize: 15.5,
        fontWeight: FontWeight.w700,
        color: AppColors.textDark,
      ),
    );
  }

  Widget _buildChipGroup({
    required List<String> options,
    required String selected,
    required ValueChanged<String> onSelect,
    bool hasCalendarIcon = false,
  }) {
    return Wrap(
      spacing: 8,
      runSpacing: 10,
      children: options.map((option) {
        final isSelected = selected == option;
        final isCalendar = hasCalendarIcon && option == 'Choose Date';

        return GestureDetector(
          onTap: () => onSelect(option),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.primary : Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isSelected
                    ? AppColors.primary
                    : const Color(0xFFE2E8F0),
                width: 1.2,
              ),
              boxShadow: isSelected
                  ? const [
                      BoxShadow(
                        color: Color(0x25063E9E),
                        blurRadius: 6,
                        offset: Offset(0, 2),
                      ),
                    ]
                  : null,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (isCalendar) ...[
                  Icon(
                    Icons.calendar_today_rounded,
                    size: 14,
                    color: isSelected ? Colors.white : AppColors.primary,
                  ),
                  const SizedBox(width: 6),
                ],
                Text(
                  option,
                  style: AppTypography.caption.copyWith(
                    fontSize: 13,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    color: isSelected ? Colors.white : AppColors.textDark,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
