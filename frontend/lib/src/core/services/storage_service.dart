import 'dart:convert';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';  // Temporarily disabled
// import 'package:shared_preferences/shared_preferences.dart';  // Temporarily disabled
import '../constants/app_constants.dart';
import '../models/user_model.dart';

class StorageService {
  // In-memory storage for now (temporary solution)
  final Map<String, dynamic> _storage = {};

  Future<void> init() async {
    // Initialize in-memory storage
    print('StorageService initialized with in-memory storage');
  }

  // Storage Methods (using in-memory storage temporarily)
  Future<void> saveAccessToken(String token) async {
    _storage[AppConstants.accessTokenKey] = token;
  }

  Future<String?> getAccessToken() async {
    return _storage[AppConstants.accessTokenKey] as String?;
  }

  Future<void> saveRefreshToken(String token) async {
    _storage[AppConstants.refreshTokenKey] = token;
  }

  Future<String?> getRefreshToken() async {
    return _storage[AppConstants.refreshTokenKey] as String?;
  }

  Future<void> saveUserData(UserModel user) async {
    final userJson = json.encode(user.toJson());
    _storage[AppConstants.userDataKey] = userJson;
  }

  UserModel? getUserData() {
    final userJson = _storage[AppConstants.userDataKey] as String?;
    if (userJson != null) {
      try {
        final userMap = json.decode(userJson) as Map<String, dynamic>;
        return UserModel.fromJson(userMap);
      } catch (e) {
        // If parsing fails, return null
        return null;
      }
    }
    return null;
  }

  Future<void> clearTokens() async {
    _storage.remove(AppConstants.accessTokenKey);
    _storage.remove(AppConstants.refreshTokenKey);
  }

  Future<void> clearUserData() async {
    _storage.remove(AppConstants.userDataKey);
  }

  Future<void> clearAllSecureData() async {
    _storage.clear();
  }

  // Storage Methods (using in-memory storage)
  Future<void> setOnboardingCompleted(bool completed) async {
    _storage[AppConstants.onboardingCompletedKey] = completed;
  }

  bool getOnboardingCompleted() {
    return _storage[AppConstants.onboardingCompletedKey] as bool? ?? false;
  }

  Future<void> setSelectedBoard(String boardId) async {
    _storage[AppConstants.selectedBoardKey] = boardId;
  }

  String? getSelectedBoard() {
    return _storage[AppConstants.selectedBoardKey] as String?;
  }

  Future<void> setSelectedClass(String classId) async {
    _storage[AppConstants.selectedClassKey] = classId;
  }

  String? getSelectedClass() {
    return _storage[AppConstants.selectedClassKey] as String?;
  }

  Future<void> setUserPoints(int points) async {
    _storage[AppConstants.userPointsKey] = points;
  }

  int getUserPoints() {
    return _storage[AppConstants.userPointsKey] as int? ?? 0;
  }

  Future<void> setDailyStreak(int streak) async {
    _storage[AppConstants.dailyStreakKey] = streak;
  }

  int getDailyStreak() {
    return _storage[AppConstants.dailyStreakKey] as int? ?? 0;
  }

  Future<void> setLastActiveDate(DateTime date) async {
    _storage[AppConstants.lastActiveDate] = date.toIso8601String();
  }

  DateTime? getLastActiveDate() {
    final dateString = _storage[AppConstants.lastActiveDate] as String?;
    if (dateString != null) {
      try {
        return DateTime.parse(dateString);
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  // Utility Methods
  Future<bool> isLoggedIn() async {
    final token = await getAccessToken();
    return token != null && token.isNotEmpty;
  }

  bool hasCompletedOnboarding() {
    return getOnboardingCompleted();
  }

  Future<void> logout() async {
    await clearTokens();
    await clearUserData();
    await setOnboardingCompleted(false);
    // Keep other preferences like theme, language settings
  }

  Future<void> clearAllData() async {
    await clearAllSecureData();
  }
}
