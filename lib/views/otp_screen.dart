import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_typography.dart';
import '../controllers/auth_controller.dart';
import '../widgets/custom_button.dart';
import '../widgets/otp_pin_input.dart';
import '../widgets/tolii_logo.dart';
import 'home_screen.dart';

class OtpScreen extends StatefulWidget {
  final AuthController authController;

  const OtpScreen({
    super.key,
    required this.authController,
  });

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  late AuthController _controller;

  @override
  void initState() {
    super.initState();
    _controller = widget.authController;
  }

  Future<void> _handleVerify() async {
    FocusScope.of(context).unfocus();

    final success = await _controller.verifyOtp();
    if (success && mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              const HomeScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            final curvedAnimation = CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutCubic,
            );
            return FadeTransition(
              opacity: curvedAnimation,
              child: child,
            );
          },
          transitionDuration: const Duration(milliseconds: 350),
        ),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Column(
                    children: [
                      // Top Section with Tolii Logo
                      Expanded(
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 32,
                            ),
                            child: const ToliiLogo(width: 170),
                          ),
                        ),
                      ),

                      // Bottom White Card
                      AnimatedBuilder(
                        animation: _controller,
                        builder: (context, child) {
                          final state = _controller.state;

                          return Container(
                            width: double.infinity,
                            decoration: const BoxDecoration(
                              color: AppColors.cardSurface,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(28),
                                topRight: Radius.circular(28),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Color(0x0F000000),
                                  blurRadius: 20,
                                  offset: Offset(0, -4),
                                ),
                              ],
                            ),
                            padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
                            child: SafeArea(
                              top: false,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Header: "You're Almost There!" + Close button
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "You're Almost There!",
                                        style:
                                            AppTypography.titleLarge.copyWith(
                                          fontSize: 18,
                                        ),
                                      ),
                                      IconButton(
                                        icon: const Icon(
                                          Icons.cancel_outlined,
                                          color: AppColors.textSecondary,
                                          size: 24,
                                        ),
                                        onPressed: () {
                                          Navigator.of(context).maybePop();
                                        },
                                        padding: EdgeInsets.zero,
                                        constraints: const BoxConstraints(),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 20),

                                  // Subhead Row: "Enter OTP" on Left & Phone/Email on Right
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Enter OTP',
                                        style:
                                            AppTypography.inputLabel.copyWith(
                                          fontSize: 13,
                                        ),
                                      ),
                                      Text(
                                        state.phoneNumber.isNotEmpty
                                            ? state.phoneNumber
                                            : state.email,
                                        style: AppTypography.caption.copyWith(
                                          color: AppColors.textSecondary,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),

                                  // 5-Digit OTP Boxes with inline error
                                  OtpPinInput(
                                    length: 5,
                                    errorText: state.otpError,
                                    onChanged: (otp) {
                                      _controller.updateOtp(otp);
                                    },
                                    onCompleted: (otp) {
                                      _controller.updateOtp(otp);
                                    },
                                  ),
                                  const SizedBox(height: 20),

                                  // Verify Button
                                  CustomButton(
                                    text: 'Verify',
                                    isLoading: state.isLoading,
                                    onPressed: _handleVerify,
                                  ),
                                  const SizedBox(height: 16),

                                  // Resend OTP Countdown / Action Text
                                  Center(
                                    child: _controller.canResend
                                        ? GestureDetector(
                                            onTap: () =>
                                                _controller.resendOtp(),
                                            child: Text(
                                              'Resend OTP',
                                              style: AppTypography.caption
                                                  .copyWith(
                                                color: AppColors.primary,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 12,
                                              ),
                                            ),
                                          )
                                        : Text(
                                            'Resend OTP in ${_controller.formattedCountdown}',
                                            style:
                                                AppTypography.caption.copyWith(
                                              color: AppColors.textSecondary,
                                              fontSize: 12,
                                            ),
                                          ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
