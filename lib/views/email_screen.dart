import 'package:flutter/material.dart';
import '../constants/app_assets.dart';
import '../constants/app_colors.dart';
import '../constants/app_typography.dart';
import '../controllers/auth_controller.dart';
import '../widgets/auth_step_progress.dart';
import '../widgets/custom_button.dart';
import 'otp_screen.dart';

class EmailScreen extends StatefulWidget {
  final AuthController? authController;

  const EmailScreen({
    super.key,
    this.authController,
  });

  @override
  State<EmailScreen> createState() => _EmailScreenState();
}

class _EmailScreenState extends State<EmailScreen> {
  late final AuthController _authController;
  late final TextEditingController _textController;
  bool _isLocalController = false;

  @override
  void initState() {
    super.initState();
    if (widget.authController != null) {
      _authController = widget.authController!;
    } else {
      _authController = AuthController();
      _isLocalController = true;
    }
    _textController = TextEditingController(
      text: _authController.state.authMode == 'email'
          ? _authController.state.email
          : _authController.state.rawPhoneNumber,
    );
  }

  @override
  void dispose() {
    if (_isLocalController) {
      _authController.dispose();
    }
    _textController.dispose();
    super.dispose();
  }

  Future<void> _handleSendOtp() async {
    FocusScope.of(context).unfocus();

    final mode = _authController.state.authMode;
    if (mode == 'email') {
      if (!_authController.validateEmail(_textController.text)) {
        return;
      }
    } else {
      if (!_authController.validatePhone(_textController.text)) {
        return;
      }
    }

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

  void _switchAuthMode(String newMode) {
    _authController.setAuthMode(newMode);
    _textController.text = newMode == 'email'
        ? _authController.state.email
        : _authController.state.rawPhoneNumber;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        bottom: false,
        child: LayoutBuilder(
          builder: (context, constraints) {
            return AnimatedBuilder(
              animation: _authController,
              builder: (context, child) {
                final state = _authController.state;
                final isPhoneMode = state.authMode == 'phone';

                return SingleChildScrollView(
                  physics: const ClampingScrollPhysics(),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minHeight: constraints.maxHeight),
                    child: IntrinsicHeight(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Top 1 of 5 Header Section
                          Padding(
                            padding: const EdgeInsets.fromLTRB(24, 20, 24, 20),
                            child: AuthStepProgress(
                              currentStep: 1,
                              totalSteps: 5,
                              title: "Let's get you started",
                              subtitle: isPhoneMode
                                  ? 'Enter your phone number to join activities and meet people nearby.'
                                  : 'Enter your email to join activities and meet people nearby.',
                            ),
                          ),

                          const Spacer(),

                          // Bottom Card Sheet
                          Container(
                            width: double.infinity,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(28),
                                topRight: Radius.circular(28),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Color(0x14000000),
                                  blurRadius: 24,
                                  offset: Offset(0, -6),
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
                                          fontWeight: FontWeight.w700,
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

                                  // Input Field (Mobile Number or Email)
                                  if (isPhoneMode) ...[
                                    Text(
                                      'Enter Mobile Number',
                                      style: AppTypography.inputLabel.copyWith(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Container(
                                      height: 48,
                                      decoration: BoxDecoration(
                                        color: AppColors.inputFill,
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                          color: state.phoneError != null
                                              ? AppColors.borderError
                                              : AppColors.borderLight,
                                          width: state.phoneError != null
                                              ? 1.4
                                              : 1.0,
                                        ),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 14),
                                      child: Row(
                                        children: [
                                          Text(
                                            '+91  |',
                                            style: AppTypography.inputText
                                                .copyWith(
                                              color: AppColors.textPrimary,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          const SizedBox(width: 10),
                                          Expanded(
                                            child: TextField(
                                              controller: _textController,
                                              keyboardType: TextInputType.phone,
                                              textInputAction:
                                                  TextInputAction.done,
                                              style: AppTypography.inputText,
                                              decoration:
                                                  const InputDecoration(
                                                hintText: '98765 43210',
                                                hintStyle: TextStyle(
                                                  color: AppColors.textTertiary,
                                                  fontSize: 15,
                                                ),
                                                border: InputBorder.none,
                                                isDense: true,
                                                contentPadding: EdgeInsets.zero,
                                              ),
                                              onChanged: (value) {
                                                state.rawPhoneNumber = value;
                                                state.phoneNumber =
                                                    '+91 $value';
                                                _authController
                                                    .clearPhoneError();
                                              },
                                              onSubmitted: (_) =>
                                                  _handleSendOtp(),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    if (state.phoneError != null) ...[
                                      const SizedBox(height: 6),
                                      Text(
                                        state.phoneError!,
                                        style: AppTypography.errorText,
                                      ),
                                    ],
                                  ] else ...[
                                    Text(
                                      'Enter Email',
                                      style: AppTypography.inputLabel.copyWith(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Container(
                                      height: 48,
                                      decoration: BoxDecoration(
                                        color: AppColors.inputFill,
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                          color: state.emailError != null
                                              ? AppColors.borderError
                                              : AppColors.borderLight,
                                          width: state.emailError != null
                                              ? 1.4
                                              : 1.0,
                                        ),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 14),
                                      child: TextField(
                                        controller: _textController,
                                        keyboardType:
                                            TextInputType.emailAddress,
                                        textInputAction: TextInputAction.done,
                                        style: AppTypography.inputText,
                                        decoration: const InputDecoration(
                                          hintText: 'yourname@gmail.com',
                                          hintStyle: TextStyle(
                                            color: AppColors.textTertiary,
                                            fontSize: 15,
                                          ),
                                          border: InputBorder.none,
                                          isDense: true,
                                          contentPadding: EdgeInsets.symmetric(
                                              vertical: 12),
                                        ),
                                        onChanged: (value) {
                                          state.email = value;
                                          _authController.clearEmailError();
                                        },
                                        onSubmitted: (_) => _handleSendOtp(),
                                      ),
                                    ),
                                    if (state.emailError != null) ...[
                                      const SizedBox(height: 6),
                                      Text(
                                        state.emailError!,
                                        style: AppTypography.errorText,
                                      ),
                                    ],
                                  ],
                                  const SizedBox(height: 18),

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
                                              fontWeight: FontWeight.w400,
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
                                          style:
                                              AppTypography.caption.copyWith(
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

                                  // Social Login Icons (Email / Phone Mode Switcher & Google)
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.center,
                                    children: [
                                      _SocialAuthButton(
                                        icon: isPhoneMode
                                            ? Icons.mail_outline_rounded
                                            : Icons.phone_android_rounded,
                                        imageAsset: null,
                                        onTap: () {
                                          _switchAuthMode(
                                              isPhoneMode ? 'email' : 'phone');
                                        },
                                      ),
                                      const SizedBox(width: 32),
                                      _SocialAuthButton(
                                        imageAsset: AppAssets.googleLogoPng,
                                        onTap: () {
                                          _handleSendOtp();
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class _SocialAuthButton extends StatelessWidget {
  final String? imageAsset;
  final IconData? icon;
  final VoidCallback onTap;

  const _SocialAuthButton({
    this.imageAsset,
    this.icon,
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
        padding: const EdgeInsets.all(11),
        child: imageAsset != null
            ? Image.asset(
                imageAsset!,
                fit: BoxFit.contain,
              )
            : Icon(
                icon,
                size: 22,
                color: AppColors.textPrimary,
              ),
      ),
    );
  }
}
