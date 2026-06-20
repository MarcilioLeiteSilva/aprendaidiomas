class UserProfile {
  final String name;
  final int avatarIndex;
  final int xp;
  final int streak;
  final String lastStudyDate;
  final String createdAt;
  final bool isPremium;
  final int freeMessagesUsed;
  final String lastMessageDate;

  UserProfile({
    required this.name,
    required this.avatarIndex,
    this.xp = 0,
    this.streak = 0,
    required this.lastStudyDate,
    required this.createdAt,
    this.isPremium = false,
    this.freeMessagesUsed = 0,
    this.lastMessageDate = '',
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'avatarIndex': avatarIndex,
      'xp': xp,
      'streak': streak,
      'lastStudyDate': lastStudyDate,
      'createdAt': createdAt,
      'isPremium': isPremium,
      'freeMessagesUsed': freeMessagesUsed,
      'lastMessageDate': lastMessageDate,
    };
  }

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      name: json['name'] ?? '',
      avatarIndex: json['avatarIndex'] ?? 0,
      xp: json['xp'] ?? 0,
      streak: json['streak'] ?? 0,
      lastStudyDate: json['lastStudyDate'] ?? '',
      createdAt: json['createdAt'] ?? '',
      isPremium: json['isPremium'] ?? false,
      freeMessagesUsed: json['freeMessagesUsed'] ?? 0,
      lastMessageDate: json['lastMessageDate'] ?? '',
    );
  }

  UserProfile copyWith({
    String? name,
    int? avatarIndex,
    int? xp,
    int? streak,
    String? lastStudyDate,
    String? createdAt,
    bool? isPremium,
    int? freeMessagesUsed,
    String? lastMessageDate,
  }) {
    return UserProfile(
      name: name ?? this.name,
      avatarIndex: avatarIndex ?? this.avatarIndex,
      xp: xp ?? this.xp,
      streak: streak ?? this.streak,
      lastStudyDate: lastStudyDate ?? this.lastStudyDate,
      createdAt: createdAt ?? this.createdAt,
      isPremium: isPremium ?? this.isPremium,
      freeMessagesUsed: freeMessagesUsed ?? this.freeMessagesUsed,
      lastMessageDate: lastMessageDate ?? this.lastMessageDate,
    );
  }
}
