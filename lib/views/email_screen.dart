import 'package:flutter/material.dart';
import '../constants/app_assets.dart';
import '../constants/app_colors.dart';
import '../constants/app_typography.dart';
import '../controllers/auth_controller.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/tolii_logo.dart';
import 'otp_screen.dart';

class EmailScreen extends StatefulWidget {
  const EmailScreen({super.key});

  @override
  State<EmailScreen> createState() => _EmailScreenState();
}

class _EmailScreenState extends State<EmailScreen> {
  late final AuthController _authController;
  late final TextEditingController _emailTextController;

  @override
  void initState() {
    super.initState();
    _authController = AuthController();
    _emailTextController = TextEditingController();
  }

  @override
  void dispose() {
    _authController.dispose();
    _emailTextController.dispose();
    super.dispose();
  }

  Future<void> _handleSendOtp() async {
    FocusScope.of(context).unfocus();

    final success = await _authController.sendOtp();
    if (success && mounted) {
      Navigator.of(context).push(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => OtpScreen(
            authController: _authController,
          ),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            final curvedAnimation = CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutCubic,
            );
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(1.0, 0.0),
                end: Offset.zero,
              ).animate(curvedAnimation),
              child: child,
            );
          },
          transitionDuration: const Duration(milliseconds: 300),
        ),
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
                        animation: _authController,
                        builder: (context, child) {
                          final state = _authController.state;

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
                            padding: const EdgeInsets.fromLTRB(24, 24, 24, 28),
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
                                  const SizedBox(height: 18),

                                  // Email Input Field with inline validation
                                  CustomTextField(
                                    label: 'Enter Email',
                                    hintText: '',
                                    controller: _emailTextController,
                                    keyboardType: TextInputType.emailAddress,
                                    textInputAction: TextInputAction.done,
                                    errorText: state.emailError,
                                    onChanged: (value) {
                                      _authController.state.email = value;
                                      if (state.emailError != null) {
                                        _authController.clearEmailError();
                                      }
                                    },
                                    onSubmitted: (_) => _handleSendOtp(),
                                  ),
                                  const SizedBox(height: 16),

                                  // Send OTP Button
                                  CustomButton(
                                    text: 'Send OTP',
                                    isLoading: state.isLoading,
                                    onPressed: _handleSendOtp,
                                  ),
                                  const SizedBox(height: 16),

                                  // WhatsApp Checkbox
                                  GestureDetector(
                                    onTap: _authController.toggleWhatsappOptIn,
                                    behavior: HitTestBehavior.opaque,
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 18,
                                          height: 18,
                                          decoration: BoxDecoration(
                                            color: state.isWhatsappOptedIn
                                                ? AppColors.successGreen
                                                : Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(4),
                                            border: Border.all(
                                              color: state.isWhatsappOptedIn
                                                  ? AppColors.successGreen
                                                  : AppColors.borderLight,
                                              width: 1.5,
                                            ),
                                          ),
                                          child: state.isWhatsappOptedIn
                                              ? const Icon(
                                                  Icons.check,
                                                  size: 14,
                                                  color: Colors.white,
                                                )
                                              : null,
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            'I agree to receive updates over whatsapp',
                                            style:
                                                AppTypography.caption.copyWith(
                                              color: AppColors.textPrimary,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 16),

                                  // Terms & Privacy Notice
                                  Center(
                                    child: Text(
                                      'By signing up, you agree to the\nTerms Of Service and Privacy Policy',
                                      textAlign: TextAlign.center,
                                      style: AppTypography.caption.copyWith(
                                        color: AppColors.textSecondary,
                                        height: 1.3,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 20),

                                  // "Or" Divider
                                  Row(
                                    children: [
                                      const Expanded(
                                        child: Divider(
                                          color: AppColors.borderLight,
                                          thickness: 1,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16),
                                        child: Text(
                                          'Or',
                                          style: AppTypography.caption.copyWith(
                                            color: AppColors.textSecondary,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                      const Expanded(
                                        child: Divider(
                                          color: AppColors.borderLight,
                                          thickness: 1,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 20),

                                  // Social Login Icons (Email & Google)
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      _SocialAuthButton(
                                        imageAsset: AppAssets.gmailLogoPng,
                                        onTap: () {
                                          // Social sign in action
                                        },
                                      ),
                                      const SizedBox(width: 32),
                                      _SocialAuthButton(
                                        imageAsset: AppAssets.googleLogoPng,
                                        onTap: () {
                                          // Google sign in action
                                        },
                                      ),
                                    ],
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

class _SocialAuthButton extends StatelessWidget {
  final String imageAsset;
  final VoidCallback onTap;

  const _SocialAuthButton({
    required this.imageAsset,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          border: Border.all(
            color: AppColors.borderLight,
            width: 1.2,
          ),
          boxShadow: const [
            BoxShadow(
              color: Color(0x08000000),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        padding: const EdgeInsets.all(12),
        child: Image.asset(
          imageAsset,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
