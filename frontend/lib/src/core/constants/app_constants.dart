class AppConstants {
  // App Information
  static const String appName = 'Gyan AI';
  static const String appVersion = '1.0.0';
  static const String appDescription = 'Your AI-Powered Learning Companion';
  
  // API Endpoints
  static const String apiVersion = 'v1';
  
  // Authentication
  static const String loginEndpoint = '/auth/login';
  static const String registerEndpoint = '/auth/register';
  static const String refreshTokenEndpoint = '/auth/refresh';
  static const String logoutEndpoint = '/auth/logout';
  
  // Curriculum
  static const String boardsEndpoint = '/curriculum/boards';
  static const String classesEndpoint = '/curriculum/classes';
  static const String subjectsEndpoint = '/curriculum/subjects';
  static const String chaptersEndpoint = '/curriculum/chapters';
  
  // Content
  static const String videoEndpoint = '/content/video';
  static const String quizEndpoint = '/content/quiz';
  static const String progressEndpoint = '/content/progress';
  
  // User
  static const String profileEndpoint = '/profile';
  static const String updateProfileEndpoint = '/profile';
  
  // Storage Keys
  static const String accessTokenKey = 'access_token';
  static const String refreshTokenKey = 'refresh_token';
  static const String userDataKey = 'user_data';
  static const String onboardingCompletedKey = 'onboarding_completed';
  
  // Shared Preferences Keys
  static const String selectedBoardKey = 'selected_board';
  static const String selectedClassKey = 'selected_class';
  static const String userPointsKey = 'user_points';
  static const String dailyStreakKey = 'daily_streak';
  static const String lastActiveDate = 'last_active_date';
  
  // Educational Boards
  static const List<String> availableBoards = [
    'CBSE',
    'ICSE',
    'State Board',
  ];
  
  // Available Classes
  static const List<int> availableClasses = [5, 6, 7, 8, 9, 10, 11, 12];
  
  // Gamification
  static const int videoCompletionPoints = 50;
  static const int correctAnswerPoints = 10;
  static const int quizCompletionBonus = 20;
  
  // Video Configuration
  static const int maxVideoGenerationTime = 60; // seconds
  static const int videoBufferTime = 5; // seconds
  
  // Quiz Configuration
  static const int defaultQuizQuestions = 5;
  static const int quizTimeLimit = 300; // 5 minutes in seconds
  
  // Network Configuration
  static const int connectionTimeout = 30; // seconds
  static const int receiveTimeout = 30; // seconds
  static const int sendTimeout = 30; // seconds
  
  // Pagination
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;
  
  // Error Messages
  static const String networkErrorMessage = 'Please check your internet connection and try again.';
  static const String serverErrorMessage = 'Something went wrong. Please try again later.';
  static const String authErrorMessage = 'Authentication failed. Please login again.';
  static const String contentGenerationErrorMessage = 'Oops! We couldn\'t generate the content right now. Please check your connection and try again in a moment.';
  static const String offlineMessage = 'You seem to be offline. Please connect to the internet to continue learning.';
  
  // Success Messages
  static const String registrationSuccessMessage = 'Account created successfully!';
  static const String loginSuccessMessage = 'Welcome back!';
  static const String videoCompletedMessage = 'Lesson Complete! You earned {points} points!';
  static const String quizCompletedMessage = 'Quiz Complete! You earned {points} points!';
  
  // Validation
  static const int minPasswordLength = 8;
  static const int maxNameLength = 50;
  static const String emailPattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
  
  // Animation Durations
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 300);
  static const Duration longAnimation = Duration(milliseconds: 500);
  
  // Debounce Durations
  static const Duration searchDebounce = Duration(milliseconds: 500);
  static const Duration buttonDebounce = Duration(milliseconds: 1000);
}
