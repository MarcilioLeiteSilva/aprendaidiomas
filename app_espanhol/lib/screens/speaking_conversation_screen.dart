import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import '../theme/app_theme.dart';
import '../models/speaking_data.dart';
import '../services/tts_helper.dart';
import '../config/app_config.dart';
import '../services/user_service.dart';

class SpeakingConversationScreen extends StatefulWidget {
  final SpeakingScenario scenario;
  const SpeakingConversationScreen({super.key, required this.scenario});

  @override
  State<SpeakingConversationScreen> createState() => _SpeakingConversationScreenState();
}

class _SpeakingConversationScreenState extends State<SpeakingConversationScreen> {
  final FlutterTts flutterTts = FlutterTts();
  final stt.SpeechToText _speech = stt.SpeechToText();
  bool _speechAvailable = false;
  String _recognizedText = '';
  double? _lastScore;
  final Map<int, double> _userScores = {};

  int _currentStep = 0;
  bool _isBotSpeaking = false;
  bool _isUserRecording = false;

  @override
  void initState() {
    super.initState();
    _initTts();
    _initSpeech();
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
    await TtsHelper.initTts(flutterTts);

    // Audio lifecycle handlers to sync the pulsing animation
    flutterTts.setStartHandler(() {
      if (mounted) {
        setState(() => _isBotSpeaking = true);
      }
    });

    flutterTts.setCompletionHandler(() {
      if (mounted) {
        setState(() => _isBotSpeaking = false);
      }
    });

    flutterTts.setErrorHandler((msg) {
      if (mounted) {
        setState(() => _isBotSpeaking = false);
      }
    });

    // Auto-start first message if it's the bot's turn
    _triggerCurrentStep();
  }

  void _speak(String text, {bool isBot = false}) async {
    await flutterTts.stop();
    await flutterTts.speak(text);
  }

