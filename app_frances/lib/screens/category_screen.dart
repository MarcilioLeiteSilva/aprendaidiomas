import 'package:flutter/material.dart';
import '../services/database_helper.dart';
import '../theme/app_theme.dart';
import 'flashcard_screen.dart';

class CategoryScreen extends StatefulWidget {
  final String type; // 'words' or 'phrases'
  final String language;

  const CategoryScreen({super.key, required this.type, required this.language});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  final dbHelper = DatabaseHelper();
  List<dynamic> categories = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final data = widget.type == 'phrases'
        ? await dbHelper.getPhraseCategories()
        : await dbHelper.getWordCategories();
    setState(() {
      categories = data;
      isLoading = false;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.type == 'words' ? "Vocabulário" : "Guia de Frases"),
      ),
      body: Container(
        decoration: AppTheme.gradientBackground,
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : GridView.builder(
                padding: const EdgeInsets.all(24),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.0,
                ),
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final cat = categories[index];
                  final title = cat.getNameByLanguage(widget.language);

                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => FlashcardScreen(
                            categoryId: cat.id,
                            categoryName: title,
                            type: widget.type,
                            language: widget.language,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: AppTheme.cardDecoration,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _getIconForCategory(cat.english),
                          const SizedBox(height: 12),
                          Text(
                            title,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.textColor,
                            ),
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

  Widget _getIconForCategory(String name) {
    IconData icon;
    Color color;

    switch (name.toLowerCase()) {
      case 'body parts':
        icon = Icons.accessibility_new_rounded;
        color = Colors.blueAccent;
        break;
      case 'weeks':
      case 'months':
        icon = Icons.calendar_today_rounded;
        color = Colors.pinkAccent;
        break;
      case 'seasons':
        icon = Icons.wb_sunny_rounded;
        color = Colors.orangeAccent;
        break;
      default:
        icon = Icons.lightbulb_outline_rounded;
        color = AppTheme.primaryColor;
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withAlpha(25),
        shape: BoxShape.circle,
        border: Border.all(color: color.withAlpha(50)),
      ),
      child: Icon(icon, color: color, size: 28),
    );
  }
}
