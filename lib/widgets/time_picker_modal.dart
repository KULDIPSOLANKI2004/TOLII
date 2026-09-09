import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class TimePickerModal extends StatefulWidget {
  final int initialHour;
  final int initialMinute;
  final bool initialIsPm;

  const TimePickerModal({
    super.key,
    this.initialHour = 6,
    this.initialMinute = 30,
    this.initialIsPm = true,
  });

  @override
  State<TimePickerModal> createState() => _TimePickerModalState();
}

class _TimePickerModalState extends State<TimePickerModal> {
  late int _hour;
  late int _minute;
  late bool _isPm;

  @override
  void initState() {
    super.initState();
    _hour = widget.initialHour;
    _minute = widget.initialMinute;
    _isPm = widget.initialIsPm;
  }

  void _incrementHour() {
    setState(() {
      _hour = _hour >= 12 ? 1 : _hour + 1;
    });
  }

  void _decrementHour() {
    setState(() {
      _hour = _hour <= 1 ? 12 : _hour - 1;
    });
  }

  void _incrementMinute() {
    setState(() {
      _minute = (_minute + 5) % 60;
    });
  }

  void _decrementMinute() {
    setState(() {
      _minute = (_minute - 5 + 60) % 60;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header Row
            Row(
              children: [
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
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
                  child: Text(
                    'Select Time',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textDark,
                    ),
                  ),
                ),
                const SizedBox(width: 36),
              ],
            ),
            const SizedBox(height: 28),

            // Hour & Minute Spinner controls
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Hour Column
                _spinnerColumn(
                  value: '$_hour',
                  label: 'hour',
                  onUp: _incrementHour,
                  onDown: _decrementHour,
                ),
                const SizedBox(width: 32),

                // Minute Column
                _spinnerColumn(
                  value: _minute.toString().padLeft(2, '0'),
                  label: 'min',
                  onUp: _incrementMinute,
                  onDown: _decrementMinute,
                ),
              ],
            ),
            const SizedBox(height: 28),

            // AM / PM Toggle Row
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(16),
              ),
              padding: const EdgeInsets.all(4),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _isPm = false;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: !_isPm ? AppColors.primary : Colors.transparent,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          'AM',
                          style: TextStyle(
                            fontSize: 14.5,
                            fontWeight: FontWeight.w700,
                            color: !_isPm ? Colors.white : const Color(0xFF64748B),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _isPm = true;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: _isPm ? AppColors.primary : Colors.transparent,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          'PM',
                          style: TextStyle(
                            fontSize: 14.5,
                            fontWeight: FontWeight.w700,
                            color: _isPm ? Colors.white : const Color(0xFF64748B),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Confirm Button
            GestureDetector(
              onTap: () {
                final minuteStr = _minute.toString().padLeft(2, '0');
                final period = _isPm ? 'PM' : 'AM';
                final formatted = '$_hour:$minuteStr $period';
                Navigator.of(context).pop({
                  'hour': _hour,
                  'minute': _minute,
                  'isPm': _isPm,
                  'formatted': formatted,
                });
              },
              child: Container(
                width: double.infinity,
                height: 50,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                alignment: Alignment.center,
                child: const Text(
                  'Confirm',
                  style: TextStyle(
                    fontSize: 15.5,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 4),
          ],
        ),
      ),
    );
  }

  Widget _spinnerColumn({
    required String value,
    required String label,
    required VoidCallback onUp,
    required VoidCallback onDown,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Up arrow button
        GestureDetector(
          onTap: onUp,
          child: Container(
            width: 44,
            height: 38,
            decoration: BoxDecoration(
              color: const Color(0xFFEEF4FF),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFDBEAFE)),
            ),
            alignment: Alignment.center,
            child: const Icon(
              Icons.keyboard_arrow_up_rounded,
              size: 24,
              color: AppColors.primary,
            ),
          ),
        ),
        const SizedBox(height: 10),

        // Value text
        Text(
          value,
          style: const TextStyle(
            fontSize: 38,
            fontWeight: FontWeight.w800,
            color: AppColors.textDark,
            height: 1.1,
          ),
        ),
        const SizedBox(height: 2),

        // Caption label (hour/min)
        Text(
          label,
          style: const TextStyle(
            fontSize: 12.5,
            fontWeight: FontWeight.w500,
            color: Color(0xFF94A3B8),
          ),
        ),
        const SizedBox(height: 10),

        // Down arrow button
        GestureDetector(
          onTap: onDown,
          child: Container(
            width: 44,
            height: 38,
            decoration: BoxDecoration(
              color: const Color(0xFFEEF4FF),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFDBEAFE)),
            ),
            alignment: Alignment.center,
            child: const Icon(
              Icons.keyboard_arrow_down_rounded,
              size: 24,
              color: AppColors.primary,
            ),
          ),
        ),
      ],
    );
  }
}