  void _triggerCurrentStep() {
    if (_currentStep >= widget.scenario.messages.length) return;
    
    final msg = widget.scenario.messages[_currentStep];
    if (msg.isBot) {
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) {
          _speak(msg.en, isBot: true);
        }
      });
    }
  }

  double _calculateSimilarity(String spoken, String expected) {
    final spokenWords = spoken
        .toLowerCase()
        .replaceAll(RegExp(r"[^\w\s']"), '')
        .split(RegExp(r'\s+'))
        .where((w) => w.isNotEmpty)
        .toList();
    final expectedWords = expected
        .toLowerCase()
        .replaceAll(RegExp(r"[^\w\s']"), '')
        .split(RegExp(r'\s+'))
        .where((w) => w.isNotEmpty)
        .toList();

    if (expectedWords.isEmpty) return 0.0;

    int matchCount = 0;
    for (var word in expectedWords) {
      if (spokenWords.contains(word)) {
        matchCount++;
        spokenWords.remove(word);
      }
    }
    return matchCount / expectedWords.length;
  }

  void _evaluateSpeech(String spoken) {
    if (spoken.isEmpty) return;
    final expected = widget.scenario.messages[_currentStep].en;
    final similarity = _calculateSimilarity(spoken, expected);
    setState(() {
      _lastScore = similarity;
      _userScores[_currentStep] = similarity;
    });
  }

  void _startListening() async {
    if (!_speechAvailable) {
      _speechAvailable = await _speech.initialize();
    }

    if (_speechAvailable) {
      setState(() {
        _isUserRecording = true;
        _recognizedText = '';
        _lastScore = null;
      });

      await _speech.listen(
        onResult: (result) {
          setState(() {
            _recognizedText = result.recognizedWords;
            if (result.finalResult) {
              _isUserRecording = false;
              _evaluateSpeech(_recognizedText);
            }
          });
        },
        listenOptions: stt.SpeechListenOptions(
          localeId: AppConfig.ttsLocale,
          listenFor: const Duration(seconds: 10),
          pauseFor: const Duration(seconds: 3),
        ),
      );
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Reconhecimento de fala indisponível ou permissão negada.')),
        );
      }
    }
  }

  void _stopListening() async {
    await _speech.stop();
    setState(() {
      _isUserRecording = false;
    });
    _evaluateSpeech(_recognizedText);
  }

  void _handleUserAction() {
    final msg = widget.scenario.messages[_currentStep];

    if (msg.isBot) {
      _speak(msg.en, isBot: true);
    } else {
      if (_isUserRecording) {
        _stopListening();
      } else {
        _startListening();
      }
    }
  }

  void _nextStep() {
    if (_isUserRecording) {
      _speech.stop();
    }
    setState(() {
      _currentStep++;
      _recognizedText = '';
      _lastScore = null;
      _isUserRecording = false;
    });
    if (_currentStep >= widget.scenario.messages.length) {
      UserService.addXp(50);
      UserService.updateStreak();
    } else {
      _triggerCurrentStep();
    }
  }

  double _getAverageScore() {
    final userTurnIndices = <int>[];
    for (int i = 0; i < widget.scenario.messages.length; i++) {
      if (!widget.scenario.messages[i].isBot) {
        userTurnIndices.add(i);
      }
    }
    
    if (userTurnIndices.isEmpty) return 0.0;
    
    double totalScore = 0.0;
    int count = 0;
    for (var idx in userTurnIndices) {
      if (_userScores.containsKey(idx)) {
        totalScore += _userScores[idx]!;
        count++;
      }
    }
    
    return count > 0 ? totalScore / count : 0.0;
  }

  @override
  void dispose() {
    flutterTts.stop();
    _speech.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isFinished = _currentStep >= widget.scenario.messages.length;
    final currentMsg = isFinished ? null : widget.scenario.messages[_currentStep];
    final isBotTurn = currentMsg?.isBot ?? false;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.scenario.title),
        centerTitle: true,
      ),
      body: Container(
        decoration: AppTheme.gradientBackground,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8), // Reduced vertical padding
          child: Column(
            children: [
              const SizedBox(height: 8), // Reduced from 20
              Center(
                child: PulsingSoundWave(
                  isSpeaking: _isBotSpeaking || _isUserRecording,
                ),
              ),
              const SizedBox(height: 16), // Reduced from 30
              Expanded(
                child: isFinished ? _buildFinishedCard() : _buildDialogueCard(currentMsg!, isBotTurn),
              ),
              _buildBottomControls(isFinished, isBotTurn),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDialogueCard(SpeakingMessage msg, bool isBotTurn) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16), // Slightly reduced padding
      decoration: AppTheme.cardDecoration,
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  isBotTurn ? Icons.volume_up_rounded : Icons.record_voice_over_rounded,
                  color: isBotTurn ? AppTheme.primaryColor : AppTheme.accentColor,
                ),
                const SizedBox(width: 8),
                Text(
                  isBotTurn ? "Ouça o falante:" : "Sua vez de falar:",
                  style: TextStyle(
                    color: AppTheme.textSecondaryColor,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Text(
                    msg.en,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppTheme.textColor,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      height: 1.3,
                    ),
                  ),
                ),
                if (!isBotTurn) ...[
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.lightbulb_rounded, color: AppTheme.accentColor, size: 28),
                    onPressed: () => _speak(msg.en),
                    tooltip: "Ouvir pronúncia esperada",
                  ),
                ],
              ],
            ),
            const SizedBox(height: 12),
            Text(
              msg.pt,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppTheme.textSecondaryColor,
                fontSize: 16,
                fontStyle: FontStyle.italic,
              ),
            ),
            if (!isBotTurn) ...[
              const SizedBox(height: 20),
              if (_recognizedText.isNotEmpty) ...[
                Text(
                  "Você disse:",
                  style: TextStyle(color: AppTheme.textHintColor, fontSize: 13),
                ),
                const SizedBox(height: 6),
                Text(
                  "\"$_recognizedText\"",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: AppTheme.accentColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                if (_lastScore != null)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: _lastScore! >= 0.7 
                          ? Colors.green.withAlpha(30) 
                          : (_lastScore! >= 0.4 ? Colors.amber.withAlpha(30) : Colors.red.withAlpha(30)),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: _lastScore! >= 0.7 
                            ? Colors.green 
                            : (_lastScore! >= 0.4 ? Colors.amber : Colors.red),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      "Precisão: ${(_lastScore! * 100).toStringAsFixed(0)}%",
                      style: TextStyle(
                        color: _lastScore! >= 0.7 
                            ? Colors.green 
                            : (_lastScore! >= 0.4 ? Colors.amber : Colors.redAccent),
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
              ] else if (_isUserRecording) ...[
                const SizedBox(height: 8),
                const Text(
                  "Escutando... Fale agora em espanhol.",
                  style: TextStyle(
                    color: AppTheme.accentColor,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ] else ...[
                const SizedBox(height: 8),
                Text(
                  "Pressione o microfone para falar",
                  style: TextStyle(
                    color: AppTheme.textHintColor,
                    fontSize: 14,
                  ),
                ),
              ],
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildFinishedCard() {
    final avgScore = _getAverageScore();
    final percentage = (avgScore * 100).toStringAsFixed(0);
    
    String feedbackMessage = "Excelente trabalho praticando sua pronúncia.";
    IconData feedbackIcon = Icons.check_circle_rounded;
    Color feedbackColor = AppTheme.accentColor;

    if (avgScore >= 0.8) {
      feedbackMessage = "Incrível! Sua pronúncia está digna de um nativo! 🌟";
      feedbackIcon = Icons.stars_rounded;
      feedbackColor = Colors.green;
    } else if (avgScore >= 0.5) {
      feedbackMessage = "Muito bom! Com mais um pouco de treino você chega lá! 📚";
      feedbackIcon = Icons.thumb_up_rounded;
      feedbackColor = Colors.amber;
    } else {
      feedbackMessage = "Bom treino! Continue praticando para melhorar sua pronúncia! 💪";
      feedbackIcon = Icons.fitness_center_rounded;
      feedbackColor = AppTheme.primaryColor;
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: AppTheme.cardDecoration,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: feedbackColor.withAlpha(30),
              shape: BoxShape.circle,
            ),
            child: Icon(feedbackIcon, color: feedbackColor, size: 64),
          ),
          const SizedBox(height: 24),
          Text(
            "Cenário Concluído!",
            style: TextStyle(
              color: AppTheme.textColor,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            "Precisão Média",
            style: TextStyle(
              color: AppTheme.textSecondaryColor,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "$percentage%",
            style: TextStyle(
              color: feedbackColor,
              fontSize: 48,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            feedbackMessage,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppTheme.textSecondaryColor,
              fontSize: 14,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            "+50 XP obtidos! 🌟",
            style: TextStyle(
              color: AppTheme.accentColor,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomControls(bool isFinished, bool isBotTurn) {
    if (isFinished) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 24),
        child: ElevatedButton(
          onPressed: () => Navigator.pop(context),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.accentColor,
            foregroundColor: Colors.black,
            minimumSize: const Size(double.infinity, 56),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
            elevation: 4,
          ),
          child: const Text(
            "Voltar para Cenários",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Passo ${_currentStep + 1} de ${widget.scenario.messages.length}",
            style: TextStyle(color: AppTheme.textHintColor, fontSize: 13),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GestureDetector(
                onTap: () {
                  final msg = widget.scenario.messages[_currentStep];
                  _speak(msg.en, isBot: msg.isBot);
                },
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withAlpha(10),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white.withAlpha(20)),
                  ),
                  child: Icon(Icons.replay_rounded, color: AppTheme.textColor, size: 28),
                ),
              ),
              GestureDetector(
                onTap: _handleUserAction,
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: isBotTurn ? AppTheme.primaryColor : AppTheme.accentColor,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: (isBotTurn ? AppTheme.primaryColor : AppTheme.accentColor).withAlpha(100),
                        blurRadius: 20,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  alignment: Alignment.center,
                  child: _isUserRecording
                      ? const SizedBox(
                          width: 32,
                          height: 32,
                          child: CircularProgressIndicator(color: Colors.black, strokeWidth: 3),
                        )
                      : Icon(
                          isBotTurn ? Icons.volume_up_rounded : Icons.mic_rounded,
                          color: Colors.black,
                          size: 36,
                        ),
                ),
              ),
              GestureDetector(
                onTap: _nextStep,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withAlpha(10),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white.withAlpha(20)),
                  ),
                  child: Icon(
                    isBotTurn ? Icons.skip_next_rounded : Icons.arrow_forward_rounded, 
                    color: AppTheme.textColor, 
                    size: 28,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// concentric sound wave animation widget
class PulsingSoundWave extends StatefulWidget {
  final bool isSpeaking;
  const PulsingSoundWave({super.key, required this.isSpeaking});

  @override
  State<PulsingSoundWave> createState() => _PulsingSoundWaveState();
}

class _PulsingSoundWaveState extends State<PulsingSoundWave> with SingleTickerProviderStateMixin {
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
    final baseColor = widget.isSpeaking ? AppTheme.accentColor : AppTheme.primaryColor;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return SizedBox(
          height: 130, // Reduced from 180
          width: 130, // Reduced from 180
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Concentric waves
              ...List.generate(3, (index) {
                final delay = index * 0.33;
                double progress = _controller.value - delay;
                if (progress < 0) progress += 1.0;

                final scale = 0.5 + (progress * 1.1); // Scaled down from 0.4 + (progress * 1.8)
                final opacity = (1.0 - progress).clamp(0.0, 1.0);

                return Transform.scale(
                  scale: scale,
                  child: Opacity(
                    opacity: opacity * (widget.isSpeaking ? 0.7 : 0.3),
                    child: Container(
                      width: 56, // Reduced from 70
                      height: 56, // Reduced from 70
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: baseColor.withAlpha(50),
                        border: Border.all(color: baseColor, width: 2),
                      ),
                    ),
                  ),
                );
              }),
              // Center circle
              Container(
                width: 56, // Reduced from 70
                height: 56, // Reduced from 70
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: baseColor,
                  boxShadow: [
                    BoxShadow(
                      color: baseColor.withAlpha(100),
                      blurRadius: 12,
                      offset: const Offset(0, 3),
                    )
                  ],
                ),
                child: Icon(
                  widget.isSpeaking ? Icons.volume_up_rounded : Icons.headset_rounded,
                  color: Colors.black,
                  size: 26, // Reduced from 32
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
