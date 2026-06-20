import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/lessons_data.dart';
import '../theme/app_theme.dart';
import '../services/tts_helper.dart';
import '../services/user_service.dart';
import '../services/sfx_helper.dart';

class LessonPracticeScreen extends StatefulWidget {
  final Lesson lesson;

  const LessonPracticeScreen({super.key, required this.lesson});

  @override
  State<LessonPracticeScreen> createState() => _LessonPracticeScreenState();
}

class _LessonPracticeScreenState extends State<LessonPracticeScreen> {
  final FlutterTts flutterTts = FlutterTts();
  int currentQuestionIndex = 0;

  String? selectedOption;
  bool answered = false;
  bool isCorrect = false;

  @override
  void initState() {
    super.initState();
    _initTts();
    widget.lesson.progress = 0;
  }

  void _initTts() async {
    await TtsHelper.initTts(flutterTts);
  }

  void _speak(String text) async {
    await flutterTts.speak(text);
  }

  Future<void> _saveProgress() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('lesson_progress_${widget.lesson.id}', widget.lesson.progress);
    await prefs.setBool('lesson_completed_${widget.lesson.id}', widget.lesson.isCompleted);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.lesson.items.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text(widget.lesson.title)),
        body: const Center(child: Text("Sem itens nesta lição.")),
      );
    }

    final item = widget.lesson.items[currentQuestionIndex];
    final displayWord = item.questionEn;
    final options = item.optionsPt;

    return Scaffold(
      appBar: AppBar(
        title: Text("Questão ${currentQuestionIndex + 1} de ${widget.lesson.items.length}"),
        centerTitle: true,
      ),
      body: Container(
        decoration: AppTheme.gradientBackground,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
          child: Column(
            children: [
              // Progress Bar
              LinearProgressIndicator(
                value: (currentQuestionIndex + 1) / widget.lesson.items.length,
                backgroundColor: Colors.white.withAlpha(20),
                color: AppTheme.primaryColor,
                borderRadius: BorderRadius.circular(10),
              ),
              const SizedBox(height: 48),

              // Title Area
              Container(
                padding: const EdgeInsets.all(32),
                decoration: AppTheme.cardDecoration,
                child: Column(
                  children: [
                    Text(
                      displayWord,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textColor,
                      ),
                    ),
                    const SizedBox(height: 16),
                    GestureDetector(
                      onTap: () => _speak(displayWord),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppTheme.accentColor.withAlpha(30),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.volume_up_rounded,
                            color: AppTheme.accentColor, size: 28),
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Text(
                "O que significa essa palavra?",
                style: TextStyle(color: AppTheme.textSecondaryColor, fontSize: 13),
              ),
              const SizedBox(height: 32),

              // Options
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: options.length,
                separatorBuilder: (context, index) => const SizedBox(height: 16),
                itemBuilder: (context, index) {
                  final option = options[index];
                  bool isSelected = selectedOption == option;
                  bool isCorrectOption = option == item.answerPt;

                  Color itemColor = Colors.white.withAlpha(10);
                  Color borderColor = Colors.white.withAlpha(15);

                  if (answered) {
                    if (isCorrectOption) {
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
                            final correct = option == item.answerPt;
                            if (correct) {
                              UserService.addXp(10);
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
                      padding: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 24),
                      decoration: BoxDecoration(
                        color: itemColor,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: borderColor, width: 2),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            option,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                              color: isSelected || answered
                                  ? AppTheme.textColor
                                  : AppTheme.textSecondaryColor,
                            ),
                          ),
                          // Show checkmark on correct, X on wrong selected
                          if (answered && isCorrectOption)
                            const Icon(Icons.check_circle_rounded,
                                color: Colors.green, size: 22),
                          if (answered && isSelected && !isCorrect && !isCorrectOption)
                            const Icon(Icons.cancel_rounded,
                                color: Colors.redAccent, size: 22),
                        ],
                      ),
                    ),
                  );
                },
              ),

              // ✅ Show correct answer hint when user gets it wrong
              AnimatedOpacity(
                duration: const Duration(milliseconds: 300),
                opacity: (answered && !isCorrect) ? 1.0 : 0.0,
                child: Container(
                  margin: const EdgeInsets.only(top: 20),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20, vertical: 14),
                  decoration: BoxDecoration(
                    color: Colors.green.withAlpha(20),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.green.withAlpha(80)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.lightbulb_rounded,
                          color: Colors.green, size: 20),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          "A resposta correta era: ${item.answerPt}",
                          style: const TextStyle(
                              color: Colors.green,
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // Next Button
              AnimatedOpacity(
                duration: const Duration(milliseconds: 300),
                opacity: answered ? 1.0 : 0.0,
                child: ElevatedButton(
                  onPressed: !answered
                      ? null
                      : () {
                          widget.lesson.progress = currentQuestionIndex + 1;
                          _saveProgress();

                          if (currentQuestionIndex <
                              widget.lesson.items.length - 1) {
                            setState(() {
                              currentQuestionIndex++;
                              selectedOption = null;
                              answered = false;
                              isCorrect = false;
                            });
                          } else {
                            widget.lesson.isCompleted = true;
                            widget.lesson.progress =
                                widget.lesson.items.length;
                            _saveProgress();
                            UserService.addXp(100);
                            UserService.updateStreak();
                            _showScoreDialog();
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.accentColor,
                    foregroundColor: Colors.black,
                    minimumSize: const Size(double.infinity, 56),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    elevation: 8,
                  ),
                  child: Text(
                    currentQuestionIndex == widget.lesson.items.length - 1
                        ? "Finalizar"
                        : "Próxima",
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 18),
                  ),
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
        title: const Text("Lição Completa! 🌟", textAlign: TextAlign.center, style: TextStyle(color: Colors.white)),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Bom trabalho. Você completou a lição com sucesso!",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white70),
            ),
            SizedBox(height: 16),
            Text(
              "+100 XP obtidos! 🎉",
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
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text("Voltar",
                style: TextStyle(color: AppTheme.accentColor)),
          ),
        ],
      ),
    );
  }
}
