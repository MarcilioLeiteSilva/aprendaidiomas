import 'dart:math';
import 'package:flutter/material.dart';
import '../models/models.dart';
import '../services/database_helper.dart';
import '../theme/app_theme.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../services/ad_helper.dart';
import '../services/user_service.dart';
import '../services/sfx_helper.dart';

class QuizScreen extends StatefulWidget {
  final String language;

  const QuizScreen({super.key, required this.language});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  final dbHelper = DatabaseHelper();
  List<LearnSentence> questions = [];
  int currentQuestionIndex = 0;
  bool isLoading = true;

  List<String> options = [];
  String? selectedOption;
  bool answered = false;
  bool isCorrect = false;

  InterstitialAd? _interstitialAd;

  @override
  void initState() {
    super.initState();
    _loadData();
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
              Navigator.pop(context); // Go back home after ad is done
            },
          );
          _interstitialAd = ad;
        },
        onAdFailedToLoad: (err) {
          _interstitialAd = null;
        },
      ),
    );
  }

  @override
  void dispose() {
    _interstitialAd?.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    final data = await dbHelper.getSentences();
    setState(() {
      questions = data;
      isLoading = false;
      if (data.isNotEmpty) {
        _generateOptionsForCurrentQuestion(data[0]);
      }
    });
  }

  void _generateOptionsForCurrentQuestion(LearnSentence sentence) {
    final correctWord = sentence.getWordByLanguage(widget.language);
    final random = Random();
    Set<String> choices = {correctWord};

    // Distractores (using other sentences as pool)
    while (choices.length < 4 && questions.isNotEmpty) {
      final randSentence = questions[random.nextInt(questions.length)];
      final randWord = randSentence.getWordByLanguage(widget.language);
      if (randWord.isNotEmpty) choices.add(randWord);
    }

    // Convert and shuffle
    options = choices.toList()..shuffle();
    selectedOption = null;
    answered = false;
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text("Quiz")),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (questions.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text("Quiz")),
        body: const Center(child: Text("Sem perguntas disponíveis")),
      );
    }

    final sentence = questions[currentQuestionIndex];
    final frame = sentence.getSentenceByLanguage(widget.language);
    final displaySentence = frame.replaceAll("\$\$", "________");
    final correctWord = sentence.getWordByLanguage(widget.language);

    return Scaffold(
      appBar: AppBar(
        title: Text("Questão ${currentQuestionIndex + 1} de ${questions.length}"),
        centerTitle: true,
      ),
      body: Container(
        decoration: AppTheme.gradientBackground,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
          child: Column(
            children: [
              // Linear Progress Bar
              LinearProgressIndicator(
                value: (currentQuestionIndex + 1) / questions.length,
                backgroundColor: Colors.white.withAlpha(20),
                color: AppTheme.primaryColor,
                borderRadius: BorderRadius.circular(10),
              ),
              const SizedBox(height: 48),

              // Frame Holder
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: AppTheme.cardDecoration,
                child: Column(
                  children: [
                    Text(
                      displaySentence,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textColor,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "Tradução: ${sentence.portuguese.replaceAll('\$\$', sentence.pWord)}",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: AppTheme.textHintColor,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Text(
                "Selecione a palavra correta:",
                style: TextStyle(color: AppTheme.textSecondaryColor, fontSize: 13),
              ),
              const SizedBox(height: 48),

              // Options list
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: options.length,
                separatorBuilder: (context, index) => const SizedBox(height: 16),
                itemBuilder: (context, index) {
                  final option = options[index];
                  bool isSelected = selectedOption == option;

                  Color itemColor = Colors.white.withAlpha(10);
                  Color borderColor = Colors.white.withAlpha(15);

                  if (answered) {
                    if (option == correctWord) {
                      itemColor = Colors.green.withAlpha(30);
                      borderColor = Colors.green.withAlpha(150);
                    } else if (isSelected && !isCorrect) {
                      itemColor = Colors.red.withAlpha(30);
                      borderColor = Colors.red.withAlpha(150);
                    }
                  } else if (isSelected) {
                    itemColor = AppTheme.primaryColor.withAlpha(30);
                    borderColor = AppTheme.primaryColor;
                  }

                  return GestureDetector(
                    onTap: answered
                        ? null
                        : () {
                            final correct = option == correctWord;
                            if (correct) {
                              UserService.addXp(15);
                              SfxHelper.playCorrect();
                            } else {
                              SfxHelper.playIncorrect();
                            }
                            setState(() {
                              selectedOption = option;
                              answered = true;
                              isCorrect = correct;
                            });
                          },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
                      decoration: BoxDecoration(
                        color: itemColor,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: borderColor, width: 2),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        option,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          color: isSelected || answered ? AppTheme.textColor : AppTheme.textSecondaryColor,
                        ),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 48),

              // Next Button
              AnimatedOpacity(
                duration: const Duration(milliseconds: 300),
                opacity: answered ? 1.0 : 0.0,
                child: ElevatedButton(
                  onPressed: !answered
                      ? null
                      : () {
                          if (currentQuestionIndex < questions.length - 1) {
                            setState(() {
                              currentQuestionIndex++;
                              _generateOptionsForCurrentQuestion(questions[currentQuestionIndex]);
                            });
                          } else {
                            UserService.addXp(50);
                            UserService.updateStreak();
                            _showScoreDialog();
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.accentColor,
                    foregroundColor: Colors.black,
                    minimumSize: const Size(double.infinity, 56),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    elevation: 8,
                  ),
                  child: const Text("Próxima", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showScoreDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.surfaceColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Text("Quiz Concluído! 🎉", textAlign: TextAlign.center, style: TextStyle(color: Colors.white)),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Você finalizou os exercícios de hoje. Bom trabalho!",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white70),
            ),
            SizedBox(height: 16),
            Text(
              "+50 XP obtidos! 🌟",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppTheme.accentColor,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // pop dialog
              if (_interstitialAd != null) {
                _interstitialAd!.show();
              } else {
                Navigator.pop(context); // pop quiz
              }
            },
            child: const Text("Voltar ao Início", style: TextStyle(color: AppTheme.accentColor)),
          ),
        ],
      ),
    );
  }
}
