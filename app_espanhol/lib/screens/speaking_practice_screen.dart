import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../theme/app_theme.dart';
import '../models/speaking_data.dart';
import '../services/ad_helper.dart';
import 'speaking_conversation_screen.dart';
import 'ai_conversation_screen.dart';

class SpeakingPracticeScreen extends StatefulWidget {
  final bool showAppBarBackButton;
  const SpeakingPracticeScreen({super.key, this.showAppBarBackButton = false});

  @override
  State<SpeakingPracticeScreen> createState() => _SpeakingPracticeScreenState();
}

class _SpeakingPracticeScreenState extends State<SpeakingPracticeScreen> {
  SpeakingLevel _selectedLevel = SpeakingLevel.basic;
  InterstitialAd? _interstitialAd;
  bool _isAdReady = false;

  List<SpeakingScenario> get _filteredScenarios {
    return speakingScenarios.where((s) => s.level == _selectedLevel).toList();
  }

  @override
  void initState() {
    super.initState();
    _loadInterstitialAd();
  }

  void _loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId: AdHelper.interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
              _isAdReady = false;
              _loadInterstitialAd();
            },
            onAdFailedToShowFullScreenContent: (ad, err) {
              ad.dispose();
              _isAdReady = false;
              _loadInterstitialAd();
            },
          );
          if (mounted) {
            setState(() {
              _interstitialAd = ad;
              _isAdReady = true;
            });
          }
        },
        onAdFailedToLoad: (err) {
          _isAdReady = false;
        },
      ),
    );
  }

  void _onSpeakingTap(SpeakingScenario scenario) {
    final isLocked = scenario.level != SpeakingLevel.basic;

    if (isLocked) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: AppTheme.surfaceColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          title: const Text("Cenário Bloqueado 🔒", textAlign: TextAlign.center),
          content: const Text(
            "Assista a um vídeo rápido para acessar este cenário gratuitamente!",
            textAlign: TextAlign.center,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancelar", style: TextStyle(color: Colors.white60)),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _showAdToUnlockSpeaking(scenario);
              },
              child: const Text("Assistir Vídeo", style: TextStyle(color: AppTheme.accentColor, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      );
    } else {
      _navigateToSpeaking(scenario);
    }
  }

  void _showAdToUnlockSpeaking(SpeakingScenario scenario) {
    if (_isAdReady && _interstitialAd != null) {
      _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (ad) {
          ad.dispose();
          _isAdReady = false;
          _loadInterstitialAd();
          _navigateToSpeaking(scenario);
        },
        onAdFailedToShowFullScreenContent: (ad, err) {
          ad.dispose();
          _isAdReady = false;
          _loadInterstitialAd();
          _navigateToSpeaking(scenario);
        },
      );
      _interstitialAd!.show();
    } else {
      // Fallback
      _navigateToSpeaking(scenario);
    }
  }

  void _navigateToSpeaking(SpeakingScenario scenario) {
    if (!mounted) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SpeakingConversationScreen(scenario: scenario),
      ),
    );
  }

  @override
  void dispose() {
    _interstitialAd?.dispose();
    super.dispose();
  }

  String _getLevelTitle(SpeakingLevel level) {
    switch (level) {
      case SpeakingLevel.basic:
        return "Básico";
      case SpeakingLevel.intermediate:
        return "Intermediário";
      case SpeakingLevel.advanced:
        return "Avançado";
      case SpeakingLevel.native:
        return "Nativo";
    }
  }

  Color _getLevelColor(SpeakingLevel level) {
    switch (level) {
      case SpeakingLevel.basic:
        return const Color(0xFF10B981); // Emerald
      case SpeakingLevel.intermediate:
        return const Color(0xFF3B82F6); // Blue
      case SpeakingLevel.advanced:
        return const Color(0xFFF59E0B); // Amber
      case SpeakingLevel.native:
        return const Color(0xFFEC4899); // Pink
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Prática de Conversação'),
        centerTitle: true,
        automaticallyImplyLeading: widget.showAppBarBackButton,
      ),
      body: Container(
        decoration: AppTheme.gradientBackground,
        child: Column(
          children: [
            const SizedBox(height: 16),
            _buildLevelSelector(),
            const SizedBox(height: 8),
            _buildAiPracticeCard(),
            const SizedBox(height: 8),
            Expanded(
              child: _buildScenariosList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLevelSelector() {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: SpeakingLevel.values.length,
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final level = SpeakingLevel.values[index];
          final isSelected = _selectedLevel == level;
          final color = _getLevelColor(level);

          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedLevel = level;
              });
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? color : Colors.white.withAlpha(10),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected ? Colors.white.withAlpha(50) : Colors.white.withAlpha(10),
                  width: 1.5,
                ),
                boxShadow: isSelected
                    ? [BoxShadow(color: color.withAlpha(80), blurRadius: 12, offset: const Offset(0, 4))]
                    : [],
              ),
              alignment: Alignment.center,
              child: Text(
                _getLevelTitle(level),
                style: TextStyle(
                  color: isSelected ? Colors.white : AppTheme.textSecondaryColor,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  fontSize: 15,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildScenariosList() {
    final scenarios = _filteredScenarios;

    if (scenarios.isEmpty) {
      return Center(
        child: Text(
          "Nenhum cenário cadastrado para este nível.",
          style: TextStyle(color: AppTheme.textHintColor),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.only(left: 24, right: 24, top: 8, bottom: 80),
      itemCount: scenarios.length,
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final scenario = scenarios[index];
        final levelColor = _getLevelColor(scenario.level);
        final isLocked = scenario.level != SpeakingLevel.basic;

        return GestureDetector(
          onTap: () => _onSpeakingTap(scenario),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: AppTheme.cardDecoration,
            child: Row(
              children: [
                // Icon Container
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: levelColor.withAlpha(25),
                    shape: BoxShape.circle,
                    border: Border.all(color: levelColor.withAlpha(60), width: 1.5),
                  ),
                  child: Icon(scenario.icon, color: levelColor, size: 28),
                ),
                const SizedBox(width: 20),
                // Texts
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        scenario.title,
                        style: TextStyle(
                          color: AppTheme.textColor,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        scenario.description,
                        style: TextStyle(
                          color: AppTheme.textSecondaryColor,
                          fontSize: 13,
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                ),
                // Lock / Chevron icon
                Icon(
                  isLocked ? Icons.lock_rounded : Icons.chevron_right_rounded, 
                  color: isLocked ? AppTheme.accentColor : AppTheme.textHintColor, 
                  size: 26,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildAiPracticeCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AiConversationScreen()),
          );
        },
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppTheme.primaryColor.withAlpha(20),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: AppTheme.primaryColor.withAlpha(50), width: 1.5),
            boxShadow: [
              BoxShadow(
                color: AppTheme.primaryColor.withAlpha(20),
                blurRadius: 10,
                offset: const Offset(0, 4),
              )
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.accentColor.withAlpha(25),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.psychology_rounded, color: AppTheme.accentColor, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          "Conversar com IA",
                          style: TextStyle(
                            color: AppTheme.textColor,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(Icons.auto_awesome_rounded, color: Colors.amber, size: 16),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Pratique conversação livre por texto ou áudio.",
                      style: TextStyle(
                        color: AppTheme.textSecondaryColor,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right_rounded, color: AppTheme.textHintColor, size: 26),
            ],
          ),
        ),
      ),
    );
  }
}
