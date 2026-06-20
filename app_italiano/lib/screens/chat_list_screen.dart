import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/chat_data.dart';
import 'chat_conversation_screen.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../services/ad_helper.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  List<ChatScenario> get _scenarios => chatScenarios;

  InterstitialAd? _interstitialAd;
  bool _isAdReady = false;

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

  void _onScenarioTap(int index, ChatScenario scenario) {
    final isLocked = index >= 2;

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
                _showAdToUnlock(scenario);
              },
              child: const Text("Assistir Vídeo", style: TextStyle(color: AppTheme.accentColor, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      );
    } else {
      _navigateToChat(scenario);
    }
  }

  void _showAdToUnlock(ChatScenario scenario) {
    if (_isAdReady && _interstitialAd != null) {
      _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (ad) {
          ad.dispose();
          _isAdReady = false;
          _loadInterstitialAd();
          _navigateToChat(scenario);
        },
        onAdFailedToShowFullScreenContent: (ad, err) {
          ad.dispose();
          _isAdReady = false;
          _loadInterstitialAd();
          _navigateToChat(scenario);
        },
      );
      _interstitialAd!.show();
    } else {
      // Fallback if ad is not loaded
      _navigateToChat(scenario);
    }
  }


  void _navigateToChat(ChatScenario scenario) {
    if (!mounted) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatConversationScreen(scenario: scenario),
      ),
    );
  }

  @override
  void dispose() {
    _interstitialAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Conversations'),
        centerTitle: true,
      ),
      body: Container(
        decoration: AppTheme.gradientBackground,
        child: ListView.separated(
          padding: const EdgeInsets.only(left: 24, right: 24, top: 24, bottom: 80),
          itemCount: _scenarios.length,
          separatorBuilder: (context, index) => const SizedBox(height: 16),
          itemBuilder: (context, index) {
            final scenario = _scenarios[index];
            final isLocked = index >= 2;

            return GestureDetector(
              onTap: () => _onScenarioTap(index, scenario),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: AppTheme.cardDecoration,
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryColor.withAlpha(30),
                        shape: BoxShape.circle,
                        border: Border.all(color: AppTheme.primaryColor.withAlpha(50)),
                      ),
                      child: Icon(scenario.icon, color: AppTheme.textColor, size: 32),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            scenario.title,
                            style: TextStyle(
                              color: AppTheme.textColor,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            scenario.description,
                            style: TextStyle(
                              color: AppTheme.textSecondaryColor,
                              fontSize: 14,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
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
        ),
      ),
    );
  }
}
