import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/app_colors.dart';
import '../constants/app_typography.dart';

class EditProfileScreen extends StatefulWidget {
  final String initialFirstName;
  final String initialLastName;
  final String initialEmail;
  final String initialPhone;
  final String initialGender;
  final String initialBio;

  const EditProfileScreen({
    super.key,
    this.initialFirstName = 'Arjun',
    this.initialLastName = 'Mehta',
    this.initialEmail = 'arjun.mehta@gmail.com',
    this.initialPhone = '+91 98765 43210',
    this.initialGender = 'Male',
    this.initialBio = 'Sports enthusiast & weekend pickleballer.',
  });

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _bioController;
  String _selectedGender = 'Male';

  final List<String> _genders = ['Male', 'Female', 'Other', 'Prefer not to say'];

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController(text: widget.initialFirstName);
    _lastNameController = TextEditingController(text: widget.initialLastName);
    _emailController = TextEditingController(text: widget.initialEmail);
    _phoneController = TextEditingController(text: widget.initialPhone);
    _bioController = TextEditingController(text: widget.initialBio);
    _selectedGender = widget.initialGender;
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  void _saveProfile() {
    HapticFeedback.mediumImpact();
    Navigator.of(context).pop({
      'firstName': _firstNameController.text.trim(),
      'lastName': _lastNameController.text.trim(),
      'email': _emailController.text.trim(),
      'phone': _phoneController.text.trim(),
      'gender': _selectedGender,
      'bio': _bioController.text.trim(),
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Profile updated successfully!'),
        duration: Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
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
            // Top Nav
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
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.03),
                            blurRadius: 4,
                            offset: const Offset(0, 1),
                          ),
                        ],
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
                      'Edit Profile',
                      style: AppTypography.headline.copyWith(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF0F172A),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(width: 38),
                ],
              ),
            ),
            const Divider(color: Color(0xFFF1F5F9), height: 1),

            // Form Fields
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Column(
                  children: [
                    // Card 1: Avatar + Names
                    Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.02),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          // Avatar placeholder
                          Container(
                            width: 86,
                            height: 86,
                            decoration: const BoxDecoration(
                              color: Color(0xFFE2E8F0),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.person_rounded,
                              size: 48,
                              color: Color(0xFF94A3B8),
                            ),
                          ),
                          const SizedBox(height: 10),
                          GestureDetector(
                            onTap: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Image picker triggered!'),
                                  duration: Duration(seconds: 1),
                                ),
                              );
                            },
                            child: Text(
                              'Change Profile Picture',
                              style: AppTypography.caption.copyWith(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF475569),
                              ),
                            ),
                          ),
                          const SizedBox(height: 18),
                          const Divider(color: Color(0xFFF1F5F9), height: 1),
                          const SizedBox(height: 16),

                          // First Name
                          _buildTextField(
                            controller: _firstNameController,
                            hint: 'First Name',
                          ),
                          const SizedBox(height: 14),

                          // Last Name
                          _buildTextField(
                            controller: _lastNameController,
                            hint: 'Last Name',
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Card 2: Contact Details
                    Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.02),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Contact Details',
                            style: AppTypography.titleMedium.copyWith(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF0F172A),
                            ),
                          ),
                          const SizedBox(height: 12),
                          const Divider(color: Color(0xFFF1F5F9), height: 1),
                          const SizedBox(height: 14),

                          // Email
                          _buildTextField(
                            controller: _emailController,
                            hint: 'Email',
                            keyboardType: TextInputType.emailAddress,
                          ),
                          const SizedBox(height: 14),

                          // Phone
                          _buildTextField(
                            controller: _phoneController,
                            hint: 'Phone',
                            keyboardType: TextInputType.phone,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Card 3: About
                    Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.02),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'About',
                            style: AppTypography.titleMedium.copyWith(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF0F172A),
                            ),
                          ),
                          const SizedBox(height: 12),
                          const Divider(color: Color(0xFFF1F5F9), height: 1),
                          const SizedBox(height: 14),

                          // Gender Dropdown
                          Container(
                            height: 48,
                            padding: const EdgeInsets.symmetric(horizontal: 14),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: const Color(0xFFE2E8F0), width: 1.2),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: _genders.contains(_selectedGender) ? _selectedGender : _genders.first,
                                isExpanded: true,
                                icon: const Icon(
                                  Icons.keyboard_arrow_down_rounded,
                                  color: Color(0xFF64748B),
                                ),
                                style: AppTypography.titleMedium.copyWith(
                                  fontSize: 14.5,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF0F172A),
                                ),
                                items: _genders.map((g) {
                                  return DropdownMenuItem<String>(
                                    value: g,
                                    child: Text(g),
                                  );
                                }).toList(),
                                onChanged: (val) {
                                  if (val != null) {
                                    setState(() {
                                      _selectedGender = val;
                                    });
                                  }
                                },
                              ),
                            ),
                          ),
                          const SizedBox(height: 14),

                          // Bio
                          _buildTextField(
                            controller: _bioController,
                            hint: 'Bio',
                            maxLines: 2,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 28),

                    // Save Button (Solid Blue)
                    GestureDetector(
                      onTap: _saveProfile,
                      child: Container(
                        width: double.infinity,
                        height: 50,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withValues(alpha: 0.28),
                              blurRadius: 10,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          'Save',
                          style: AppTypography.buttonText.copyWith(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Subtext
                    Text(
                      'You can edit the details later.',
                      style: AppTypography.caption.copyWith(
                        fontSize: 12,
                        color: const Color(0xFF94A3B8),
                      ),
                    ),
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

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0), width: 1.2),
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        style: AppTypography.titleMedium.copyWith(
          fontSize: 14.5,
          fontWeight: FontWeight.w600,
          color: const Color(0xFF0F172A),
        ),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: AppTypography.caption.copyWith(
            fontSize: 14,
            color: const Color(0xFF94A3B8),
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        ),
      ),
    );
  }
}
