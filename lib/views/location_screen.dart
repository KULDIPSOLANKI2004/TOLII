import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_typography.dart';
import '../controllers/auth_controller.dart';
import '../widgets/auth_step_progress.dart';
import '../widgets/custom_button.dart';
import '../widgets/location_popup_sheet.dart';
import 'interests_screen.dart';

class LocationScreen extends StatefulWidget {
  final AuthController authController;

  const LocationScreen({
    super.key,
    required this.authController,
  });

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  late AuthController _controller;

  late TextEditingController _localityController;
  late TextEditingController _streetController;
  late TextEditingController _pincodeController;

  String _selectedState = 'Gujarat';
  String _selectedCity = 'Bhavnagar';

  final List<String> _states = [
    'Gujarat',
    'Maharashtra',
    'Delhi',
    'Karnataka',
    'Rajasthan',
    'Madhya Pradesh',
    'Tamil Nadu',
    'Telangana',
    'Uttar Pradesh',
    'West Bengal',
  ];

  final Map<String, List<String>> _citiesByState = {
    'Gujarat': ['Bhavnagar', 'Ahmedabad', 'Surat', 'Vadodara', 'Rajkot', 'Gandhinagar', 'Jamnagar'],
    'Maharashtra': ['Mumbai', 'Pune', 'Nagpur', 'Nashik', 'Thane', 'Aurangabad'],
    'Delhi': ['New Delhi', 'North Delhi', 'South Delhi', 'West Delhi', 'East Delhi'],
    'Karnataka': ['Bengaluru', 'Mysuru', 'Hubli', 'Mangaluru', 'Belagavi'],
    'Rajasthan': ['Jaipur', 'Jodhpur', 'Udaipur', 'Kota', 'Bikaner'],
    'Madhya Pradesh': ['Indore', 'Bhopal', 'Gwalior', 'Jabalpur', 'Ujjain'],
    'Tamil Nadu': ['Chennai', 'Coimbatore', 'Madurai', 'Tiruchirappalli', 'Salem'],
    'Telangana': ['Hyderabad', 'Warangal', 'Nizamabad', 'Karimnagar'],
    'Uttar Pradesh': ['Lucknow', 'Kanpur', 'Noida', 'Varanasi', 'Agra', 'Prayagraj'],
    'West Bengal': ['Kolkata', 'Howrah', 'Durgapur', 'Siliguri', 'Asansol'],
  };

