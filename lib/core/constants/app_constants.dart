class AppConstants {
  static const String appName = 'SafeAlert';
  static const String appVersion = '1.0.0';
  
  // Routes
  static const String splashRoute = '/splash';
  static const String onboardingRoute = '/onboarding';
  static const String loginRoute = '/login';
  static const String registerRoute = '/register';
  static const String homeRoute = '/home';
  static const String profileRoute = '/profile';
  static const String createAlertRoute = '/create-alert';
  static const String alertDetailsRoute = '/alert-details';
  
  // Alert Types
  static const String emergencyAlert = 'emergency';
  static const String fireAlert = 'fire';
  static const String medicalAlert = 'medical';
  static const String crimeAlert = 'crime';
  static const String accidentAlert = 'accident';
  static const String naturalDisasterAlert = 'natural_disaster';
  
  // User Roles
  static const String citizenRole = 'citizen';
  static const String policeRole = 'police';
  static const String emergencyRole = 'emergency';
  static const String authorityRole = 'authority';
  static const String adminRole = 'admin';
  
  // Alert Status
  static const String pendingStatus = 'pending';
  static const String confirmedStatus = 'confirmed';
  static const String inProgressStatus = 'in_progress';
  static const String resolvedStatus = 'resolved';
  static const String falseAlarmStatus = 'false_alarm';
  
  // Firebase Collections
  static const String usersCollection = 'users';
  static const String alertsCollection = 'alerts';
  static const String notificationsCollection = 'notifications';
  
  // Shared Preferences Keys
  static const String isFirstLaunchKey = 'is_first_launch';
  static const String userTokenKey = 'user_token';
  static const String userRoleKey = 'user_role';
  
  // Validation
  static const int minPasswordLength = 6;
  static const int maxAlertRadius = 10000;
  static const int defaultAlertRadius = 5000;
}