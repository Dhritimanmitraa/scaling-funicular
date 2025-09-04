// Temporarily disabled for minimal build
class AnalyticsService {
  // Placeholder methods for minimal build
  static Future<void> logEvent({required String name, Map<String, dynamic>? parameters}) async {
    print('Analytics: $name - $parameters');
  }
  
  static Future<void> logLogin({required String method}) async {
    print('Analytics: Login - $method');
  }
  
  static Future<void> logSignUp({required String method}) async {
    print('Analytics: SignUp - $method');
  }
  
  static Future<void> logVideoPlay({required String videoId}) async {
    print('Analytics: VideoPlay - $videoId');
  }
  
  static Future<void> logVideoComplete({required String videoId}) async {
    print('Analytics: VideoComplete - $videoId');
  }
  
  static Future<void> logQuizStart({required String quizId}) async {
    print('Analytics: QuizStart - $quizId');
  }
  
  static Future<void> logQuizComplete({required String quizId, required int score}) async {
    print('Analytics: QuizComplete - $quizId, Score: $score');
  }
  
  static Future<void> logError({required String error, String? context, Map<String, dynamic>? additionalData}) async {
    print('Analytics: Error - $error, Context: $context, Data: $additionalData');
  }
  
  static Future<void> logCustomEvent({required String eventName, Map<String, dynamic>? parameters}) async {
    print('Analytics: CustomEvent - $eventName, Parameters: $parameters');
  }
  
  static Future<void> setUserProperties({required String userId, required String userType}) async {
    print('Analytics: SetUserProperties - UserId: $userId, Type: $userType');
  }
}