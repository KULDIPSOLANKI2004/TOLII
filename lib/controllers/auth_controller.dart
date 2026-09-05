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

  // Email Validation (Live inline validation, no snackbars)
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

  void toggleWhatsappOptIn() {
    _state.isWhatsappOptedIn = !_state.isWhatsappOptedIn;
    notifyListeners();
  }

  Future<bool> sendOtp() async {
    final trimmed = _state.email.trim();
    if (trimmed.isEmpty) {
      _state.email = 'vatsal@gmail.com';
    } else {
      _state.email = trimmed;
    }
    _state.emailError = null;
    _state.isLoading = false;
    startResendTimer(seconds: 23);
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

  Future<bool> verifyOtp() async {
    _state.otpError = null;
    _state.isLoading = false;
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

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
