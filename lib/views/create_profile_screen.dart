import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/app_colors.dart';
import '../constants/app_typography.dart';
import '../controllers/auth_controller.dart';
import '../widgets/custom_button.dart';
import 'home_screen.dart';
import 'location_screen.dart';

class CreateProfileScreen extends StatefulWidget {
  final AuthController authController;

  const CreateProfileScreen({
    super.key,
    required this.authController,
  });

  @override
  State<CreateProfileScreen> createState() => _CreateProfileScreenState();
}

class _CreateProfileScreenState extends State<CreateProfileScreen> {
  late AuthController _controller;

  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _usernameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;

  String? _selectedGender;
  final List<String> _genderOptions = ['Male', 'Female', 'Other', 'Prefer not to say'];

  @override
  void initState() {
    super.initState();
    _controller = widget.authController;

    _firstNameController = TextEditingController(text: _controller.state.firstName);
    _lastNameController = TextEditingController(text: _controller.state.lastName);
    _usernameController =
        TextEditingController(text: _controller.state.username.isNotEmpty ? _controller.state.username : 'eve_05');
    _emailController = TextEditingController(
        text: _controller.state.email.isNotEmpty
            ? _controller.state.email
            : 'yourname@gmail.com');
    _phoneController = TextEditingController(
        text: _controller.state.phoneNumber.isNotEmpty
            ? _controller.state.phoneNumber
            : '+91 98765 43210');
    _selectedGender = _controller.state.gender;
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _handleCreateProfile() async {
    FocusScope.of(context).unfocus();

    _controller.updateProfileNames(
      firstName: _firstNameController.text.trim(),
      lastName: _lastNameController.text.trim(),
    );
    _controller.updateUsername(_usernameController.text.trim());
    _controller.updateGender(_selectedGender);

    final success = await _controller.createProfile();
    if (success && mounted) {
      HapticFeedback.mediumImpact();
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

  void _showAddInterestsSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        height: MediaQuery.of(context).size.height * 0.75,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Select Activities',
                  style: AppTypography.titleLarge,
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(ctx).pop(),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, _) {
                  final allActivities = [
                    'Box Cricket', 'Football', 'Badminton', 'Pickleball',
                    'Table Tennis', 'Basketball', 'Running', 'Cycling',
                    'Gaming', 'Hiking', 'Yoga', 'Dance', 'Gym',
                    'Shopping', 'Photography', 'Volleyball', 'Movies',
                    'Walking', 'Hangouts', 'Cafe Hangouts',
                  ];
                  return SingleChildScrollView(
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 10,
                      children: allActivities.map((act) {
                        final isSel = _controller.isInterestSelected(act);
                        return FilterChip(
                          label: Text(act),
                          selected: isSel,
                          selectedColor: AppColors.primary,
                          labelStyle: TextStyle(
                            color: isSel ? Colors.white : AppColors.textPrimary,
                            fontWeight: isSel ? FontWeight.w600 : FontWeight.w500,
                          ),
                          checkmarkColor: Colors.white,
                          onSelected: (_) {
                            _controller.toggleInterest(act);
                          },
                        );
                      }).toList(),
                    ),
                  );
                },
              ),
            ),
            CustomButton(
              text: 'Done',
              onPressed: () => Navigator.of(ctx).pop(),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: AppColors.textPrimary,
            size: 22,
          ),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: Text(
          'Create Your Profile',
          style: AppTypography.headline.copyWith(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.textDark,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            final state = _controller.state;

            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Profile Avatar Section
                  Center(
                    child: Column(
                      children: [
                        Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Container(
                              width: 86,
                              height: 86,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: const Color(0xFFF1F5F9),
                                border: Border.all(
                                  color: AppColors.primaryLight,
                                  width: 1.5,
                                ),
                              ),
                              child: const Icon(
                                Icons.person_outline_rounded,
                                size: 48,
                                color: AppColors.primary,
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                width: 26,
                                height: 26,
                                decoration: BoxDecoration(
                                  color: AppColors.primary,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 2,
                                  ),
                                ),
                                child: const Icon(
                                  Icons.camera_alt,
                                  size: 13,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        GestureDetector(
                          onTap: () {
                            HapticFeedback.lightImpact();
                          },
                          child: Text(
                            'Add Profile Picture',
                            style: AppTypography.linkText.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // First Name & Last Name (2 columns)
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildFieldLabel('First Name'),
                            const SizedBox(height: 6),
                            _buildTextInput(
                              controller: _firstNameController,
                              hint: 'First Name',
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildFieldLabel('Last Name'),
                            const SizedBox(height: 6),
                            _buildTextInput(
                              controller: _lastNameController,
                              hint: 'Last Name',
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),

                  // Username
                  _buildFieldLabel('Username'),
                  const SizedBox(height: 6),
                  _buildTextInput(
                    controller: _usernameController,
                    hint: 'eve_05',
                    onChanged: (val) {
                      _controller.updateUsername(val);
                    },
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'This is how people will see you on TOLII.',
                    style: AppTypography.caption.copyWith(
                      color: AppColors.textSecondary,
                      fontSize: 11,
                    ),
                  ),
                  if (state.isUsernameAvailable) ...[
                    const SizedBox(height: 3),
                    Row(
                      children: [
                        const Icon(
                          Icons.check,
                          size: 13,
                          color: AppColors.successGreen,
                        ),
                        const SizedBox(width: 3),
                        Text(
                          'Username available',
                          style: AppTypography.caption.copyWith(
                            color: AppColors.successGreen,
                            fontWeight: FontWeight.w600,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ],
                  const SizedBox(height: 18),

                  // Email
                  _buildFieldLabel('Email'),
                  const SizedBox(height: 6),
                  _buildTextInput(
                    controller: _emailController,
                    hint: 'yourname@gmail.com',
                  ),
                  const SizedBox(height: 18),

                  // Phone with Verified Badge
                  _buildFieldLabel('Phone'),
                  const SizedBox(height: 6),
                  Container(
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppColors.inputFill,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: AppColors.borderLight,
                        width: 1.0,
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _phoneController,
                            style: AppTypography.inputText.copyWith(
                              fontSize: 14,
                            ),
                            decoration: const InputDecoration(
                              hintText: '+91 98765 43210',
                              border: InputBorder.none,
                              isDense: true,
                              contentPadding: EdgeInsets.zero,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFECFDF5),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Verified',
                                style: AppTypography.caption.copyWith(
                                  color: AppColors.successGreen,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 11,
                                ),
                              ),
                              const SizedBox(width: 3),
                              const Icon(
                                Icons.check,
                                size: 12,
                                color: AppColors.successGreen,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),

                  // Location (with edit pencil icon)
                  _buildFieldLabel('Location'),
                  const SizedBox(height: 6),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => LocationScreen(
                            authController: _controller,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      height: 48,
                      decoration: BoxDecoration(
                        color: AppColors.inputFill,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: AppColors.borderLight,
                          width: 1.0,
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            state.locationSummary.isNotEmpty
                                ? state.locationSummary
                                : 'Bhavnagar, India',
                            style: AppTypography.inputText.copyWith(
                              fontSize: 14,
                            ),
                          ),
                          const Icon(
                            Icons.edit_outlined,
                            size: 18,
                            color: AppColors.textSecondary,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),

                  // Activities I'm Interested In
                  _buildFieldLabel('Activities I\'m Interested In'),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      ...state.selectedInterests.map((activity) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFEFF6FF),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            activity,
                            style: AppTypography.caption.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                            ),
                          ),
                        );
                      }),
                      GestureDetector(
                        onTap: _showAddInterestsSheet,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: AppColors.borderLight,
                              width: 1.0,
                            ),
                          ),
                          child: Text(
                            '+ Add More',
                            style: AppTypography.caption.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),

                  // Gender Dropdown
                  _buildFieldLabel('Gender'),
                  const SizedBox(height: 6),
                  Container(
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppColors.inputFill,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: AppColors.borderLight,
                        width: 1.0,
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _selectedGender,
                        hint: Text(
                          'Select gender',
                          style: AppTypography.inputText.copyWith(
                            color: AppColors.textTertiary,
                            fontSize: 14,
                          ),
                        ),
                        isExpanded: true,
                        icon: const Icon(
                          Icons.keyboard_arrow_down_rounded,
                          color: AppColors.textSecondary,
                          size: 22,
                        ),
                        style: AppTypography.inputText.copyWith(
                          color: AppColors.textDark,
                          fontSize: 14,
                        ),
                        dropdownColor: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        items: _genderOptions.map((gender) {
                          return DropdownMenuItem<String>(
                            value: gender,
                            child: Text(gender),
                          );
                        }).toList(),
                        onChanged: (val) {
                          setState(() {
                            _selectedGender = val;
                          });
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Create Profile Button
                  CustomButton(
                    text: 'Create Profile',
                    isLoading: state.isLoading,
                    onPressed: _handleCreateProfile,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildFieldLabel(String label) {
    return Text(
      label,
      style: AppTypography.inputLabel.copyWith(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
    );
  }

  Widget _buildTextInput({
    required TextEditingController controller,
    required String hint,
    ValueChanged<String>? onChanged,
  }) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: AppColors.inputFill,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: AppColors.borderLight,
          width: 1.0,
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: TextField(
        controller: controller,
        style: AppTypography.inputText.copyWith(
          fontSize: 14,
        ),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(
            color: AppColors.textTertiary,
            fontSize: 14,
          ),
          border: InputBorder.none,
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(vertical: 12),
        ),
        onChanged: onChanged,
      ),
    );
  }
}