  @override
  void initState() {
    super.initState();
    _controller = widget.authController;

    _selectedState = _controller.state.selectedState.isNotEmpty
        ? _controller.state.selectedState
        : 'Gujarat';
    _selectedCity = _controller.state.selectedCity.isNotEmpty
        ? _controller.state.selectedCity
        : 'Bhavnagar';

    _localityController =
        TextEditingController(text: _controller.state.areaLocality.isNotEmpty ? _controller.state.areaLocality : 'Chitra');
    _streetController =
        TextEditingController(text: _controller.state.streetAddress);
    _pincodeController =
        TextEditingController(text: _controller.state.pincode.isNotEmpty ? _controller.state.pincode : '364004');

    // Show location quick popup automatically if not already confirmed
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && _controller.state.isLocationDetected) {
        _showQuickDetectSheet();
      }
    });
  }

  @override
  void dispose() {
    _localityController.dispose();
    _streetController.dispose();
    _pincodeController.dispose();
    super.dispose();
  }

  void _showQuickDetectSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => LocationPopupSheet(
        initialQuery: '${_localityController.text}, $_selectedCity',
        onDetectLocation: () {
          Navigator.of(ctx).pop();
          _controller.detectLocation();
          setState(() {
            _selectedState = 'Gujarat';
            _selectedCity = 'Bhavnagar';
            _localityController.text = 'Chitra';
            _pincodeController.text = '364004';
          });
        },
        onEnterManually: () {
          Navigator.of(ctx).pop();
        },
      ),
    );
  }

  Future<void> _handleConfirmLocation() async {
    FocusScope.of(context).unfocus();

    // Validate pincode
    final pincode = _pincodeController.text.trim();
    if (!_controller.validatePincode(pincode)) {
      return;
    }

    _controller.setManualLocation(
      state: _selectedState,
      city: _selectedCity,
      locality: _localityController.text.trim().isNotEmpty
          ? _localityController.text.trim()
          : 'Chitra',
      street: _streetController.text.trim(),
      pincode: pincode,
    );

    final success = await _controller.confirmLocation();
    if (success && mounted) {
      Navigator.of(context).push(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              InterestsScreen(
            authController: _controller,
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
    final availableCities = _citiesByState[_selectedState] ?? ['Bhavnagar', 'Ahmedabad', 'Surat'];

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
        actions: [
          IconButton(
            icon: const Icon(
              Icons.my_location_rounded,
              color: AppColors.primary,
              size: 22,
            ),
            tooltip: 'Detect Location',
            onPressed: _showQuickDetectSheet,
          ),
        ],
      ),
      body: SafeArea(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            final state = _controller.state;

            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Step 3 Header
                  const AuthStepProgress(
                    currentStep: 3,
                    totalSteps: 5,
                    title: 'Enter Your Location',
                    subtitle: 'Add your location to find activities near you.',
                  ),
                  const SizedBox(height: 24),

                  // State * Dropdown
                  _buildFieldLabel('State *'),
                  const SizedBox(height: 6),
                  _buildDropdownField(
                    value: _selectedState,
                    items: _states,
                    onChanged: (val) {
                      if (val != null) {
                        setState(() {
                          _selectedState = val;
                          final cities = _citiesByState[val] ?? [];
                          if (!cities.contains(_selectedCity)) {
                            _selectedCity = cities.isNotEmpty ? cities.first : '';
                          }
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 18),

                  // City * Dropdown
                  _buildFieldLabel('City *'),
                  const SizedBox(height: 6),
                  _buildDropdownField(
                    value: availableCities.contains(_selectedCity)
                        ? _selectedCity
                        : availableCities.first,
                    items: availableCities,
                    onChanged: (val) {
                      if (val != null) {
                        setState(() {
                          _selectedCity = val;
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 18),

                  // Area / Locality *
                  _buildFieldLabel('Area / Locality *'),
                  const SizedBox(height: 6),
                  _buildTextInput(
                    controller: _localityController,
                    hint: 'Enter area or locality',
                  ),
                  const SizedBox(height: 18),

                  // Street / Address
                  _buildFieldLabel('Street / Address'),
                  const SizedBox(height: 6),
                  _buildTextInput(
                    controller: _streetController,
                    hint: 'Enter street or address',
                  ),
                  const SizedBox(height: 18),

                  // Pincode * (with inline error validation)
                  _buildFieldLabel('Pincode *'),
                  const SizedBox(height: 6),
                  Container(
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppColors.inputFill,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: state.pincodeError != null
                            ? AppColors.borderError
                            : AppColors.borderLight,
                        width: state.pincodeError != null ? 1.4 : 1.0,
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    child: TextField(
                      controller: _pincodeController,
                      keyboardType: TextInputType.number,
                      maxLength: 6,
                      style: AppTypography.inputText,
                      decoration: const InputDecoration(
                        hintText: '364004',
                        hintStyle: TextStyle(
                          color: AppColors.textTertiary,
                          fontSize: 15,
                        ),
                        counterText: '',
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(vertical: 12),
                      ),
                      onChanged: (val) {
                        if (state.pincodeError != null) {
                          _controller.clearPincodeError();
                        }
                      },
                      onSubmitted: (_) => _handleConfirmLocation(),
                    ),
                  ),
                  if (state.pincodeError != null) ...[
                    const SizedBox(height: 6),
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
                            state.pincodeError!,
                            style: AppTypography.errorText,
                          ),
                        ),
                      ],
                    ),
                  ],
                  const SizedBox(height: 32),

                  // Confirm Location Button
                  CustomButton(
                    text: 'Confirm Location',
                    isLoading: state.isLoading,
                    onPressed: _handleConfirmLocation,
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
    final isRequired = label.contains('*');
    final baseText = label.replaceAll('*', '').trim();

    return Row(
      children: [
        Text(
          baseText,
          style: AppTypography.inputLabel.copyWith(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        if (isRequired) ...[
          const SizedBox(width: 3),
          const Text(
            '*',
            style: TextStyle(
              color: AppColors.errorRed,
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildDropdownField({
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
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
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: items.contains(value) ? value : (items.isNotEmpty ? items.first : null),
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
          items: items.map((item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(item),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildTextInput({
    required TextEditingController controller,
    required String hint,
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
        style: AppTypography.inputText,
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
      ),
    );
  }
}
