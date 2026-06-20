import 'dart:convert';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_profile.dart';
import 'notification_service.dart';

class UserService {
  static const String _userKey = 'local_user_profile';
  static const String _hasCustomProfileKey = 'has_custom_profile';
  static const String _deviceUuidKey = 'device_uuid';
  static final ValueNotifier<UserProfile?> currentUserNotifier = ValueNotifier<UserProfile?>(null);
  static bool _hasCustomProfile = false;
  static String _deviceUuid = '';

  static bool get hasCustomProfile => _hasCustomProfile;
  static String get deviceUuid => _deviceUuid;

  static final UserProfile defaultProfile = UserProfile(
    name: 'Estudante',
    avatarIndex: 0,
    xp: 0,
    streak: 1,
    lastStudyDate: _formatDate(DateTime.now()),
    createdAt: DateTime.now().toIso8601String(),
    isPremium: false,
    freeMessagesUsed: 0,
    lastMessageDate: '',
  );

  static UserProfile get currentUser => currentUserNotifier.value ?? defaultProfile;

  // Initialize service, load user if exists
  static Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    _hasCustomProfile = prefs.getBool(_hasCustomProfileKey) ?? false;
    final userJson = prefs.getString(_userKey);
    if (userJson != null) {
      try {
        final Map<String, dynamic> decoded = jsonDecode(userJson);
        currentUserNotifier.value = UserProfile.fromJson(decoded);
      } catch (e) {
        debugPrint("Error loading user profile: $e");
      }
    }
    // Load or generate a persistent device UUID for backend identification
    String? storedUuid = prefs.getString(_deviceUuidKey);
    if (storedUuid == null || storedUuid.isEmpty) {
      storedUuid = _generateUuid();
      await prefs.setString(_deviceUuidKey, storedUuid);
    }
    _deviceUuid = storedUuid;
    debugPrint('Device UUID: $_deviceUuid');
  }

  /// Generates a random UUID v4
  static String _generateUuid() {
    final rng = Random();
    final bytes = List<int>.generate(16, (_) => rng.nextInt(256));
    bytes[6] = (bytes[6] & 0x0f) | 0x40;
    bytes[8] = (bytes[8] & 0x3f) | 0x80;
    String hex(int b) => b.toRadixString(16).padLeft(2, '0');
    return '${bytes.sublist(0, 4).map(hex).join()}-'
        '${bytes.sublist(4, 6).map(hex).join()}-'
        '${bytes.sublist(6, 8).map(hex).join()}-'
        '${bytes.sublist(8, 10).map(hex).join()}-'
        '${bytes.sublist(10, 16).map(hex).join()}';
  }

  // Create user
  static Future<void> createUser(String name, int avatarIndex) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_hasCustomProfileKey, true);
    _hasCustomProfile = true;

    final now = DateTime.now();
    final todayStr = _formatDate(now);

    // Preserve existing XP and streak if they were studying as "Estudante"
    final currentXp = currentUser.xp;
    final currentStreak = currentUser.streak;

    final profile = UserProfile(
      name: name,
      avatarIndex: avatarIndex,
      xp: currentXp,
      streak: currentStreak,
      lastStudyDate: todayStr,
      createdAt: now.toIso8601String(),
      isPremium: currentUser.isPremium,
      freeMessagesUsed: currentUser.freeMessagesUsed,
      lastMessageDate: currentUser.lastMessageDate,
    );
    await saveProfile(profile);
  }

  // Save profile to SharedPreferences
  static Future<void> saveProfile(UserProfile profile) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userKey, jsonEncode(profile.toJson()));
    currentUserNotifier.value = profile;
  }

  // Increment free messages used for today
  static Future<void> incrementFreeMessages() async {
    final user = currentUser;
    final todayStr = _formatDate(DateTime.now());
    int used = user.freeMessagesUsed;
    if (user.lastMessageDate != todayStr) {
      used = 1;
    } else {
      used += 1;
    }
    final updated = user.copyWith(
      freeMessagesUsed: used,
      lastMessageDate: todayStr,
    );
    await saveProfile(updated);
  }

  // Toggle Premium Status
  static Future<void> setPremium(bool value) async {
    final user = currentUser;
    final updated = user.copyWith(isPremium: value);
    await saveProfile(updated);
  }

  // Add XP and handle potential level up logic
  static Future<void> addXp(int amount) async {
    final user = currentUser;
    final updated = user.copyWith(xp: user.xp + amount);
    await saveProfile(updated);
  }

  // Check and update study streak
  static Future<void> updateStreak() async {
    final user = currentUser;

    final now = DateTime.now();
    final todayStr = _formatDate(now);

    if (user.lastStudyDate == todayStr) {
      // Already studied today, streak stays the same
      await NotificationService.scheduleDailyStreakReminder();
      return;
    }

    final lastDate = DateTime.tryParse(user.lastStudyDate) ?? now.subtract(const Duration(days: 2));
    // Clear out hours/mins for comparison
    final todayDay = DateTime(now.year, now.month, now.day);
    final lastDay = DateTime(lastDate.year, lastDate.month, lastDate.day);
    final difference = todayDay.difference(lastDay).inDays;

    int newStreak = user.streak;
    if (difference == 1) {
      newStreak += 1;
    } else if (difference > 1) {
      newStreak = 1; // Streak resets if missed a day
    }

    final updated = user.copyWith(
      streak: newStreak,
      lastStudyDate: todayStr,
    );
    await saveProfile(updated);
    await NotificationService.scheduleDailyStreakReminder();
  }

  // Delete profile / Reset progress
  static Future<void> resetProfile() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userKey);
    await prefs.remove(_hasCustomProfileKey);
    _hasCustomProfile = false;
    // Also clear individual lesson progress
    final keys = prefs.getKeys();
    for (final key in keys) {
      if (key.startsWith('lesson_progress_') || key.startsWith('lesson_completed_')) {
        await prefs.remove(key);
      }
    }
    currentUserNotifier.value = null;
  }

  // Date helper
  static String _formatDate(DateTime date) {
    return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  }

  // Gamification helpers
  static int getLevel(int xp) {
    if (xp < 200) return 1;
    if (xp < 600) return 2;
    if (xp < 1200) return 3;
    if (xp < 2000) return 4;
    return 5;
  }

  static String getLevelName(int level) {
    switch (level) {
      case 1:
        return 'Novato';
      case 2:
        return 'Iniciante';
      case 3:
        return 'Intermediário';
      case 4:
        return 'Avançado';
      case 5:
        return 'Fluente / Mestre';
      default:
        return 'Novato';
    }
  }

  static int getXpNeededForNextLevel(int level) {
    switch (level) {
      case 1: return 200;
      case 2: return 600;
      case 3: return 1200;
      case 4: return 2000;
      default: return 2000; // Cap
    }
  }

  static int getXpInCurrentLevel(int xp, int level) {
    int prevThreshold = 0;
    if (level == 2) prevThreshold = 200;
    if (level == 3) prevThreshold = 600;
    if (level == 4) prevThreshold = 1200;
    if (level >= 5) prevThreshold = 2000;
    
    return xp - prevThreshold;
  }

  static double getProgressPercentage(int xp, int level) {
    if (level >= 5) return 1.0;
    
    int prevThreshold = 0;
    if (level == 2) prevThreshold = 200;
    if (level == 3) prevThreshold = 600;
    if (level == 4) prevThreshold = 1200;

    int nextThreshold = getXpNeededForNextLevel(level);
    int totalInLevel = nextThreshold - prevThreshold;
    int currentInLevel = xp - prevThreshold;
    
    return (currentInLevel / totalInLevel).clamp(0.0, 1.0);
  }
}
