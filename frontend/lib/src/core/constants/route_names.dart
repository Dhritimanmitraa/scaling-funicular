class RouteNames {
  // Authentication Routes
  static const String splash = '/';
  static const String welcome = '/welcome';
  static const String login = '/login';
  static const String register = '/register';
  static const String curriculumSelection = '/curriculum-selection';
  
  // Main App Routes
  static const String dashboard = '/dashboard';
  static const String home = '/home';
  
  // Curriculum Routes
  static const String subjects = '/subjects';
  static const String chapters = '/chapters';
  static const String chapterDetail = '/chapter-detail';
  
  // Content Routes
  static const String videoPlayer = '/video-player';
  static const String quiz = '/quiz';
  static const String quizResults = '/quiz-results';
  
  // Profile Routes
  static const String profile = '/profile';
  static const String settings = '/settings';
  static const String progress = '/progress';
  
  // Route Parameters
  static const String subjectIdParam = 'subjectId';
  static const String chapterIdParam = 'chapterId';
  static const String videoIdParam = 'videoId';
  static const String quizIdParam = 'quizId';
  static const String boardIdParam = 'boardId';
  static const String classIdParam = 'classId';
}
