class UserBadgeProgress {
  final String badgeId;
  int currentLevel;
  int currentProgress;
  bool isCompleted;
  DateTime lastUpdated;
  int currentStreak;

  UserBadgeProgress({
    required this.badgeId,
    this.currentLevel = 0,
    this.currentProgress = 0,
    this.isCompleted = false,
    required this.lastUpdated,
    this.currentStreak = 0,
  });

  factory UserBadgeProgress.initial(String badgeId) {
    return UserBadgeProgress(badgeId: badgeId, lastUpdated: DateTime.now());
  }

  Map<String, dynamic> toJson() => {
    'badgeId': badgeId,
    'currentLevel': currentLevel,
    'currentProgress': currentProgress,
    'isCompleted': isCompleted,
    'lastUpdated': lastUpdated.toIso8601String(),
    'currentStreak': currentStreak,
  };

  factory UserBadgeProgress.fromJson(Map<String, dynamic> json) {
    return UserBadgeProgress(
      badgeId: json['badgeId'],
      currentLevel: json['currentLevel'] ?? 0,
      currentProgress: json['currentProgress'] ?? 0,
      isCompleted: json['isCompleted'] ?? false,
      lastUpdated: json['lastUpdated'] != null
          ? DateTime.parse(json['lastUpdated'])
          : DateTime.now(),
      currentStreak: json['currentStreak'] ?? 0,
    );
  }

  UserBadgeProgress copyWith({
    String? badgeId,
    int? currentLevel,
    int? currentProgress,
    bool? isCompleted,
    DateTime? lastUpdated,
    int? currentStreak,
  }) {
    return UserBadgeProgress(
      badgeId: badgeId ?? this.badgeId,
      currentLevel: currentLevel ?? this.currentLevel,
      currentProgress: currentProgress ?? this.currentProgress,
      isCompleted: isCompleted ?? this.isCompleted,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      currentStreak: currentStreak ?? this.currentStreak,
    );
  }
}
