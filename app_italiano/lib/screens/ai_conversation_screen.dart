import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:audioplayers/audioplayers.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../config/app_config.dart';
import '../theme/app_theme.dart';
import '../services/ai_chat_service.dart';
import '../services/openai_service.dart';
import '../services/tts_helper.dart';
import '../services/sfx_helper.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../services/ad_helper.dart';
import '../services/user_service.dart';
import 'paywall_screen.dart';

class AiConversationScreen extends StatefulWidget {
  final AiTopic? initialTopic;
  const AiConversationScreen({super.key, this.initialTopic});

  @override
  State<AiConversationScreen> createState() => _AiConversationScreenState();
}

class _AiConversationScreenState extends State<AiConversationScreen> {
  AiTopic? _selectedTopic;
  final FlutterTts _flutterTts = FlutterTts();
  final stt.SpeechToText _speech = stt.SpeechToText();
  final AudioPlayer _audioPlayer = AudioPlayer();
  
  bool _useRealisticVoice = false;
  bool _isGeneratingVoice = false;
  
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  
  bool _speechAvailable = false;
  bool _isRecording = false;
  bool _isBotSpeaking = false;
  bool _isThinking = false;
  bool _showText = true;
  bool _showHintsInAudioMode = false;

  // Tutor identity – determined by selected voice gender
  String _tutorName = 'Giulia';
  bool _tutorIsMale = false;

  final List<Map<String, dynamic>> _messages = [];
  List<String> _currentHints = [];
  final Set<int> _showHintTranslationIndices = {};
  AiTopic? _levelPendingTopic;
  String? _selectedLevel;

  RewardedAd? _rewardedAd;
  bool _isRewardedAdReady = false;

  @override
  void initState() {
    super.initState();
    _loadRewardedAd();
    _initSpeech();
    _initTts();
    _audioPlayer.onPlayerStateChanged.listen((state) {
      if (mounted) {
        setState(() {
          _isBotSpeaking = state == PlayerState.playing;
        });
      }
    });
    if (widget.initialTopic != null) {
      _selectTopic(widget.initialTopic!);
    }
  }

