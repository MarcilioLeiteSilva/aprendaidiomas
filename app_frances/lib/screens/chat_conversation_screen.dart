import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/chat_data.dart';
import 'package:flutter_tts/flutter_tts.dart';
import '../services/tts_helper.dart';
import 'dart:async';

class ChatConversationScreen extends StatefulWidget {
  final ChatScenario scenario;

  const ChatConversationScreen({super.key, required this.scenario});

  @override
  State<ChatConversationScreen> createState() => _ChatConversationScreenState();
}

class _ChatConversationScreenState extends State<ChatConversationScreen> {
  final FlutterTts flutterTts = FlutterTts();
  final List<Map<String, dynamic>> _visibleMessages = [];
  final ScrollController _scrollController = ScrollController();
  int _currentStep = 0;
  bool _isUserTurn = false;
  bool _isRecording = false;
  bool _isBotSpeaking = false;
  bool _isSpeakingHint = false;

  String _tutorName = 'Camille';
  bool _isTutorMale = false;

  @override
  void initState() {
    super.initState();
    TtsHelper.getStoredTutorName().then((name) {
      if (mounted) {
        setState(() {
          _tutorName = name;
        });
      }
    });
    TtsHelper.getStoredTutorIsMale().then((isMale) {
      if (mounted) {
        setState(() {
          _isTutorMale = isMale;
        });
      }
    });
    _initTts().then((_) {
      if (mounted) {
        _triggerNextStep();
      }
    });
  }

  @override
  void dispose() {
    flutterTts.stop();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
    // Multi-phase scroll trigger: handles keyboard/view adjustments after layout settling
    Future.delayed(const Duration(milliseconds: 150), () {
      if (mounted && _scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _initTts() async {
    await TtsHelper.initTts(flutterTts);

    flutterTts.setStartHandler(() {
      if (mounted && !_isSpeakingHint) {
        Future.delayed(const Duration(milliseconds: 150), () {
          if (mounted && !_isSpeakingHint) {
            setState(() {
              _isBotSpeaking = true;
            });
          }
        });
      }
    });

    flutterTts.setCompletionHandler(() {
      if (mounted) {
        setState(() {
          _isBotSpeaking = false;
          _isSpeakingHint = false;
        });
      }
    });

    flutterTts.setErrorHandler((msg) {
      if (mounted) {
        setState(() {
          _isBotSpeaking = false;
          _isSpeakingHint = false;
        });
      }
    });
  }

  void _speak(String text, {bool isHint = false}) async {
    _isSpeakingHint = isHint;
    await flutterTts.speak(text);
  }

  void _triggerNextStep() {
    if (_currentStep >= widget.scenario.messages.length) return;

    final nextMessage = widget.scenario.messages[_currentStep];
    final isBot = nextMessage['isBot'] as bool;

    if (isBot) {
      // Bot's turn: Reveal message and speak
      setState(() {
        _visibleMessages.add(nextMessage);
        _currentStep++;
        _isUserTurn = true; // Next should be user's turn
      });
      _speak(nextMessage['en']!);
      _scrollToBottom();
    }
  }

  void _handleUserRecording() {
    if (_currentStep >= widget.scenario.messages.length) return;

    // TODO: In a real STT, we would start listening here.
    // For now, we simulate user "saying" the phrase by pressing the microphone.
    setState(() {
      _isRecording = true;
    });

    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _isRecording = false;
        _visibleMessages.add(widget.scenario.messages[_currentStep]);
        _currentStep++;
        _isUserTurn = false;
      });
      _scrollToBottom();

      // After user answers, bot triggers its next phrase
      Future.delayed(const Duration(milliseconds: 1000), () {
        _triggerNextStep();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.scenario.title),
        backgroundColor: AppTheme.backgroundColor,
      ),
      body: Container(
        decoration: AppTheme.gradientBackground,
        child: Column(
          children: [
            _buildTutorCard(),
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.only(left: 20, right: 20, top: 12, bottom: 32),
                itemCount: _visibleMessages.length + (_currentStep >= widget.scenario.messages.length ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == _visibleMessages.length) {
                    return _buildConcluirButton();
                  }

                  final msg = _visibleMessages[index];
                  final isBot = msg['isBot'] as bool;

                  return _buildMessageBubble(
                    textEn: msg['en']!,
                    textPt: msg['pt']!,
                    isBot: isBot,
                  );
                },
              ),
            ),
            _buildActionBottom(),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageBubble({required String textEn, required String textPt, required bool isBot}) {
    return Align(
      alignment: isBot ? Alignment.centerLeft : Alignment.centerRight,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
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
              textEn,
              style: TextStyle(
                color: AppTheme.textColor,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              textPt,
              style: TextStyle(
                color: AppTheme.textSecondaryColor,
                fontSize: 14,
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: 12),
            GestureDetector(
              onTap: () => _speak(textEn, isHint: !isBot),
              child: Icon(
                Icons.volume_up_rounded,
                color: isBot ? AppTheme.accentColor : Colors.white.withAlpha(160),
                size: 20,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildActionBottom() {
    if (_currentStep >= widget.scenario.messages.length) {
      return const SizedBox.shrink();
    }

    final nextGoal = widget.scenario.messages[_currentStep];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: AppTheme.backgroundColor,
        border: Border(top: BorderSide(color: Colors.white.withAlpha(20))),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (_isUserTurn) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: AppTheme.cardDecoration,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Sua vez de falar:",
                          style: TextStyle(color: AppTheme.textHintColor, fontSize: 13),
                        ),
                        const SizedBox(width: 8),
                        Icon(Icons.record_voice_over_rounded, color: AppTheme.textHintColor, size: 18),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              Text(
                                "\"${nextGoal['en']}\"",
                                textAlign: TextAlign.center,
                                style: const TextStyle(color: AppTheme.accentColor, fontSize: 17, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "(${nextGoal['pt']})",
                                textAlign: TextAlign.center,
                                style: TextStyle(color: AppTheme.textHintColor, fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        GestureDetector(
                          onTap: () => _speak(nextGoal['en']!, isHint: true),
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: AppTheme.accentColor.withAlpha(30),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.volume_up_rounded, color: AppTheme.accentColor, size: 24),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    // Honest button replacing the fake microphone
                    AnimatedOpacity(
                      duration: const Duration(milliseconds: 300),
                      opacity: _isRecording ? 0.4 : 1.0,
                      child: ElevatedButton.icon(
                        onPressed: _isRecording ? null : _handleUserRecording,
                        icon: _isRecording
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.black,
                                ),
                              )
                            : const Icon(Icons.send_rounded, size: 20),
                        label: Text(
                          _isRecording ? "Enviando..." : "Enviar",
                          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.accentColor,
                          foregroundColor: Colors.black,
                          minimumSize: const Size(double.infinity, 48),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          elevation: 4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Toque depois de repetir a frase em voz alta.",
                style: TextStyle(color: AppTheme.textHintColor, fontSize: 11),
              ),
            ] else ...[
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Text("Buscando resposta...", style: TextStyle(color: AppTheme.textHintColor)),
                ),
              )
            ]
          ],
        ),
      ),
    );
  }

  Widget _buildConcluirButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Center(
        child: ElevatedButton(
          onPressed: () => Navigator.pop(context),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.accentColor,
            minimumSize: const Size(200, 50),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            elevation: 4,
          ),
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              "Concluir Conversa",
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTutorCard() {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 16, bottom: 8),
      child: Container(
        padding: const EdgeInsets.only(left: 2, top: 2, bottom: 2, right: 16),
        decoration: BoxDecoration(
          color: Colors.white.withAlpha(12),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.white.withAlpha(18)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(30),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: [
            TalkingAvatar(isTalking: _isBotSpeaking, isMale: _isTutorMale),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _tutorName,
                    style: TextStyle(
                      color: AppTheme.textColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: _isBotSpeaking ? AppTheme.accentColor : Colors.greenAccent,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _isBotSpeaking ? "Falando..." : "Online",
                        style: TextStyle(
                          color: _isBotSpeaking ? AppTheme.accentColor : Colors.greenAccent.withAlpha(200),
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            VoiceEqualizer(isSpeaking: _isBotSpeaking),
          ],
        ),
      ),
    );
  }
}

class VoiceEqualizer extends StatefulWidget {
  final bool isSpeaking;
  const VoiceEqualizer({super.key, required this.isSpeaking});

  @override
  State<VoiceEqualizer> createState() => _VoiceEqualizerState();
}

class _VoiceEqualizerState extends State<VoiceEqualizer> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    if (widget.isSpeaking) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(covariant VoiceEqualizer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isSpeaking != oldWidget.isSpeaking) {
      if (widget.isSpeaking) {
        _controller.repeat(reverse: true);
      } else {
        _controller.stop();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 24,
      width: 32,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(4, (index) {
          return AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              double multiplier = 0.2 + (0.8 * ((index + 1) % 3 == 0 ? 1 - _controller.value : _controller.value));
              double height = widget.isSpeaking ? 4.0 + (16.0 * multiplier) : 4.0;
              return Container(
                width: 3,
                height: height,
                decoration: BoxDecoration(
                  color: widget.isSpeaking ? AppTheme.accentColor : AppTheme.textHintColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              );
            },
          );
        }),
      ),
    );
  }
}

class TalkingAvatar extends StatefulWidget {
  final bool isTalking;
  final bool isMale;
  const TalkingAvatar({super.key, required this.isTalking, required this.isMale});

