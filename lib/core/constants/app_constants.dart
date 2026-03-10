class AppConstants {
  AppConstants._();

  // App Info
  static const String appName = 'CardioAI';
  static const String appTagline = 'AI-Powered Heart Sound Screening';
  static const String appVersion = '1.0.0';

  // API (will be connected later with FastAPI)
  static const String baseUrl = 'http://localhost:8000';
  static const String predictEndpoint = '/predict';
  static const String historyEndpoint = '/history';

  // Shared Preferences Keys
  static const String keyIsFirstLaunch = 'is_first_launch';
  static const String keyIsLoggedIn = 'is_logged_in';
  static const String keyIsGuest = 'is_guest';
  static const String keyUserId = 'user_id';
  static const String keyUserName = 'user_name';
  static const String keyUserEmail = 'user_email';

  // Recording Locations
  static const List<String> recordingLocations = [
    'Aortic',
    'Mitral',
    'Tricuspid',
    'Pulmonary',
    'Other',
  ];

  // Gender Options
  static const List<String> genderOptions = ['Male', 'Female', 'Other'];

  // Risk Levels
  static const List<String> riskLevels = [
    'Low Risk',
    'Medium Risk',
    'High Risk',
  ];
}
