class AuthModel {
  String email;
  String phoneNumber;
  String otp;
  bool isWhatsappOptedIn;
  String? emailError;
  String? otpError;
  bool isLoading;

  AuthModel({
    this.email = '',
    this.phoneNumber = '+91 9104535366',
    this.otp = '',
    this.isWhatsappOptedIn = true,
    this.emailError,
    this.otpError,
    this.isLoading = false,
  });

  AuthModel copyWith({
    String? email,
    String? phoneNumber,
    String? otp,
    bool? isWhatsappOptedIn,
    String? emailError,
    String? otpError,
    bool? isLoading,
  }) {
    return AuthModel(
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      otp: otp ?? this.otp,
      isWhatsappOptedIn: isWhatsappOptedIn ?? this.isWhatsappOptedIn,
      emailError: emailError,
      otpError: otpError,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
