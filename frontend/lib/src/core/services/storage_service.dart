import 'dart:convert';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';  // Temporarily disabled
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/app_constants.dart';
import '../models/user_model.dart';

class StorageService {
  // static const _secureStorage = FlutterSecureStorage(  // Temporarily disabled
  //   aOptions: AndroidOptions(
  //     encryptedSharedPreferences: true,
  //   ),
  // );

  late final SharedPreferences _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Storage Methods (using shared_preferences temporarily)
  Future<void> saveAccessToken(String token) async {
    await _prefs.setString(AppConstants.accessTokenKey, token);
  }

  String? getAccessToken() {
    return _prefs.getString(AppConstants.accessTokenKey);
  }

  Future<void> saveRefreshToken(String token) async {
    await _prefs.setString(AppConstants.refreshTokenKey, token);
  }

  String? getRefreshToken() {
    return _prefs.getString(AppConstants.refreshTokenKey);
  }

  Future<void> saveUserData(UserModel user) async {
    final userJson = json.encode(user.toJson());
    await _prefs.setString(AppConstants.userDataKey, userJson);
  }

  UserModel? getUserData() {
    final userJson = _prefs.getString(AppConstants.userDataKey);
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
    await _prefs.remove(AppConstants.accessTokenKey);
    await _prefs.remove(AppConstants.refreshTokenKey);
  }

  Future<void> clearUserData() async {
    await _prefs.remove(AppConstants.userDataKey);
  }

  Future<void> clearAllSecureData() async {
    await _prefs.clear();
  }

  // Storage Methods (using shared_preferences)
  Future<void> setOnboardingCompleted(bool completed) async {
    await _prefs.setBool(AppConstants.onboardingCompletedKey, completed);
  }

  bool getOnboardingCompleted() {
    return _prefs.getBool(AppConstants.onboardingCompletedKey) ?? false;
  }

  Future<void> setSelectedBoard(String boardId) async {
    await _prefs.setString(AppConstants.selectedBoardKey, boardId);
  }

  String? getSelectedBoard() {
    return _prefs.getString(AppConstants.selectedBoardKey);
  }

  Future<void> setSelectedClass(String classId) async {
    await _prefs.setString(AppConstants.selectedClassKey, classId);
  }

  String? getSelectedClass() {
    return _prefs.getString(AppConstants.selectedClassKey);
  }

  Future<void> setUserPoints(int points) async {
    await _prefs.setInt(AppConstants.userPointsKey, points);
  }

  int getUserPoints() {
    return _prefs.getInt(AppConstants.userPointsKey) ?? 0;
  }

  Future<void> setDailyStreak(int streak) async {
    await _prefs.setInt(AppConstants.dailyStreakKey, streak);
  }

  int getDailyStreak() {
    return _prefs.getInt(AppConstants.dailyStreakKey) ?? 0;
  }

  Future<void> setLastActiveDate(DateTime date) async {
    await _prefs.setString(
      AppConstants.lastActiveDate,
      date.toIso8601String(),
    );
  }

  DateTime? getLastActiveDate() {
    final dateString = _prefs.getString(AppConstants.lastActiveDate);
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
  bool isLoggedIn() {
    final token = getAccessToken();
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
