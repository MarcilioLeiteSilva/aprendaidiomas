import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../services/user_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/billing_service.dart';
import '../config/app_config.dart';

class PaywallScreen extends StatefulWidget {
  const PaywallScreen({super.key});

  @override
  State<PaywallScreen> createState() => _PaywallScreenState();
}

class _PaywallScreenState extends State<PaywallScreen> {
  bool _isPurchasing = false;

  @override
  void initState() {
    super.initState();
    UserService.currentUserNotifier.addListener(_onUserChange);
  }

  @override
  void dispose() {
    UserService.currentUserNotifier.removeListener(_onUserChange);
    super.dispose();
  }

  void _onUserChange() {
    if (UserService.currentUser.isPremium && mounted) {
      _showSuccessDialog();
    }
  }

  void _handlePurchase() async {
    setState(() {
      _isPurchasing = true;
    });

    try {
      await BillingService.buySubscription();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString().replaceAll('Exception: ', '')),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isPurchasing = false;
        });
      }
    }
  }

  void _showSuccessDialog() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('use_realistic_voice', true);

    if (!mounted) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              color: const Color(0xFF1E1E2E),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: AppTheme.accentColor.withAlpha(80)),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.accentColor.withAlpha(20),
                  blurRadius: 24,
                  spreadRadius: 4,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppTheme.accentColor.withAlpha(25),
                  ),
                  child: const Icon(
                    Icons.star_rounded,
                    color: AppTheme.accentColor,
                    size: 48,
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Parabéns!',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Você agora é Premium! Desfrute de conversas com ${AppConfig.activeLanguage == LanguageTarget.spanish ? "espanhol" : AppConfig.activeLanguage == LanguageTarget.french ? "francês" : AppConfig.activeLanguage == LanguageTarget.german ? "alemão" : AppConfig.activeLanguage == LanguageTarget.italian ? "italiano" : "inglês"} ilimitado, vozes ultra-realistas e tutor de gramática em todos os temas.',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // Fecha o dialog
                    Navigator.pop(context); // Fecha a tela de paywall
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.accentColor,
                    foregroundColor: Colors.black,
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text(
                    'Vamos Começar!',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F1A),
      body: Stack(
        children: [
          // Background Gradient Circles for Premium Look
          Positioned(
            top: -100,
            right: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppTheme.accentColor.withAlpha(15),
              ),
            ),
          ),
          Positioned(
            bottom: -50,
            left: -100,
            child: Container(
              width: 350,
              height: 350,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppTheme.primaryColor.withAlpha(20),
              ),
            ),
          ),

          // Main Scrollable Area
          SafeArea(
            child: CustomScrollView(
              slivers: [
                // Top Appbar or Close Button
                SliverAppBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  automaticallyImplyLeading: false,
                  actions: [
                    IconButton(
                      icon: const Icon(Icons.close_rounded, color: Colors.white60, size: 28),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(width: 12),
                  ],
                ),

                // Hero Header
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                      children: [
                        const SizedBox(height: 10),
                        // Premium Crown Logo
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: RadialGradient(
                              colors: [
                                AppTheme.accentColor.withAlpha(50),
                                Colors.transparent,
                              ],
                            ),
                          ),
                          child: const Icon(
                            Icons.workspace_premium_rounded,
                            color: AppTheme.accentColor,
                            size: 64,
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Aprenda Alemão Pro',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Acelere sua fluência com recursos exclusivos de inteligência artificial avançada.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.white54,
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ),

                // Benefits list
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      _buildBenefitItem(
                        icon: Icons.chat_bubble_outline_rounded,
                        title: 'Conversação Ilimitada',
                        description: 'Pratique alemão sem restrições diárias ou necessidade de assistir anúncios.',
                      ),
                      const SizedBox(height: 20),
                      _buildBenefitItem(
                        icon: Icons.record_voice_over_outlined,
                        title: 'Vozes Ultra-Realistas',
                        description: 'Fale e ouça com vozes de IA de última geração que imitam entonação humana perfeitamente.',
                      ),
                      const SizedBox(height: 20),
                      _buildBenefitItem(
                        icon: Icons.school_outlined,
                        title: 'Tutor de Gramática Dedicado',
                        description: 'Receba análises explicadas detalhadamente e em português sobre qualquer frase do chat.',
                      ),
                      const SizedBox(height: 20),
                      _buildBenefitItem(
                        icon: Icons.ad_units_rounded,
                        title: 'Sem Anúncios',
                        description: 'Foque 100% nos seus estudos com uma experiência limpa e produtiva.',
                      ),
                    ]),
                  ),
                ),

                // Bottom CTA details
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const SizedBox(height: 32),
                        // Offer Card
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white.withAlpha(5),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.white.withAlpha(10)),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Acesso Ilimitado',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Cancele quando quiser',
                                      style: TextStyle(
                                        color: AppTheme.textHintColor,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    r'R$ 19,90',
                                    style: TextStyle(
                                      color: AppTheme.accentColor,
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    '/ mês',
                                    style: TextStyle(
                                      color: Colors.white54,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Action Button
                        ElevatedButton(
                          onPressed: _isPurchasing ? null : _handlePurchase,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.accentColor,
                            foregroundColor: Colors.black,
                            minimumSize: const Size(double.infinity, 60),
                            elevation: 8,
                            shadowColor: AppTheme.accentColor.withAlpha(100),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                            ),
                          ),
                          child: _isPurchasing
                              ? const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    color: Colors.black,
                                    strokeWidth: 2.5,
                                  ),
                                )
                              : const Text(
                                  'Testar Grátis por 7 dias',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Após o período de teste, R\$ 19,90/mês cobrados recorrentemente.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white30,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBenefitItem({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white.withAlpha(5),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.white.withAlpha(8)),
          ),
          child: Icon(icon, color: AppTheme.accentColor, size: 24),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: const TextStyle(
                  color: Colors.white60,
                  fontSize: 13,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
