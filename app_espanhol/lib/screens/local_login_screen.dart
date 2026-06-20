import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../config/app_config.dart';
import '../services/user_service.dart';
import 'main_navigation_screen.dart';

class LocalLoginScreen extends StatefulWidget {
  const LocalLoginScreen({super.key});

  static final List<Map<String, dynamic>> avatarOptions = [
    {
      'emoji': '🧑‍🎓',
      'colors': [const Color(0xFF6366F1), const Color(0xFF4F46E5)],
      'name': 'Estudante'
    },
    {
      'emoji': '👩‍🏫',
      'colors': [const Color(0xFFEC4899), const Color(0xFFDB2777)],
      'name': 'Professora'
    },
    {
      'emoji': '👨‍🚀',
      'colors': [const Color(0xFF8B5CF6), const Color(0xFF7C3AED)],
      'name': 'Astronauta'
    },
    {
      'emoji': '🦊',
      'colors': [const Color(0xFFF97316), const Color(0xFFEA580C)],
      'name': 'Raposa'
    },
    {
      'emoji': '🦁',
      'colors': [const Color(0xFFF59E0B), const Color(0xFFD97706)],
      'name': 'Leão'
    },
    {
      'emoji': '🦉',
      'colors': [const Color(0xFF10B981), const Color(0xFF059669)],
      'name': 'Coruja'
    },
  ];

  @override
  State<LocalLoginScreen> createState() => _LocalLoginScreenState();
}

class _LocalLoginScreenState extends State<LocalLoginScreen> {
  final TextEditingController _nameController = TextEditingController();
  int _selectedAvatarIndex = 0;
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    
    final name = _nameController.text.trim();
    await UserService.createUser(name, _selectedAvatarIndex);
    
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => const MainNavigationScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 600),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: AppTheme.gradientBackground,
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Header Area
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppTheme.primaryColor.withAlpha(20),
                        border: Border.all(color: AppTheme.primaryColor.withAlpha(40)),
                      ),
                      child: Icon(
                        Icons.person_add_alt_1_rounded,
                        size: 64,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Crie Seu Perfil',
                      style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                        color: AppTheme.textColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Personalize sua experiência em',
                      style: TextStyle(
                        color: AppTheme.textSecondaryColor,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      AppConfig.appName,
                      style: TextStyle(
                        color: AppTheme.primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 36),

                    // Main Container Card
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: AppTheme.cardDecoration,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Como podemos chamar você?',
                            style: TextStyle(
                              color: AppTheme.textColor,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),
                          // Name Input Field
                          TextFormField(
                            controller: _nameController,
                            style: TextStyle(color: AppTheme.textColor),
                            decoration: InputDecoration(
                              hintText: 'Seu nome ou apelido',
                              hintStyle: TextStyle(color: AppTheme.textHintColor),
                              filled: true,
                              fillColor: AppTheme.isDark ? Colors.white.withAlpha(10) : Colors.black.withAlpha(5),
                              prefixIcon: Icon(Icons.face_rounded, color: AppTheme.primaryColor),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide.none,
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide(color: AppTheme.primaryColor, width: 2),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: const BorderSide(color: Colors.redAccent, width: 1),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                  return 'Por favor, insira seu nome';
                              }
                              if (value.trim().length > 15) {
                                return 'Use um nome com até 15 caracteres';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 28),
                          Text(
                            'Escolha seu Avatar',
                            style: TextStyle(
                              color: AppTheme.textColor,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          // Avatar Selection Grid
                          GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: LocalLoginScreen.avatarOptions.length,
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              crossAxisSpacing: 16,
                              mainAxisSpacing: 16,
                              childAspectRatio: 1.0,
                            ),
                            itemBuilder: (context, index) {
                              final option = LocalLoginScreen.avatarOptions[index];
                              final isSelected = _selectedAvatarIndex == index;
                              final colors = option['colors'] as List<Color>;

                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _selectedAvatarIndex = index;
                                  });
                                },
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: colors,
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    shape: BoxShape.circle,
                                    boxShadow: isSelected
                                        ? [
                                            BoxShadow(
                                              color: colors[0].withAlpha(150),
                                              blurRadius: 12,
                                              spreadRadius: 2,
                                            )
                                          ]
                                        : [],
                                    border: Border.all(
                                      color: isSelected ? Colors.white : Colors.transparent,
                                      width: isSelected ? 3 : 0,
                                    ),
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    option['emoji'] as String,
                                    style: const TextStyle(fontSize: 32),
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 36),

                    // Submit Button
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: _submit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryColor,
                          foregroundColor: AppTheme.textColor,
                          elevation: 8,
                          shadowColor: AppTheme.primaryColor.withAlpha(150),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Começar Aprendizado',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                              ),
                            ),
                            SizedBox(width: 8),
                            Icon(Icons.arrow_forward_rounded),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
