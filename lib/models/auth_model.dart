class AuthModel {
  String authMode; // 'phone' or 'email'
  String email;
  String phoneNumber;
  String phoneCountryCode;
  String rawPhoneNumber;
  String otp;
  bool isWhatsappOptedIn;
  int currentStep; // 1 to 5

  // Location fields
  String selectedState;
  String selectedCity;
  String areaLocality;
  String streetAddress;
  String pincode;
  String locationSummary;
  bool isLocationDetected;

  // Interests
  List<String> selectedInterests;

  // Profile fields
  String firstName;
  String lastName;
  String username;
  bool isUsernameAvailable;
  String? avatarUrl;
  String? gender;

  // Error & loading states
  String? phoneError;
  String? emailError;
  String? otpError;
  String? pincodeError;
  String? usernameError;
  bool isLoading;

  AuthModel({
    this.authMode = 'phone',
    this.email = 'yourname@gmail.com',
    this.phoneNumber = '+91 98765 43210',
    this.phoneCountryCode = '+91',
    this.rawPhoneNumber = '98765 43210',
    this.otp = '',
    this.isWhatsappOptedIn = true,
    this.currentStep = 1,
    this.selectedState = 'Gujarat',
    this.selectedCity = 'Bhavnagar',
    this.areaLocality = 'Chitra',
    this.streetAddress = '',
    this.pincode = '364004',
    this.locationSummary = 'Bhavnagar, India',
    this.isLocationDetected = true,
    List<String>? selectedInterests,
    this.firstName = '',
    this.lastName = '',
    this.username = 'eve_05',
    this.isUsernameAvailable = true,
    this.avatarUrl,
    this.gender,
    this.phoneError,
    this.emailError,
    this.otpError,
    this.pincodeError,
    this.usernameError,
    this.isLoading = false,
  }) : selectedInterests = selectedInterests ??
            ['Badminton', 'Running', 'Gaming', 'Photography'];

  String get fullPhoneNumber =>
      '$phoneCountryCode ${rawPhoneNumber.replaceAll(' ', '')}'.trim();

  AuthModel copyWith({
    String? authMode,
    String? email,
    String? phoneNumber,
    String? phoneCountryCode,
    String? rawPhoneNumber,
    String? otp,
    bool? isWhatsappOptedIn,
    int? currentStep,
    String? selectedState,
    String? selectedCity,
    String? areaLocality,
    String? streetAddress,
    String? pincode,
    String? locationSummary,
    bool? isLocationDetected,
    List<String>? selectedInterests,
    String? firstName,
    String? lastName,
    String? username,
    bool? isUsernameAvailable,
    String? avatarUrl,
    String? gender,
    String? phoneError,
    String? emailError,
    String? otpError,
    String? pincodeError,
    String? usernameError,
    bool? isLoading,
  }) {
    return AuthModel(
      authMode: authMode ?? this.authMode,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      phoneCountryCode: phoneCountryCode ?? this.phoneCountryCode,
      rawPhoneNumber: rawPhoneNumber ?? this.rawPhoneNumber,
      otp: otp ?? this.otp,
      isWhatsappOptedIn: isWhatsappOptedIn ?? this.isWhatsappOptedIn,
      currentStep: currentStep ?? this.currentStep,
      selectedState: selectedState ?? this.selectedState,
      selectedCity: selectedCity ?? this.selectedCity,
      areaLocality: areaLocality ?? this.areaLocality,
      streetAddress: streetAddress ?? this.streetAddress,
      pincode: pincode ?? this.pincode,
      locationSummary: locationSummary ?? this.locationSummary,
      isLocationDetected: isLocationDetected ?? this.isLocationDetected,
      selectedInterests: selectedInterests ?? List.from(this.selectedInterests),
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      username: username ?? this.username,
      isUsernameAvailable: isUsernameAvailable ?? this.isUsernameAvailable,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      gender: gender ?? this.gender,
      phoneError: phoneError,
      emailError: emailError,
      otpError: otpError,
      pincodeError: pincodeError,
      usernameError: usernameError,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
