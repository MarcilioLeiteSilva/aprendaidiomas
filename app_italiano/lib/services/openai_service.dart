import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import '../config/app_config.dart';
import 'ai_chat_service.dart';
import 'user_service.dart';

class OpenAiService {
  static Future<AiResponse> getConversationResponse({
    required String topicId,
    required String topicTitle,
    required List<Map<String, dynamic>> history,
    String tutorName = 'Giulia',
    bool isTutorMale = false,
    String? selectedLevel,
  }) async {
    try {
      final isMale = isTutorMale;
      
      final response = await http.post(
        Uri.parse('${AppConfig.backendUrl}/api/v1/ai/chat'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'X-Device-UUID': UserService.deviceUuid,
          'X-App-Language': AppConfig.activeLanguage.name,
        },
        body: jsonEncode({
          'topic_id': topicId,
          'topic_title': topicTitle,
          'history': history,
          'tutor_name': tutorName,
          'is_tutor_male': isMale,
          'selected_level': selectedLevel,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        
        return AiResponse(
          italian: data['target_text'] ?? '',
          portuguese: data['portuguese'] ?? '',
          nextHints: List<String>.from(data['next_hints'] ?? []),
        );
      } else if (response.statusCode == 403) {
        throw Exception('limit_reached');
      } else {
        throw Exception('Server Error: status code ${response.statusCode}');
      }
    } catch (e) {
      if (e.toString().contains('limit_reached')) {
        rethrow;
      }
      
      debugPrint('Error in getConversationResponse backend proxy: $e. Using local fallback.');
      
      // Fallback local caso o servidor esteja fora do ar
      try {
        final lastUserMsg = history.lastWhere(
          (m) => !(m['isBot'] as bool? ?? false),
          orElse: () => <String, dynamic>{},
        )['italian']?.toString() ?? '';
        return AiChatService.generateResponse(topicId, lastUserMsg);
      } catch (_) {
        return const AiResponse(
          italian: 'Ops! Ho avuto un problema di connessione. Puoi ripetere?',
          portuguese: 'Ops, tive um problema de conexão. Pode repetir?',
          nextHints: [
            'Va bene, ripeto.|Tudo bem, eu repito.',
            'Nessun problema.|Sem problemas.',
            'Proviamo di nuovo!|Vamos tentar di nuovo!'
          ],
        );
      }
    }
  }

  static Future<String> getGrammarExplanation({
    required String phrase,
    required String contextTopic,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('${AppConfig.backendUrl}/api/v1/ai/grammar'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'X-Device-UUID': UserService.deviceUuid,
          'X-App-Language': AppConfig.activeLanguage.name,
        },
        body: jsonEncode({
          'phrase': phrase,
          'context_topic': contextTopic,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        return data['explanation'] ?? '';
      } else if (response.statusCode == 403) {
        return 'O Tutor Gramatical é um recurso Pro. Adquira a assinatura Premium para utilizá-lo!';
      } else {
        throw Exception('Grammar Error status: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error in getGrammarExplanation: $e');
      return 'Ops, não foi possível carregar a explicação gramatical neste momento. Verifique sua conexão e tente novamente. (Erro: ${e.toString()})';
    }
  }

  static Future<String?> getRealisticVoiceAudio({
    required String text,
    required String voice,
    double speed = 1.0,
  }) async {
    try {
      final cleanText = text.length > 20 
          ? text.substring(0, 20).replaceAll(RegExp(r'[^a-zA-Z0-9]'), '_')
          : text.replaceAll(RegExp(r'[^a-zA-Z0-9]'), '_');
      final hash = '${voice}_${speed.toStringAsFixed(2)}_${text.hashCode.abs()}_$cleanText';
      final tempDir = await getTemporaryDirectory();
      final file = File('${tempDir.path}/tts_voice_$hash.mp3');

      // Verifica se o áudio já está cacheado localmente no celular do usuário
      if (await file.exists()) {
        debugPrint('Reusando áudio cacheado localmente para: $text');
        return file.path;
      }

      final response = await http.post(
        Uri.parse('${AppConfig.backendUrl}/api/v1/ai/tts'),
        headers: {
          'Content-Type': 'application/json',
          'X-Device-UUID': UserService.deviceUuid,
          'X-App-Language': AppConfig.activeLanguage.name,
        },
        body: jsonEncode({
          'text': text,
          'voice': voice,
          'speed': speed,
        }),
      );

      if (response.statusCode == 200) {
        final bytes = response.bodyBytes;
        await file.writeAsBytes(bytes);
        return file.path;
      } else if (response.statusCode == 403) {
        throw Exception('premium_required');
      } else {
        throw Exception('TTS Error status: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error generating realistic TTS: $e');
      return null;
    }
  }
}