  @override
  void dispose() {
    _rewardedAd?.dispose();
    _flutterTts.stop();
    _speech.stop();
    _audioPlayer.dispose();
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
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

  void _showRewardedAdGate({
    required String title,
    required String description,
    required VoidCallback onUnlock,
  }) {
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
                  color: AppTheme.accentColor.withAlpha(25),
                  border: Border.all(color: AppTheme.accentColor.withAlpha(80)),
                ),
                child: const Icon(Icons.lock_open_rounded, color: AppTheme.accentColor, size: 40),
              ),
              const SizedBox(height: 20),
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppTheme.textColor,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                description,
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
                        Navigator.pop(context);
                        _showRewardedAd(onUnlock: onUnlock);
                      }
                    : null,
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

  void _showRewardedAd({required VoidCallback onUnlock}) {
    if (!_isRewardedAdReady || _rewardedAd == null) {
      onUnlock();
      return;
    }

    _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        _isRewardedAdReady = false;
        _loadRewardedAd();
      },
      onAdFailedToShowFullScreenContent: (ad, err) {
        ad.dispose();
        _isRewardedAdReady = false;
        _loadRewardedAd();
        onUnlock();
      },
    );

    _rewardedAd!.show(
      onUserEarnedReward: (ad, reward) {
        onUnlock();
      },
    );
  }

  void _initSpeech() async {
    try {
      _speechAvailable = await _speech.initialize(
        onError: (val) => debugPrint('Speech onError: $val'),
        onStatus: (val) => debugPrint('Speech onStatus: $val'),
      );
      if (mounted) setState(() {});
    } catch (e) {
      debugPrint('Speech initialization failed: $e');
    }
  }

  void _initTts() async {
    await TtsHelper.initTts(_flutterTts);

    // Load tutor identity from the directly-stored preference (set in Settings → Voice)
    final storedName = await TtsHelper.getStoredTutorName();
    final storedIsMale = await TtsHelper.getStoredTutorIsMale();
    final prefs = await SharedPreferences.getInstance();
    final isPremium = UserService.currentUser.isPremium;
    final useReal = isPremium && (prefs.getBool('use_realistic_voice') ?? true);

    if (mounted) {
      setState(() {
        _tutorName = storedName;
        _tutorIsMale = storedIsMale;
        _useRealisticVoice = useReal;
      });
    }

    _flutterTts.setStartHandler(() {
      if (mounted) setState(() => _isBotSpeaking = true);
    });
    _flutterTts.setCompletionHandler(() {
      if (mounted) setState(() => _isBotSpeaking = false);
    });
    _flutterTts.setErrorHandler((msg) {
      if (mounted) setState(() => _isBotSpeaking = false);
    });
  }

  void _speak(String text, {bool isBot = false}) async {
    await _flutterTts.stop();
    await _audioPlayer.stop();

    if (isBot && _useRealisticVoice) {
      setState(() {
        _isGeneratingVoice = true;
      });

      if (!mounted) return;

      // Show temporary overlay toast
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('⚡ Gerando voz realista da OpenAI...'),
          duration: Duration(milliseconds: 1000),
          backgroundColor: Colors.indigo,
        ),
      );

      final prefs = await SharedPreferences.getInstance();
      final speed = prefs.getDouble('realistic_tts_speed') ?? 1.0;
      final String voice = RealisticVoiceConfig.getOpenAiVoiceForTutor(_tutorName, AppConfig.activeLanguage);

      final audioPath = await OpenAiService.getRealisticVoiceAudio(
        text: text,
        voice: voice,
        speed: speed,
      );

      if (mounted) {
        setState(() {
          _isGeneratingVoice = false;
        });
      }

      if (audioPath != null) {
        await _audioPlayer.play(DeviceFileSource(audioPath));
      } else {
        // Fallback to high-quality local tts configuration if OpenAI TTS fails
        await _flutterTts.setSpeechRate(0.35);
        await _flutterTts.setPitch(1.0);
        await _flutterTts.speak(text);
      }
    } else {
      await _flutterTts.speak(text);
    }
  }

  void _selectTopic(AiTopic topic) {
    if ((topic.id == 'casual' || topic.id == 'livre') && _selectedLevel == null) {
      setState(() {
        _levelPendingTopic = topic;
      });
      return;
    }
    final initialMsg = topic.getInitialMessage(_tutorName);
    setState(() {
      _selectedTopic = topic;
      _messages.clear();
      _showHintTranslationIndices.clear();
      // Add first bot message with the correct tutor name
      _messages.add({
        'isBot': true,
        'italian': initialMsg['en']!,
        'portuguese': initialMsg['pt']!,
        'showTranslation': false,
      });
      _currentHints = List.from(topic.initialHints);
    });
    
    // Speak initial message
    Future.delayed(const Duration(milliseconds: 400), () {
      _speak(initialMsg['en']!, isBot: true);
    });
    _scrollToBottom();
  }

  void _scrollToBottom() {
    // Scroll twice to ensure last message is fully visible after text layout settles
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted && _scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _sendMessage(String text) {
    if (text.trim().isEmpty) return;

    final user = UserService.currentUser;
    if (!user.isPremium) {
      final todayStr = "${DateTime.now().year}-${DateTime.now().month.toString().padLeft(2, '0')}-${DateTime.now().day.toString().padLeft(2, '0')}";
      if (user.lastMessageDate == todayStr && user.freeMessagesUsed >= 5) {
        _showLimitReachedDialog();
        return;
      }
    }

    setState(() {
      _messages.add({
        'isBot': false,
        'italian': text,
        'portuguese': '',
        'showTranslation': false,
      });
      _isThinking = true;
      _currentHints.clear();
      _showHintTranslationIndices.clear();
    });
    _textController.clear();
    _scrollToBottom();

    // Call OpenAI/Groq API for dynamic conversation
    OpenAiService.getConversationResponse(
      topicId: _selectedTopic!.id,
      topicTitle: _selectedTopic!.title,
      history: _messages,
      tutorName: _tutorName,
      isTutorMale: _tutorIsMale,
      selectedLevel: _selectedLevel,
    ).then((response) {
      if (!mounted) return;
      setState(() {
        _isThinking = false;
        _messages.add({
          'isBot': true,
          'italian': response.italian,
          'portuguese': response.portuguese,
          'showTranslation': false,
        });
        _currentHints = response.nextHints;
        _showHintTranslationIndices.clear();
      });

      // Increment free message count
      if (!user.isPremium) {
        UserService.incrementFreeMessages().then((_) {
          if (mounted) setState(() {});
        });
      }

      _speak(response.italian, isBot: true);
      _scrollToBottom();
    }).catchError((err) {
      if (!mounted) return;
      setState(() {
        _isThinking = false;
      });
      // Backend returned 403 – daily free limit reached
      if (err.toString().contains('limit_reached')) {
        _showLimitReachedDialog();
      }
    });
  }

  void _showLimitReachedDialog() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xFF1E1E2E),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: AppTheme.accentColor.withAlpha(80)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.lock_rounded,
                  color: AppTheme.accentColor,
                  size: 44,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Limite Diário Atingido',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Você enviou suas 5 mensagens gratuitas de hoje. Assine o Premium para ter conversas ilimitadas!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // Close dialog
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const PaywallScreen()),
                    ).then((_) {
                      if (mounted) setState(() {});
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.accentColor,
                    foregroundColor: Colors.black,
                    minimumSize: const Size(double.infinity, 48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Seja Premium',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    'Voltar',
                    style: TextStyle(color: Colors.white54),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showGrammarExplanation(String phrase) {
    final user = UserService.currentUser;
    if (!user.isPremium) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const PaywallScreen()),
      ).then((_) {
        if (mounted) setState(() {});
      });
      return;
    }

    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1E1E2E),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return FutureBuilder<String>(
          future: OpenAiService.getGrammarExplanation(
            phrase: phrase,
            contextTopic: _selectedTopic?.title ?? 'Geral',
          ),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Container(
                padding: const EdgeInsets.all(32),
                height: 250,
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(color: AppTheme.accentColor),
                    SizedBox(height: 20),
                    Text(
                      'Tutor analisando a gramática da frase...',
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                  ],
                ),
              );
            }

            final explanation = snapshot.data ?? 'Erro ao obter explicação.';
            return Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.school_rounded, color: AppTheme.accentColor, size: 24),
                          SizedBox(width: 8),
                          Text(
                            'Explicação Gramatical',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      IconButton(
                        icon: const Icon(Icons.close_rounded, color: Colors.white60),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(16),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white.withAlpha(5),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.white.withAlpha(10)),
                    ),
                    child: Text(
                      phrase,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Flexible(
                    child: SingleChildScrollView(
                      child: Text(
                        explanation,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _startListening() async {
    if (!_speechAvailable) {
      _speechAvailable = await _speech.initialize();
    }

    if (_speechAvailable) {
      SfxHelper.vibrateMicStart();
      setState(() => _isRecording = true);
      await _speech.listen(
        onResult: (result) {
          setState(() {
            _textController.text = result.recognizedWords;
            if (result.finalResult) {
              _isRecording = false;
            }
          });
        },
        listenOptions: stt.SpeechListenOptions(
          localeId: AppConfig.ttsLocale,
          listenFor: const Duration(seconds: 15),
          pauseFor: const Duration(seconds: 4),
        ),
      );
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Reconhecimento de fala indisponível.')),
      );
    }
  }

  void _stopListening() async {
    SfxHelper.vibrateMicStop();
    await _speech.stop();
    setState(() => _isRecording = false);
    if (_textController.text.trim().isNotEmpty) {
      _sendMessage(_textController.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasSelectedTopic = _selectedTopic != null;
    final isChoosingLevel = _levelPendingTopic != null;

    String appBarTitle = 'Conversação com IA';
    if (hasSelectedTopic) {
      String levelSuffix = '';
      if (_selectedLevel == 'basico') levelSuffix = ' (Básico)';
      if (_selectedLevel == 'intermediario') levelSuffix = ' (Intermediário)';
      if (_selectedLevel == 'avancado') levelSuffix = ' (Avançado)';
      appBarTitle = '${_selectedTopic!.title}$levelSuffix';
    } else if (isChoosingLevel) {
      appBarTitle = 'Escolha o Nível';
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(appBarTitle),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () {
            if (isChoosingLevel) {
              setState(() => _levelPendingTopic = null);
            } else if (hasSelectedTopic && widget.initialTopic == null) {
              setState(() {
                _selectedTopic = null;
                _selectedLevel = null;
              });
            } else {
              Navigator.pop(context);
            }
          },
        ),
        centerTitle: true,
      ),
      body: Container(
        decoration: AppTheme.gradientBackground,
        child: hasSelectedTopic
            ? _buildChatLayout()
            : (isChoosingLevel ? _buildLevelSelector() : _buildTopicSelector()),
      ),
    );
  }

  Widget _buildLevelSelector() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Selecione a dificuldade",
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            "Escolha o nível de vocabulário e complexidade da conversa.",
            style: TextStyle(color: AppTheme.textSecondaryColor, fontSize: 16),
          ),
          const SizedBox(height: 24),
          _buildLevelCard(
            levelId: 'basico',
            title: 'Básico 🟢',
            description: 'Vocabulário simples, frases curtas e diretas. Ideal para iniciantes.',
            icon: Icons.explore_outlined,
            color: const Color(0xFF10B981),
          ),
          const SizedBox(height: 16),
          _buildLevelCard(
            levelId: 'intermediario',
            title: 'Intermediário 🟡',
            description: 'Estruturas normais com vocabulário do dia a dia e nível moderado de desafio.',
            icon: Icons.trending_up_rounded,
            color: const Color(0xFFF59E0B),
          ),
          const SizedBox(height: 16),
          _buildLevelCard(
            levelId: 'avancado',
            title: 'Avançado 🔵',
            description: 'Conversa fluida, expressões idiomáticas e velocidade natural de fala.',
            icon: Icons.workspace_premium_rounded,
            color: const Color(0xFF6366F1),
          ),
        ],
      ),
    );
  }

  Widget _buildLevelCard({
    required String levelId,
    required String title,
    required String description,
    required IconData icon,
    required Color color,
  }) {
    final cleanTitle = title.replaceAll(RegExp(r'[^\w\sÀ-ÿ]'), '').trim();
    final isPremium = UserService.currentUser.isPremium;

    return GestureDetector(
      onTap: () {
        if (isPremium) {
          setState(() {
            _selectedLevel = levelId;
          });
          _selectTopic(_levelPendingTopic!);
          setState(() {
            _levelPendingTopic = null;
          });
        } else {
          _showRewardedAdGate(
            title: 'Nível $cleanTitle',
            description: 'Assista a um breve anúncio para desbloquear este nível gratuitamente.',
            onUnlock: () {
              setState(() {
                _selectedLevel = levelId;
              });
              _selectTopic(_levelPendingTopic!);
              setState(() {
                _levelPendingTopic = null;
              });
            },
          );
        }
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: AppTheme.cardDecoration,
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: color.withAlpha(25),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: AppTheme.textColor,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    description,
                    style: TextStyle(
                      color: AppTheme.textSecondaryColor,
                      fontSize: 13,
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),
            if (!isPremium) ...[
              const Icon(Icons.lock_rounded, color: AppTheme.accentColor, size: 20),
              const SizedBox(width: 8),
            ],
            Icon(Icons.arrow_forward_ios_rounded, color: AppTheme.textHintColor, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildTopicSelector() {
    final isPremium = UserService.currentUser.isPremium;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Escolha um tema",
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            "Pratique conversação livre em italiano com nossa inteligência artificial inteligente.",
            style: TextStyle(color: AppTheme.textSecondaryColor, fontSize: 16),
          ),
          const SizedBox(height: 24),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: AiChatService.topics.length,
            separatorBuilder: (context, index) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              final topic = AiChatService.topics[index];
              final isLocked = !isPremium && topic.id != 'casual' && topic.id != 'livre';
              return GestureDetector(
                onTap: () {
                  if (isLocked) {
                    _showRewardedAdGate(
                      title: topic.title,
                      description: 'Assista a um breve anúncio para desbloquear esta conversa gratuitamente.',
                      onUnlock: () => _selectTopic(topic),
                    );
                  } else {
                    _selectTopic(topic);
                  }
                },
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: AppTheme.cardDecoration,
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryColor.withAlpha(25),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(topic.icon, color: AppTheme.primaryColor, size: 28),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              topic.title,
                              style: TextStyle(
                                color: AppTheme.textColor,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              topic.description,
                              style: TextStyle(
                                color: AppTheme.textSecondaryColor,
                                fontSize: 13,
                                height: 1.3,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (isLocked) ...[
                        const Icon(Icons.lock_rounded, color: AppTheme.accentColor, size: 20),
                        const SizedBox(width: 8),
                      ],
                      Icon(Icons.arrow_forward_ios_rounded, color: AppTheme.textHintColor, size: 20),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildChatLayout() {
    return Column(
      children: [
        if (_showText) ...[
          _buildTutorHeader(),
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              itemCount: _messages.length + (_isThinking ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == _messages.length && _isThinking) {
                  return _buildThinkingBubble();
                }
                final msg = _messages[index];
                return _buildMessageBubble(msg, index);
              },
            ),
          ),
          _buildHintsBar(),
          _buildKeyboardInputArea(),
        ] else ...[
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: TutorPulseAvatar(
                    isSpeaking: _isBotSpeaking,
                    isThinking: _isThinking,
                    isRecording: _isRecording,
                    isMale: _tutorIsMale,
                    size: 240,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  _tutorName,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _isThinking
                      ? 'Pensando...'
                      : (_isRecording ? 'Escutando...' : (_isBotSpeaking ? 'Falando...' : 'Online')),
                  style: TextStyle(
                    color: _isThinking 
                        ? Colors.amber 
                        : (_isRecording ? Colors.redAccent : (_isBotSpeaking ? AppTheme.accentColor : Colors.greenAccent)),
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24),
                DynamicWaveform(
                  isAnimating: _isBotSpeaking || _isRecording,
                  color: _isRecording 
                      ? Colors.redAccent 
                      : (_isBotSpeaking ? AppTheme.accentColor : (_isThinking ? Colors.amber : Colors.greenAccent)),
                  barCount: 15,
                  maxBarHeight: 45,
                ),
              ],
            ),
          ),
          if (_showHintsInAudioMode) _buildHintsBar(),
        ],
        _buildBottomVoiceArea(),
      ],
    );
  }

  Widget _buildTutorHeader() {
    final user = UserService.currentUser;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      decoration: AppTheme.cardDecoration,
      child: Row(
        children: [
          TutorPulseAvatar(
            isSpeaking: _isBotSpeaking || _isGeneratingVoice,
            isThinking: _isThinking || _isGeneratingVoice,
            isRecording: _isRecording,
            isMale: _tutorIsMale,
            size: 60,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Text(
                      _tutorName,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                    if (user.isPremium) ...[
                      const SizedBox(width: 6),
                      const Icon(Icons.workspace_premium_rounded, color: AppTheme.accentColor, size: 18),
                    ],
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: _isGeneratingVoice
                            ? Colors.blueAccent
                            : (_isThinking 
                                ? Colors.amber 
                                : (_isRecording ? Colors.redAccent : (_isBotSpeaking ? AppTheme.accentColor : Colors.greenAccent))),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _isGeneratingVoice
                          ? 'Voz Realista...'
                          : (_isThinking
                              ? 'Pensando...'
                              : (_isRecording ? 'Escutando...' : (_isBotSpeaking ? 'Falando...' : 'Online'))),
                      style: TextStyle(
                        color: _isGeneratingVoice
                            ? Colors.blueAccent
                            : (_isThinking 
                                ? Colors.amber 
                                : (_isRecording ? Colors.redAccent : (_isBotSpeaking ? AppTheme.accentColor : Colors.greenAccent))),
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          DynamicWaveform(
            isAnimating: _isBotSpeaking || _isRecording || _isGeneratingVoice,
            color: _isRecording 
                ? Colors.redAccent 
                : (_isBotSpeaking ? AppTheme.accentColor : (_isThinking ? Colors.amber : Colors.greenAccent)),
            barCount: 9,
            maxBarHeight: 24,
          ),
          const SizedBox(width: 8),
          // Voice Toggle button
          IconButton(
            icon: Icon(
              _useRealisticVoice ? Icons.record_voice_over_rounded : Icons.record_voice_over_outlined,
              color: _useRealisticVoice ? AppTheme.accentColor : AppTheme.textHintColor,
            ),
            tooltip: 'Voz Realista',
            onPressed: () async {
              if (!user.isPremium) {
                // If not premium, redirect to paywall
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const PaywallScreen()),
                ).then((_) {
                  if (mounted) setState(() {});
                });
              } else {
                setState(() {
                  _useRealisticVoice = !_useRealisticVoice;
                });
                final prefs = await SharedPreferences.getInstance();
                await prefs.setBool('use_realistic_voice', _useRealisticVoice);
                if (!mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      _useRealisticVoice
                          ? 'Voz realista ativada! 🎙️'
                          : 'Voz realista desativada (usando voz local).',
                    ),
                    duration: const Duration(seconds: 1),
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(Map<String, dynamic> msg, int index) {
    final isBot = msg['isBot'] as bool;
    final showTrans = msg['showTranslation'] as bool;

    return Align(
      alignment: isBot ? Alignment.centerLeft : Alignment.centerRight,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.78),
        decoration: BoxDecoration(
          color: isBot ? Colors.white.withAlpha(15) : AppTheme.primaryColor.withAlpha(90),
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(24),
            topRight: const Radius.circular(24),
            bottomLeft: Radius.circular(isBot ? 0 : 24),
            bottomRight: Radius.circular(isBot ? 24 : 0),
          ),
          border: Border.all(
            color: isBot ? Colors.white.withAlpha(30) : AppTheme.primaryColor,
          ),
        ),
        child: Column(
          crossAxisAlignment: isBot ? CrossAxisAlignment.start : CrossAxisAlignment.end,
          children: [
            Text(
              msg['italian'] ?? '',
              style: TextStyle(color: AppTheme.textColor, fontSize: 17, fontWeight: FontWeight.bold),
            ),
            if (isBot && showTrans) ...[
              const SizedBox(height: 8),
              Text(
                msg['portuguese'] ?? '',
                style: TextStyle(color: AppTheme.textSecondaryColor, fontSize: 14, fontStyle: FontStyle.italic),
              ),
            ],
            const SizedBox(height: 8),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (isBot) ...[
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _messages[index]['showTranslation'] = !showTrans;
                      });
                    },
                    child: Icon(
                      Icons.translate_rounded,
                      color: showTrans ? AppTheme.accentColor : AppTheme.textHintColor,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 16),
                ],
                GestureDetector(
                  onTap: () => _speak(msg['italian'] ?? '', isBot: isBot),
                  child: Icon(
                    Icons.volume_up_rounded,
                    color: isBot ? AppTheme.accentColor : Colors.white.withAlpha(160),
                    size: 20,
                  ),
                ),
                const SizedBox(width: 16),
                GestureDetector(
                  onTap: () => _showGrammarExplanation(msg['italian'] ?? ''),
                  child: Icon(
                    Icons.school_rounded,
                    color: isBot ? AppTheme.accentColor : Colors.white.withAlpha(160),
                    size: 20,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildThinkingBubble() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white.withAlpha(10),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
        child: const SizedBox(
          width: 24,
          height: 12,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _DotAnimation(delay: 0),
              _DotAnimation(delay: 150),
              _DotAnimation(delay: 300),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHintsBar() {
    if (_currentHints.isEmpty || _isThinking) return const SizedBox.shrink();

    return Container(
      height: 48,
      margin: const EdgeInsets.only(bottom: 8),
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        scrollDirection: Axis.horizontal,
        itemCount: _currentHints.length,
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final hint = _currentHints[index];
          final parts = hint.split('|');
          final italianText = parts[0];
          final portugueseText = parts.length > 1 ? parts[1] : '';

          final isToggled = _showHintTranslationIndices.contains(index);
          final textToShow = isToggled && portugueseText.isNotEmpty ? portugueseText : italianText;

          return Container(
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withAlpha(25),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: AppTheme.primaryColor.withAlpha(60)),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Loudspeaker Icon to listen pronunciation
                GestureDetector(
                  onTap: () => _speak(italianText),
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    child: const Icon(
                      Icons.volume_up_rounded,
                      color: AppTheme.accentColor,
                      size: 18,
                    ),
                  ),
                ),
                if (portugueseText.isNotEmpty) ...[
                  const SizedBox(width: 4),
                  // Translation Icon to toggle translation
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        if (isToggled) {
                          _showHintTranslationIndices.remove(index);
                        } else {
                          _showHintTranslationIndices.add(index);
                        }
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      child: Icon(
                        Icons.translate_rounded,
                        color: isToggled ? AppTheme.accentColor : AppTheme.textHintColor,
                        size: 16,
                      ),
                    ),
                  ),
                ],
                const SizedBox(width: 6),
                // Text selection
                GestureDetector(
                  onTap: () {
                    _textController.text = italianText;
                    _scrollToBottom();
                  },
                  child: Text(
                    textToShow,
                    style: TextStyle(
                      color: isToggled ? AppTheme.textSecondaryColor : AppTheme.textColor,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      fontStyle: isToggled ? FontStyle.italic : FontStyle.normal,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildKeyboardInputArea() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withAlpha(10),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Colors.white.withAlpha(15)),
              ),
              child: TextField(
                controller: _textController,
                style: TextStyle(color: AppTheme.textColor, fontSize: 15),
                decoration: InputDecoration(
                  hintText: _isRecording ? '$_tutorName está ouvindo...' : 'Digite em italiano...',
                  hintStyle: TextStyle(color: AppTheme.textHintColor),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  border: InputBorder.none,
                ),
                onSubmitted: _sendMessage,
              ),
            ),
          ),
          const SizedBox(width: 12),
          GestureDetector(
            onTap: () => _sendMessage(_textController.text),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: const BoxDecoration(
                color: AppTheme.accentColor,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.send_rounded,
                color: Colors.black,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomVoiceArea() {
    return Container(
      padding: const EdgeInsets.only(top: 12, bottom: 24),
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border(top: BorderSide(color: Colors.white.withAlpha(10))),
      ),
      child: SafeArea(
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Left Side: Keyboard Visibility Toggle Button
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 32),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _showText = !_showText;
                      if (_showText) {
                        _showHintsInAudioMode = false;
                      }
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withAlpha(10),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white.withAlpha(20)),
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Icon(
                          Icons.keyboard_rounded,
                          color: _showText ? AppTheme.textColor : AppTheme.textColor.withAlpha(100),
                          size: 24,
                        ),
                        if (!_showText)
                          Positioned(
                            right: -2,
                            bottom: -2,
                            child: Container(
                              padding: const EdgeInsets.all(1),
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.close_rounded,
                                color: Colors.white,
                                size: 11,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // Microphone Button in the Center
            GestureDetector(
              onTap: _isRecording ? _stopListening : _startListening,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: 76,
                    height: 76,
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: _isRecording ? Colors.redAccent : AppTheme.primaryColor,
                        width: 3,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: (_isRecording ? Colors.redAccent : AppTheme.primaryColor).withAlpha(40),
                          blurRadius: _isRecording ? 24 : 12,
                          spreadRadius: _isRecording ? 4 : 1,
                        ),
                      ],
                    ),
                    child: Icon(
                      _isRecording ? Icons.mic_off_rounded : Icons.mic_rounded,
                      color: _isRecording ? Colors.redAccent : AppTheme.accentColor,
                      size: 36,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    _isRecording ? 'Toque para Enviar' : 'Pressione para Falar',
                    style: TextStyle(
                      color: _isRecording ? Colors.redAccent : AppTheme.textColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            
            // Right Side: Hints Visibility Toggle Button (Lightbulb)
            if (!_showText)
              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 32),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _showHintsInAudioMode = !_showHintsInAudioMode;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withAlpha(10),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white.withAlpha(20)),
                      ),
                      child: Icon(
                        Icons.lightbulb_outline_rounded,
                        color: _showHintsInAudioMode ? Colors.amber : AppTheme.textColor.withAlpha(100),
                        size: 24,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// Technological pulsing audio avatar widget
class TutorPulseAvatar extends StatefulWidget {
  final bool isSpeaking;
  final bool isThinking;
  final bool isRecording;
  final bool isMale;
  final double size;

  const TutorPulseAvatar({
    super.key,
    required this.isSpeaking,
    required this.isThinking,
    required this.isRecording,
    this.isMale = false,
    this.size = 130,
  });

  @override
  State<TutorPulseAvatar> createState() => _TutorPulseAvatarState();
}

class _TutorPulseAvatarState extends State<TutorPulseAvatar> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Color baseColor = AppTheme.primaryColor;
    if (widget.isThinking) {
      baseColor = Colors.amber;
    } else if (widget.isRecording) {
      baseColor = Colors.redAccent;
    } else if (widget.isSpeaking) {
      baseColor = AppTheme.accentColor;
    }

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return SizedBox(
          width: widget.size,
          height: widget.size,
          child: Stack(
            alignment: Alignment.center,
            children: [
              ...List.generate(3, (index) {
                final delay = index * 0.33;
                double progress = _controller.value - delay;
                if (progress < 0) progress += 1.0;

                final scale = 0.8 + (progress * 0.7);
                final opacity = (1.0 - progress).clamp(0.0, 1.0);

                return Transform.scale(
                  scale: scale,
                  child: Opacity(
                    opacity: opacity * (widget.isSpeaking || widget.isRecording ? 0.6 : 0.25),
                    child: Container(
                      width: widget.size * 0.615,
                      height: widget.size * 0.615,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: baseColor.withAlpha(20),
                        border: Border.all(
                          color: baseColor, 
                          width: widget.isSpeaking ? 1.5 : 0.8,
                          style: BorderStyle.solid
                        ),
                      ),
                    ),
                  ),
                );
              }),

              ...List.generate(6, (index) {
                final double angle = (index * 60) * (3.14159 / 180);
                final double offsetDistance = (widget.size * 0.354) + (widget.size * 0.077) * (widget.isSpeaking || widget.isRecording 
                    ? (0.5 * (1 + (index % 2 == 0 ? _controller.value : 1 - _controller.value)))
                    : 0.0);
                
                return Transform.translate(
                  offset: Offset(
                    offsetDistance * math.cos(angle),
                    offsetDistance * math.sin(angle),
                  ),
                  child: Container(
                    width: widget.isSpeaking || widget.isRecording ? (widget.size * 0.046) : (widget.size * 0.03),
                    height: widget.isSpeaking || widget.isRecording ? (widget.size * 0.046) : (widget.size * 0.03),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: baseColor.withAlpha(200),
                    ),
                  ),
                );
              }),

              Container(
                width: widget.size * 0.615,
                height: widget.size * 0.615,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      baseColor,
                      baseColor.withAlpha(120),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: baseColor.withAlpha(120),
                      blurRadius: widget.size * 0.123,
                      spreadRadius: widget.size * 0.015,
                    ),
                  ],
                ),
                child: Icon(
                  widget.isMale
                      ? Icons.face_6_rounded
                      : Icons.face_retouching_natural_rounded,
                  color: Colors.white,
                  size: widget.size * 0.307,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _DotAnimation extends StatefulWidget {
  final int delay;
  const _DotAnimation({required this.delay});

  @override
  State<_DotAnimation> createState() => _DotAnimationState();
}

class _DotAnimationState extends State<_DotAnimation> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    Future.delayed(Duration(milliseconds: widget.delay), () {
      if (mounted) {
        _controller.repeat(reverse: true);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, -6 * _animation.value),
          child: Container(
            width: 6,
            height: 6,
            decoration: const BoxDecoration(
              color: Colors.white60,
              shape: BoxShape.circle,
            ),
          ),
        );
      },
    );
  }
}

// Custom Waveform Animation Widget for active conversation audio simulation
class DynamicWaveform extends StatefulWidget {
  final bool isAnimating;
  final Color color;
  final int barCount;
  final double maxBarHeight;

  const DynamicWaveform({
    super.key,
    required this.isAnimating,
    required this.color,
    this.barCount = 9,
    this.maxBarHeight = 30.0,
  });

  @override
  State<DynamicWaveform> createState() => _DynamicWaveformState();
}

class _DynamicWaveformState extends State<DynamicWaveform> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    if (widget.isAnimating) {
      _controller.repeat();
    }
  }

  @override
  void didUpdateWidget(covariant DynamicWaveform oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isAnimating && !_controller.isAnimating) {
      _controller.repeat();
    } else if (!widget.isAnimating && _controller.isAnimating) {
      _controller.stop();
      _controller.value = 0.0;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: List.generate(widget.barCount, (index) {
            double value = 0.0;
            if (widget.isAnimating) {
              final double angle = (_controller.value * 2 * math.pi) + (index * math.pi / 4);
              value = (math.sin(angle).abs() * 0.7) + 0.3;
            } else {
              value = 0.15;
            }

            final barHeight = widget.maxBarHeight * value;

            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 2.0),
              width: 3.5,
              height: barHeight,
              decoration: BoxDecoration(
                color: widget.color.withAlpha((255 * (value * 0.6 + 0.4)).toInt()),
                borderRadius: BorderRadius.circular(4.0),
              ),
            );
          }),
        );
      },
    );
  }
}
