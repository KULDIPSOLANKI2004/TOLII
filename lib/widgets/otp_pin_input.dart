import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/app_colors.dart';
import '../constants/app_typography.dart';

class OtpPinInput extends StatefulWidget {
  final int length;
  final ValueChanged<String> onCompleted;
  final ValueChanged<String>? onChanged;
  final String? errorText;

  const OtpPinInput({
    super.key,
    this.length = 6,
    required this.onCompleted,
    this.onChanged,
    this.errorText,
  });

  @override
  State<OtpPinInput> createState() => _OtpPinInputState();
}

class _OtpPinInputState extends State<OtpPinInput> {
  late List<TextEditingController> _controllers;
  late List<FocusNode> _focusNodes;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(
      widget.length,
      (index) => TextEditingController(),
    );
    _focusNodes = List.generate(
      widget.length,
      (index) => FocusNode(),
    );
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  String _getOtp() {
    return _controllers.map((c) => c.text).join();
  }

  void _onDigitChanged(int index, String value) {
    if (value.length > 1) {
      // Handles copy-pasting code into first box
      final digits = value.replaceAll(RegExp(r'\D'), '');
      for (int i = 0; i < widget.length && i < digits.length; i++) {
        _controllers[i].text = digits[i];
      }
      final nextIndex = (digits.length < widget.length) ? digits.length : widget.length - 1;
      _focusNodes[nextIndex].requestFocus();
    } else if (value.isNotEmpty) {
      if (index < widget.length - 1) {
        _focusNodes[index + 1].requestFocus();
      } else {
        _focusNodes[index].unfocus();
      }
    }

    final otp = _getOtp();
    widget.onChanged?.call(otp);
    if (otp.length == widget.length) {
      widget.onCompleted(otp);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool hasError = widget.errorText != null && widget.errorText!.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(widget.length, (index) {
            return Expanded(
              child: Container(
                margin: EdgeInsets.symmetric(
                  horizontal: widget.length > 5 ? 3 : 4,
                ),
                height: 52,
                child: KeyboardListener(
                  focusNode: FocusNode(),
                  onKeyEvent: (event) {
                    if (event is KeyDownEvent &&
                        event.logicalKey == LogicalKeyboardKey.backspace &&
                        _controllers[index].text.isEmpty &&
                        index > 0) {
                      _focusNodes[index - 1].requestFocus();
                      _controllers[index - 1].clear();
                      widget.onChanged?.call(_getOtp());
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.inputFill,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: hasError
                            ? AppColors.borderError
                            : _focusNodes[index].hasFocus
                                ? AppColors.borderFocus
                                : AppColors.borderLight,
                        width: hasError || _focusNodes[index].hasFocus ? 1.4 : 1.0,
                      ),
                    ),
                    child: Center(
                      child: TextField(
                        controller: _controllers[index],
                        focusNode: _focusNodes[index],
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        maxLength: 1,
                        style: AppTypography.otpDigit.copyWith(
                          fontSize: 18,
                        ),
                        cursorColor: AppColors.primary,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        decoration: const InputDecoration(
                          counterText: '',
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.zero,
                        ),
                        onChanged: (value) => _onDigitChanged(index, value),
                      ),
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
        if (hasError) ...[
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(
                Icons.error_outline_rounded,
                size: 14,
                color: AppColors.errorRed,
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  widget.errorText!,
                  style: AppTypography.errorText,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}