  @override
  State<TalkingAvatar> createState() => _TalkingAvatarState();
}

class _TalkingAvatarState extends State<TalkingAvatar> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    if (widget.isTalking) {
      _controller.repeat();
    }
  }

  @override
  void didUpdateWidget(covariant TalkingAvatar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isTalking != oldWidget.isTalking) {
      if (widget.isTalking) {
        _controller.repeat();
      } else {
        _controller.animateTo(0, duration: const Duration(milliseconds: 300));
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final baseColor = widget.isTalking ? AppTheme.accentColor : AppTheme.primaryColor;
    const size = 56.0;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          width: 80,
          height: 80,
          alignment: Alignment.center,
          child: Stack(
            alignment: Alignment.center,
            children: [
              if (widget.isTalking)
                ...List.generate(2, (index) {
                  double progress = _controller.value - (index * 0.5);
                  if (progress < 0) progress += 1.0;

                  final scale = 1.0 + (progress * 0.4);
                  final opacity = 1.0 - progress;

                  return Transform.scale(
                    scale: scale,
                    child: Opacity(
                      opacity: opacity.clamp(0.0, 1.0) * 0.4,
                      child: Container(
                        width: size,
                        height: size,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: baseColor.withAlpha(40),
                          border: Border.all(
                            color: baseColor,
                            width: 1.5,
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              Container(
                width: size,
                height: size,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      baseColor,
                      baseColor.withAlpha(150),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: baseColor.withAlpha(80),
                      blurRadius: widget.isTalking ? 12 : 6,
                      spreadRadius: widget.isTalking ? 2 : 0,
                    ),
                  ],
                ),
                child: Icon(
                  widget.isMale
                      ? Icons.face_6_rounded
                      : Icons.face_retouching_natural_rounded,
                  color: Colors.white,
                  size: 26,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
