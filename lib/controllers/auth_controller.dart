import 'dart:async';
import 'package:flutter/material.dart';
import '../models/auth_model.dart';

class AuthController extends ChangeNotifier {
  final AuthModel _state = AuthModel();

  Timer? _timer;
  int _resendCountdown = 23;
  bool _canResend = false;

  AuthModel get state => _state;
  int get resendCountdown => _resendCountdown;
  bool get canResend => _canResend;
  String get formattedCountdown =>
      '00:${_resendCountdown.toString().padLeft(2, '0')}';

  // Step Navigation
  void setStep(int step) {
    if (step >= 1 && step <= 5) {
      _state.currentStep = step;
      notifyListeners();
    }
  }

  // Auth Mode (phone vs email)
  void setAuthMode(String mode) {
    _state.authMode = mode;
    _state.phoneError = null;
    _state.emailError = null;
    notifyListeners();
  }

  // Email Validation
  bool validateEmail(String email) {
    final trimmed = email.trim();
    _state.email = trimmed;

    if (trimmed.isEmpty) {
      _state.emailError = 'Please enter your email address';
      notifyListeners();
      return false;
    }

    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(trimmed)) {
      _state.emailError = 'Please enter a valid email address';
      notifyListeners();
      return false;
    }

    _state.emailError = null;
    notifyListeners();
    return true;
  }

  void clearEmailError() {
    if (_state.emailError != null) {
      _state.emailError = null;
      notifyListeners();
    }
  }

  // Phone Validation
  bool validatePhone(String phone) {
    final digits = phone.replaceAll(RegExp(r'\D'), '');
    _state.rawPhoneNumber = phone;
    _state.phoneNumber = '+91 $phone'.trim();

    if (digits.isEmpty) {
      _state.phoneError = 'Please enter your mobile number';
      notifyListeners();
      return false;
    }

    if (digits.length < 10) {
      _state.phoneError = 'Please enter a valid 10-digit mobile number';
      notifyListeners();
      return false;
    }

    _state.phoneError = null;
    notifyListeners();
    return true;
  }

  void clearPhoneError() {
    if (_state.phoneError != null) {
      _state.phoneError = null;
      notifyListeners();
    }
  }

  void toggleWhatsappOptIn() {
    _state.isWhatsappOptedIn = !_state.isWhatsappOptedIn;
    notifyListeners();
  }

  // Send OTP (Step 1 -> Step 2)
  Future<bool> sendOtp() async {
    _state.isLoading = true;
    notifyListeners();

    if (_state.authMode == 'email') {
      final trimmed = _state.email.trim();
      if (trimmed.isEmpty) {
        _state.email = 'yourname@gmail.com';
      }
    } else {
      final trimmed = _state.rawPhoneNumber.trim();
      if (trimmed.isEmpty) {
        _state.rawPhoneNumber = '98765 43210';
        _state.phoneNumber = '+91 98765 43210';
      }
    }

    await Future.delayed(const Duration(milliseconds: 350));
    _state.isLoading = false;
    _state.otpError = null;
    startResendTimer(seconds: 23);
    _state.currentStep = 2;
    notifyListeners();
    return true;
  }

  void startResendTimer({int seconds = 23}) {
    _timer?.cancel();
    _resendCountdown = seconds;
    _canResend = false;
    notifyListeners();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_resendCountdown > 1) {
        _resendCountdown--;
        notifyListeners();
      } else {
        _resendCountdown = 0;
        _canResend = true;
        _timer?.cancel();
        notifyListeners();
      }
    });
  }

  void updateOtp(String otp) {
    _state.otp = otp;
    if (_state.otpError != null) {
      _state.otpError = null;
    }
    notifyListeners();
  }

  // Verify OTP (Step 2 -> Step 3)
  Future<bool> verifyOtp() async {
    _state.isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 350));
    _state.isLoading = false;

    if (_state.otp.isNotEmpty && _state.otp.length < 6) {
      _state.otpError = 'Please enter complete 6-digit OTP';
      notifyListeners();
      return false;
    }

    _state.otpError = null;
    _state.currentStep = 3;
    notifyListeners();
    return true;
  }

  Future<void> resendOtp() async {
    if (!_canResend) return;

    _state.otp = '';
    _state.otpError = null;
    _state.isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 500));
    _state.isLoading = false;
    startResendTimer(seconds: 23);
    notifyListeners();
  }

  // Step 3: Location Management
  void detectLocation() {
    _state.selectedState = 'Gujarat';
    _state.selectedCity = 'Bhavnagar';
    _state.areaLocality = 'Chitra';
    _state.locationSummary = 'Bhavnagar, India';
    _state.isLocationDetected = true;
    _state.pincodeError = null;
    notifyListeners();
  }

  void setManualLocation({
    required String state,
    required String city,
    required String locality,
    String street = '',
    required String pincode,
  }) {
    _state.selectedState = state;
    _state.selectedCity = city;
    _state.areaLocality = locality;
    _state.streetAddress = street;
    _state.pincode = pincode;
    _state.locationSummary = '$city, India';
    _state.isLocationDetected = false;
    notifyListeners();
  }

  bool validatePincode(String pincode) {
    final digits = pincode.replaceAll(RegExp(r'\D'), '');
    _state.pincode = pincode;

    if (digits.length != 6) {
      _state.pincodeError = 'Enter a valid 6-digit pincode';
      notifyListeners();
      return false;
    }

    _state.pincodeError = null;
    notifyListeners();
    return true;
  }

  void clearPincodeError() {
    if (_state.pincodeError != null) {
      _state.pincodeError = null;
      notifyListeners();
    }
  }

  Future<bool> confirmLocation() async {
    _state.isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 250));
    _state.isLoading = false;
    _state.currentStep = 4;
    notifyListeners();
    return true;
  }

  // Step 4: Interests Management
  void toggleInterest(String interest) {
    if (_state.selectedInterests.contains(interest)) {
      _state.selectedInterests.remove(interest);
    } else {
      _state.selectedInterests.add(interest);
    }
    notifyListeners();
  }

  bool isInterestSelected(String interest) {
    return _state.selectedInterests.contains(interest);
  }

  Future<bool> continueFromInterests() async {
    _state.currentStep = 5;
    notifyListeners();
    return true;
  }

  // Step 5: Profile Creation
  void updateProfileNames({required String firstName, required String lastName}) {
    _state.firstName = firstName;
    _state.lastName = lastName;
    notifyListeners();
  }

  void updateUsername(String username) {
    _state.username = username.trim();
    if (_state.username.isEmpty) {
      _state.isUsernameAvailable = false;
      _state.usernameError = 'Username is required';
    } else if (_state.username.length < 3) {
      _state.isUsernameAvailable = false;
      _state.usernameError = 'Username must be at least 3 characters';
    } else {
      _state.isUsernameAvailable = true;
      _state.usernameError = null;
    }
    notifyListeners();
  }

  void updateGender(String? gender) {
    _state.gender = gender;
    notifyListeners();
  }

  void updateAvatar(String? avatarUrl) {
    _state.avatarUrl = avatarUrl;
    notifyListeners();
  }

  Future<bool> createProfile() async {
    _state.isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 400));
    _state.isLoading = false;
    notifyListeners();
    return true;
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
