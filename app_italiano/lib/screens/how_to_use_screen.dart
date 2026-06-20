import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class HowToUseScreen extends StatelessWidget {
  const HowToUseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Como Usar'),
        centerTitle: true,
      ),
      body: Container(
        decoration: AppTheme.gradientBackground,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          children: [
            _buildInfoCard(
              context,
              icon: Icons.school_rounded,
              title: "Lições e Progresso",
              description:
                  "As lições são divididas por nível de dificuldade. Você começa no nível Iniciante e sobe gradualmente até o Avançado. Níveis maiores exigem que você assista a um rápido anúncio como recompensa pelo conteúdo premium.",
            ),
            _buildInfoCard(
              context,
              icon: Icons.style_rounded,
              title: "Flashcards",
              description:
                  "Deslize os cartões (swipe) para a esquerda ou direita para navegar entre as palavras da mesma categoria. Toque no cartão para girá-lo e ver a tradução em Português.",
            ),
            _buildInfoCard(
              context,
              icon: Icons.chat_bubble_rounded,
              title: "Conversação Guiada",
              description:
                  "Simule diálogos de situações reais como Aeroportos ou Restaurantes. Ouça a frase sendo pronunciada, repita em voz alta, e depois aperte 'Enviar' para treinar seu sotaque e continuidade.",
            ),
            _buildInfoCard(
              context,
              icon: Icons.lightbulb_rounded,
              title: "Dica: Prática Constante",
              description:
                  "Para aprender um novo idioma rapidamente, tente fazer pelo menos duas lições e uma conversação todos os dias. A consistência é a verdadeira chave do sucesso!",
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.accentColor,
                foregroundColor: Colors.black,
                minimumSize: const Size(double.infinity, 56),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                elevation: 6,
              ),
              child: const Text(
                "Entendido",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context, {required IconData icon, required String title, required String description}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.all(24),
      decoration: AppTheme.cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withAlpha(50),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: AppTheme.isDark ? Colors.white : AppTheme.primaryColor, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.isDark ? Colors.white : Colors.black87,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            description,
            style: TextStyle(
              fontSize: 15,
              height: 1.5,
              color: AppTheme.isDark ? Colors.white70 : Colors.black87.withAlpha(200),
            ),
          ),
        ],
      ),
    );
  }
}
