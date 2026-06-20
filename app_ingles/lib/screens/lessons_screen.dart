import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../theme/app_theme.dart';
import '../models/lessons_data.dart';
import 'lesson_practice_screen.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../services/ad_helper.dart';

class LessonsScreen extends StatefulWidget {
  const LessonsScreen({super.key});

  @override
  State<LessonsScreen> createState() => _LessonsScreenState();
}

class _LessonsScreenState extends State<LessonsScreen> {
  final List<Lesson> lessons = appLessons;

  RewardedAd? _rewardedAd;
  bool _isRewardedAdReady = false;

  // Levels that require watching a Rewarded Ad to unlock
  static const _premiumLevels = {'Pré-Intermediário', 'Intermediário', 'Avançado'};

  bool _isPremiumLevel(String level) => _premiumLevels.contains(level);

  @override
  void initState() {
    super.initState();
    _loadRewardedAd();
    _loadSavedProgress();
  }

  Future<void> _loadSavedProgress() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      for (final lesson in lessons) {
        lesson.progress = prefs.getInt('lesson_progress_${lesson.id}') ?? 0;
        lesson.isCompleted = prefs.getBool('lesson_completed_${lesson.id}') ?? false;
      }
    });
  }

  void _loadRewardedAd() {
    RewardedAd.load(
      adUnitId: AdHelper.rewardedAdUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          setState(() {
            _rewardedAd = ad;
            _isRewardedAdReady = true;
          });
        },
        onAdFailedToLoad: (err) {
          _isRewardedAdReady = false;
        },
      ),
    );
  }

  void _openLesson(Lesson lesson) {
    if (_isPremiumLevel(lesson.level)) {
      _showRewardedAdGate(lesson);
    } else {
      _navigateToLesson(lesson);
    }
  }

  void _showRewardedAdGate(Lesson lesson) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.surfaceColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle bar
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppTheme.textHintColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppTheme.accentColor.withAlpha(20),
                  border: Border.all(color: AppTheme.accentColor.withAlpha(80)),
                ),
                child: const Icon(Icons.lock_open_rounded, color: AppTheme.accentColor, size: 40),
              ),
              const SizedBox(height: 20),
              Text(
                'Conteúdo ${lesson.level}',
                style: TextStyle(
                  color: AppTheme.textColor,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Assista a um breve anúncio para desbloquear esta lição gratuitamente.',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppTheme.textSecondaryColor, fontSize: 15, height: 1.5),
              ),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                icon: const Icon(Icons.play_circle_outline_rounded),
                label: const Text(
                  'Assistir e Desbloquear',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.accentColor,
                  foregroundColor: Colors.black,
                  minimumSize: const Size(double.infinity, 56),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                onPressed: _isRewardedAdReady
                    ? () {
                        Navigator.pop(context); // Close bottom sheet
                        _showRewardedAd(lesson);
                      }
                    : null, // Disabled if ad not ready
              ),
              const SizedBox(height: 12),
              if (!_isRewardedAdReady)
                Text(
                  'Carregando anúncio… Tente novamente em instantes.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AppTheme.textHintColor, fontSize: 12),
                ),
            ],
          ),
        );
      },
    );
  }

  void _showRewardedAd(Lesson lesson) {
    if (!_isRewardedAdReady || _rewardedAd == null) {
      // Fallback: if somehow ad not ready, still open lesson to avoid frustrating the user
      _navigateToLesson(lesson);
      return;
    }

    _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        _isRewardedAdReady = false;
        _loadRewardedAd(); // Preload next ad
      },
      onAdFailedToShowFullScreenContent: (ad, err) {
        ad.dispose();
        _isRewardedAdReady = false;
        _loadRewardedAd();
        // Fallback navigate on failure
        _navigateToLesson(lesson);
      },
    );

    _rewardedAd!.show(
      onUserEarnedReward: (ad, reward) {
        // User watched the ad completely — navigate to lesson
        _navigateToLesson(lesson);
      },
    );
  }

  void _navigateToLesson(Lesson lesson) async {
    if (!mounted) return;
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LessonPracticeScreen(lesson: lesson),
      ),
    );
    setState(() {}); // Refresh progress indicators on return
  }

  @override
  void dispose() {
    _rewardedAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lessons'),
        centerTitle: true,
      ),
      body: Container(
        decoration: AppTheme.gradientBackground,
        child: ListView.separated(
          padding: const EdgeInsets.only(left: 24, right: 24, top: 24, bottom: 80),
          itemCount: lessons.length,
          separatorBuilder: (context, index) => const SizedBox(height: 20),
          itemBuilder: (context, index) {
            final lesson = lessons[index];
            final progressPercent = lesson.progress / lesson.items.length;
            final isPremium = _isPremiumLevel(lesson.level);

            return GestureDetector(
              onTap: () => _openLesson(lesson),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: AppTheme.cardDecoration,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            lesson.title,
                            style: TextStyle(
                              color: AppTheme.textColor,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        // Level badge
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: _levelColor(lesson.level).withAlpha(40),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: _levelColor(lesson.level)),
                          ),
                          child: Text(
                            lesson.level,
                            style: TextStyle(
                              color: AppTheme.textColor,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        // Lock icon for premium lessons
                        if (isPremium) ...[
                          const SizedBox(width: 8),
                          const Icon(Icons.lock_rounded, color: AppTheme.accentColor, size: 20),
                        ]
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      lesson.description,
                      style: TextStyle(color: AppTheme.textSecondaryColor, fontSize: 14),
                    ),
                    // Show rewarded hint for premium levels
                    if (isPremium) ...[
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.play_circle_outline_rounded,
                              color: AppTheme.accentColor, size: 14),
                          const SizedBox(width: 4),
                          Text(
                            'Assista um anúncio para desbloquear',
                            style: TextStyle(
                              color: AppTheme.accentColor.withAlpha(200),
                              fontSize: 12,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ),
                    ],
                    const SizedBox(height: 16),
                    // Progress bar (only for free levels or if already accessed)
                    Row(
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: LinearProgressIndicator(
                              value: progressPercent,
                              backgroundColor: Colors.white.withAlpha(20),
                              color: lesson.isCompleted
                                  ? AppTheme.accentColor
                                  : AppTheme.primaryColor,
                              minHeight: 8,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          lesson.isCompleted ? 'Completo!' : 'Pendente',
                          style: TextStyle(
                            color: lesson.isCompleted
                                ? AppTheme.accentColor
                                : AppTheme.textSecondaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Color _levelColor(String level) {
    switch (level) {
      case 'Fácil':
        return Colors.green;
      case 'Pré-Intermediário':
        return Colors.orange;
      case 'Intermediário':
        return Colors.deepOrangeAccent;
      case 'Avançado':
        return Colors.red;
      default:
        return AppTheme.primaryColor;
    }
  }
}
