import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'category_screen.dart';
import 'quiz_screen.dart';
import 'settings_screen.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../services/ad_helper.dart';

import 'speaking_practice_screen.dart';
import '../config/app_config.dart';
import 'ai_conversation_screen.dart';
import '../services/user_service.dart';
import 'local_login_screen.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final String selectedLanguage = AppConfig.databaseColumn; // Idioma dinâmico pela Engine
  
  BannerAd? _bannerAd;
  bool _isBannerAdReady = false;

  @override
  void initState() {
    super.initState();
    _loadBannerAd();

  }

  void _loadBannerAd() {
    _bannerAd = BannerAd(
      adUnitId: AdHelper.bannerAdUnitId,
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (_) {
          setState(() {
            _isBannerAdReady = true;
          });
        },
        onAdFailedToLoad: (ad, err) {
          _isBannerAdReady = false;
          ad.dispose();
        },
      ),
    );
    _bannerAd?.load();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: AppTheme.gradientBackground,
        child: SafeArea(
          child: ValueListenableBuilder(
            valueListenable: UserService.currentUserNotifier,
            builder: (context, user, child) {
              final name = user?.name ?? 'Estudante';
              final avatarIndex = user?.avatarIndex ?? 0;
              final xp = user?.xp ?? 0;
              final streak = user?.streak ?? 0;

              final avatarOption = LocalLoginScreen.avatarOptions[avatarIndex.clamp(0, 5)];
              final emoji = avatarOption['emoji'] as String;
              final colors = avatarOption['colors'] as List<Color>;

              return SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(name, emoji, colors),
                    const SizedBox(height: 20),
                    _buildEvolutionPanel(xp, streak),
                    const SizedBox(height: 24),
                    _buildAiBanner(),
                    const SizedBox(height: 32),
                    Text(
                      "O que você gostaria de praticar?",
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 16),
                    _buildMenuGrid(),
                  ],
                ),
              );
            },
          ),
        ),
      ),
      bottomNavigationBar: _isBannerAdReady
          ? SafeArea(
              child: SizedBox(
                width: _bannerAd!.size.width.toDouble(),
                height: _bannerAd!.size.height.toDouble(),
                child: AdWidget(ad: _bannerAd!),
              ),
            )
          : null,
    );
  }

  Widget _buildHeader(String name, String emoji, List<Color> colors) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          children: [
            // User Avatar Icon with nice gradient
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: colors,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: colors[0].withAlpha(80),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  )
                ],
              ),
              alignment: Alignment.center,
              child: Text(
                emoji,
                style: const TextStyle(fontSize: 28),
              ),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Olá, $name! 👋",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textColor,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  "Pronto para praticar hoje?",
                  style: TextStyle(
                    color: AppTheme.textSecondaryColor,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ],
        ),
        IconButton(
          onPressed: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SettingsScreen()),
            );
            setState(() {});
          },
          icon: Icon(Icons.settings_rounded, color: AppTheme.textSecondaryColor, size: 28),
        ),
      ],
    );
  }

  Widget _buildEvolutionPanel(int xp, int streak) {
    final level = UserService.getLevel(xp);
    final levelName = UserService.getLevelName(level);
    final nextLevelXp = UserService.getXpNeededForNextLevel(level);
    final currentLevelXp = UserService.getXpInCurrentLevel(xp, level);
    
    int prevThreshold = 0;
    if (level == 2) prevThreshold = 200;
    if (level == 3) prevThreshold = 600;
    if (level == 4) prevThreshold = 1200;
    
    final totalInLevel = level >= 5 ? 1 : (nextLevelXp - prevThreshold);
    final progress = UserService.getProgressPercentage(xp, level);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: AppTheme.cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Nível $level - $levelName",
                    style: TextStyle(
                      color: AppTheme.textColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    level >= 5 ? "$xp XP total (Nível Máximo)" : "$currentLevelXp / $totalInLevel XP para o Nível ${level + 1}",
                    style: TextStyle(
                      color: AppTheme.textSecondaryColor,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withAlpha(30),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppTheme.primaryColor.withAlpha(60)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.local_fire_department_rounded, color: Colors.orange, size: 18),
                    const SizedBox(width: 4),
                    Text(
                      "$streak ${streak == 1 ? 'dia' : 'dias'}",
                      style: TextStyle(
                        color: AppTheme.textColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // XP progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 10,
              backgroundColor: AppTheme.isDark ? Colors.white.withAlpha(10) : Colors.black.withAlpha(5),
              color: AppTheme.primaryColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuGrid() {
    final menuItems = [
      {
        'title': 'Vocabulário',
        'subtitle': 'Aprenda mais de 240 palavras com cartões',
        'icon': Icons.menu_book_rounded,
        'color': const Color(0xFF6366F1),
        'screen': () => CategoryScreen(type: 'words', language: selectedLanguage),
      },
      {
        'title': 'Guia de Frases',
        'subtitle': 'Mais de 190 frases úteis',
        'icon': Icons.chat_bubble_outline_rounded,
        'color': const Color(0xFFEC4899),
        'screen': () => CategoryScreen(type: 'phrases', language: selectedLanguage),
      },
      {
        'title': 'Exercícios (Quiz)',
        'subtitle': 'Teste sua gramática',
        'icon': Icons.quiz_rounded,
        'color': const Color(0xFF14B8A6),
        'screen': () => QuizScreen(language: selectedLanguage),
      },
      {
        'title': 'Prática de Fala',
        'subtitle': 'Pratique conversas por nível',
        'icon': Icons.record_voice_over_rounded,
        'color': const Color(0xFFF59E0B),
        'screen': () => const SpeakingPracticeScreen(showAppBarBackButton: true),
      },
    ];

    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 1, // Single column cards for larger impact
        mainAxisSpacing: 16,
        childAspectRatio: 2.0,
      ),
      itemCount: menuItems.length,
      itemBuilder: (context, index) {
        final item = menuItems[index];

        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => (item['screen'] as Function)()),
            );
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [item['color'] as Color, (item['color'] as Color).withAlpha(150)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: (item['color'] as Color).withAlpha(80),
                  blurRadius: 16,
                  offset: const Offset(0, 8),
                )
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(item['icon'] as IconData, size: 32, color: AppTheme.textColor),
                      const SizedBox(height: 12),
                      Text(
                        item['title'] as String,
                        style: TextStyle(
                          color: AppTheme.textColor,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item['subtitle'] as String,
                        style: TextStyle(color: AppTheme.textSecondaryColor, fontSize: 13),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.chevron_right_rounded, color: AppTheme.textSecondaryColor, size: 32),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildAiBanner() {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const AiConversationScreen()),
        );
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              Color(0xFF8B5CF6), // Purple
              Color(0xFFEC4899), // Pink
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF8B5CF6).withAlpha(80),
              blurRadius: 16,
              offset: const Offset(0, 8),
            )
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withAlpha(50),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      "NOVIDADE ✨",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.0,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    "Pratique com IA",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    "Converse livremente com nosso tutor inteligente em espanhol.",
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.chat_bubble_outline_rounded,
                color: Color(0xFF8B5CF6),
                size: 28,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
