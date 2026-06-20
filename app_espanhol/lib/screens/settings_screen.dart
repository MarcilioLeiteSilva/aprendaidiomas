import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'how_to_use_screen.dart';
import '../services/tts_helper.dart';
import '../config/app_config.dart';
import '../services/user_service.dart';
import 'local_login_screen.dart';
import 'splash_screen.dart';
import '../services/notification_service.dart';
import 'paywall_screen.dart';
import 'package:audioplayers/audioplayers.dart';
import '../services/openai_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  double _ttsSpeed = 0.35;
  double _ttsPitch = 1.0;
  final FlutterTts _flutterTts = FlutterTts();
  bool _streakReminderEnabled = false;

  final AudioPlayer _dialogAudioPlayer = AudioPlayer();
  bool _isPlayingRealisticPreview = false;
  String? _previewingTutorName;

  List<CuratedVoice> _englishVoices = [];
  bool _loadingVoices = false;

  @override
  void dispose() {
    _dialogAudioPlayer.dispose();
    super.dispose();
  }

  bool _voiceMatchesLanguage(String name, String locale) {
    final active = AppConfig.activeLanguage;
    final cleanLocale = locale.toLowerCase();
    final cleanName = name.toLowerCase();
    switch (active) {
      case LanguageTarget.french:
        return cleanLocale.startsWith('fr') || cleanName.startsWith('fr') || cleanLocale.contains('fra');
      case LanguageTarget.spanish:
        return cleanLocale.startsWith('es') || cleanName.startsWith('es') || cleanLocale.contains('spa');
      case LanguageTarget.german:
        return cleanLocale.startsWith('de') || cleanName.startsWith('de') || cleanLocale.contains('deu');
      case LanguageTarget.italian:
        return cleanLocale.startsWith('it') || cleanName.startsWith('it') || cleanLocale.contains('ita');
      case LanguageTarget.english:
        final isEn = cleanLocale.startsWith('en') || cleanName.startsWith('en') || cleanLocale.contains('eng');
        if (!isEn) return false;
        final hasUs = cleanLocale.contains('us') || cleanName.contains('us');
        final hasGb = cleanLocale.contains('gb') || cleanName.contains('gb');
        return hasUs || hasGb;
    }
  }

  Future<void> _loadVoices() async {
    setState(() => _loadingVoices = true);
    try {
      List<dynamic>? voices = await _flutterTts.getVoices;
      List<Map<String, String>> temp = [];
      if (voices != null) {
        for (var voice in voices) {
          if (voice is Map) {
            final name = voice['name']?.toString() ?? '';
            final locale = voice['locale']?.toString() ?? '';
            if (_voiceMatchesLanguage(name, locale)) {
              temp.add({
                'name': name,
                'locale': locale,
              });
            }
          }
        }
      }
      final curated = TtsHelper.getCuratedVoices(temp, AppConfig.activeLanguage);
      setState(() {
        _englishVoices = curated;
        _loadingVoices = false;
      });
    } catch (e) {
      setState(() => _loadingVoices = false);
    }
  }

  String activeLanguagePreviewText(LanguageTarget lang, String name) {
    switch (lang) {
      case LanguageTarget.french:
        return "Bonjour, je m'appelle $name. Ravi de vous rencontrer!";
      case LanguageTarget.spanish:
        return "Hola, mi nombre es $name. ¡Mucho gusto!";
      case LanguageTarget.german:
        return "Hallo, mein Name ist $name. Schön, Sie kennenzulernen!";
      case LanguageTarget.english:
        return "Hello, my name is $name. Nice to meet you!";
      case LanguageTarget.italian:
        return "Ciao, mi chiamo $name. Piacere di conoscerti!";
    }
  }

  void _showTtsVoiceDialog() async {
    await _loadVoices();
    if (!mounted) return;

    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    String? currentVoiceName = prefs.getString('selected_tts_voice_name');
    String currentTutorName = await TtsHelper.getStoredTutorName();
    bool useRealisticVoice = prefs.getBool('use_realistic_voice') ?? false;
    double realisticSpeed = prefs.getDouble('realistic_tts_speed') ?? 1.0;

    final realisticTutors = TtsHelper.getRealisticTutors(AppConfig.activeLanguage);

    if (!mounted) return;

    showDialog(
      context: context,
      builder: (context) {
        return DefaultTabController(
          length: 2,
          initialIndex: useRealisticVoice ? 1 : 0,
          child: StatefulBuilder(
            builder: (context, setDialogState) {
              final isPremium = UserService.currentUser.isPremium;
              return AlertDialog(
                backgroundColor: AppTheme.surfaceColor,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                title: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Selecionar Voz do Tutor', style: TextStyle(color: Colors.white)),
                    const SizedBox(height: 16),
                    TabBar(
                      indicatorColor: AppTheme.accentColor,
                      labelColor: AppTheme.accentColor,
                      unselectedLabelColor: Colors.white54,
                      indicatorSize: TabBarIndicatorSize.tab,
                      tabs: [
                        const Tab(
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.record_voice_over_outlined, size: 18),
                                SizedBox(width: 6),
                                Text('Voz Padrão', style: TextStyle(fontSize: 13)),
                              ],
                            ),
                          ),
                        ),
                        Tab(
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.record_voice_over_rounded, size: 18),
                                const SizedBox(width: 6),
                                const Text('Voz Realista', style: TextStyle(fontSize: 13)),
                                if (!isPremium) ...[
                                  const SizedBox(width: 4),
                                  const Icon(Icons.lock_rounded, size: 12, color: Colors.amber),
                                ],
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                content: SizedBox(
                  width: double.maxFinite,
                  height: MediaQuery.of(context).size.height * 0.42,
                  child: TabBarView(
                    children: [
                      // TAB 1: Voz Padrão (Local TTS)
                      _loadingVoices
                          ? const Center(child: CircularProgressIndicator(color: AppTheme.accentColor))
                          : _englishVoices.isEmpty
                              ? const Center(
                                  child: Text(
                                    'Nenhuma voz de tutor padrão encontrada no dispositivo.',
                                    style: TextStyle(color: Colors.white70),
                                    textAlign: TextAlign.center,
                                  ),
                                )
                              : ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: _englishVoices.length,
                                  itemBuilder: (context, index) {
                                    final voice = _englishVoices[index];
                                    final isSelected = !useRealisticVoice && voice.rawName == currentVoiceName;
                                    final isMale = voice.isMale;
                                    final name = voice.displayName;

                                    return ListTile(
                                      title: Text(
                                        name,
                                        style: TextStyle(
                                          color: isSelected ? AppTheme.accentColor : Colors.white70,
                                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                          fontSize: 16,
                                        ),
                                      ),
                                      subtitle: Padding(
                                        padding: const EdgeInsets.only(top: 4.0),
                                        child: Row(
                                          children: [
                                            Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                              decoration: BoxDecoration(
                                                color: isMale
                                                    ? Colors.blue.withAlpha(40)
                                                    : Colors.pink.withAlpha(40),
                                                borderRadius: BorderRadius.circular(6),
                                                border: Border.all(
                                                  color: isMale ? Colors.blue.withAlpha(80) : Colors.pink.withAlpha(80),
                                                ),
                                              ),
                                              child: Text(
                                                isMale ? '♂ Masculina' : '♀ Feminina',
                                                style: TextStyle(
                                                  color: isMale ? Colors.blue[200] : Colors.pink[200],
                                                  fontSize: 9,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                             const SizedBox(width: 8),
                                             Expanded(
                                               child: Text(
                                                 voice.rawLocale,
                                                 style: const TextStyle(color: Colors.white30, fontSize: 11),
                                                 overflow: TextOverflow.ellipsis,
                                               ),
                                             ),
                                          ],
                                        ),
                                      ),
                                      leading: Icon(
                                        isSelected 
                                            ? Icons.radio_button_checked_rounded 
                                            : Icons.radio_button_off_rounded,
                                        color: isSelected ? AppTheme.accentColor : Colors.white54,
                                      ),
                                      trailing: IconButton(
                                        icon: const Icon(Icons.volume_up_rounded, color: Colors.white60),
                                        onPressed: () async {
                                          await _flutterTts.setVoice({
                                            "name": voice.rawName,
                                            "locale": voice.rawLocale,
                                          });
                                          await _flutterTts.setSpeechRate(_ttsSpeed);
                                          await _flutterTts.setPitch(_ttsPitch);
                                          final previewText = activeLanguagePreviewText(AppConfig.activeLanguage, name);
                                          await _flutterTts.speak(previewText);
                                        },
                                      ),
                                      onTap: () {
                                        setDialogState(() {
                                          useRealisticVoice = false;
                                          currentVoiceName = voice.rawName;
                                          currentTutorName = voice.displayName;
                                        });
                                      },
                                    );
                                  },
                                ),

                      // TAB 2: Voz Realista (OpenAI Cloud TTS)
                      Column(
                        children: [
                          Expanded(
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: realisticTutors.length,
                              itemBuilder: (context, index) {
                                final tutor = realisticTutors[index];
                                final isSelected = useRealisticVoice && tutor.displayName == currentTutorName;
                                final isMale = tutor.isMale;
                                final name = tutor.displayName;
                                final openAiVoice = RealisticVoiceConfig.getOpenAiVoiceForTutor(name, AppConfig.activeLanguage);

                                return ListTile(
                                  title: Text(
                                    name,
                                    style: TextStyle(
                                      color: isSelected ? AppTheme.accentColor : Colors.white70,
                                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                      fontSize: 16,
                                    ),
                                  ),
                                  subtitle: Padding(
                                    padding: const EdgeInsets.only(top: 4.0),
                                    child: Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                          decoration: BoxDecoration(
                                            color: isMale
                                                ? Colors.blue.withAlpha(40)
                                                : Colors.pink.withAlpha(40),
                                            borderRadius: BorderRadius.circular(6),
                                            border: Border.all(
                                              color: isMale ? Colors.blue.withAlpha(80) : Colors.pink.withAlpha(80),
                                            ),
                                          ),
                                          child: Text(
                                            isMale ? '♂ Masculina' : '♀ Feminina',
                                            style: TextStyle(
                                              color: isMale ? Colors.blue[200] : Colors.pink[200],
                                              fontSize: 9,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  leading: Icon(
                                    isSelected 
                                        ? Icons.radio_button_checked_rounded 
                                        : Icons.radio_button_off_rounded,
                                    color: isSelected ? AppTheme.accentColor : Colors.white54,
                                  ),
                                  trailing: _isPlayingRealisticPreview && _previewingTutorName == name
                                      ? const SizedBox(
                                          width: 24,
                                          height: 24,
                                          child: CircularProgressIndicator(strokeWidth: 2, color: AppTheme.accentColor),
                                        )
                                      : IconButton(
                                          icon: const Icon(Icons.volume_up_rounded, color: AppTheme.accentColor),
                                          onPressed: () async {
                                            setDialogState(() {
                                              _isPlayingRealisticPreview = true;
                                              _previewingTutorName = name;
                                            });
                                            try {
                                              await _flutterTts.stop();
                                              await _dialogAudioPlayer.stop();

                                              final previewText = activeLanguagePreviewText(AppConfig.activeLanguage, name);
                                              final audioPath = await OpenAiService.getRealisticVoiceAudio(
                                                text: previewText,
                                                voice: openAiVoice,
                                                speed: realisticSpeed,
                                              );
                                              if (audioPath != null) {
                                                await _dialogAudioPlayer.play(DeviceFileSource(audioPath));
                                              } else {
                                                if (context.mounted) {
                                                   ScaffoldMessenger.of(context).showSnackBar(
                                                     const SnackBar(content: Text('Falha ao gerar pré-visualização em nuvem.')),
                                                   );
                                                 }
                                              }
                                            } catch (e) {
                                              debugPrint('Preview error: $e');
                                            } finally {
                                              if (mounted) {
                                                setDialogState(() {
                                                  _isPlayingRealisticPreview = false;
                                                  _previewingTutorName = null;
                                                });
                                              }
                                            }
                                          },
                                        ),
                                  onTap: () {
                                    setDialogState(() {
                                      useRealisticVoice = true;
                                      currentTutorName = name;
                                    });
                                  },
                                );
                              },
                            ),
                          ),
                          
                          // Realistic Voice Configuration Controls
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.white.withAlpha(5),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: Colors.white10),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'Velocidade da Voz Realista',
                                      style: TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      '${realisticSpeed.toStringAsFixed(2)}x',
                                      style: const TextStyle(color: AppTheme.accentColor, fontSize: 12, fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                Slider(
                                  value: realisticSpeed,
                                  min: 0.75,
                                  max: 1.25,
                                  divisions: 10,
                                  activeColor: AppTheme.accentColor,
                                  inactiveColor: Colors.white24,
                                  onChanged: (val) {
                                    setDialogState(() {
                                      realisticSpeed = val;
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      _dialogAudioPlayer.stop();
                      Navigator.pop(context);
                    },
                    child: const Text('Fechar', style: TextStyle(color: Colors.white60)),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      _dialogAudioPlayer.stop();
                      final navigator = Navigator.of(context);
                      final scaffoldMessenger = ScaffoldMessenger.of(context);

                      if (useRealisticVoice && !isPremium) {
                        // Redirect to paywall
                        navigator.pop();
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const PaywallScreen()),
                        ).then((_) {
                          if (mounted) setState(() {});
                        });
                        return;
                      }

                      final p = await SharedPreferences.getInstance();
                      await p.setBool('use_realistic_voice', useRealisticVoice);
                      await p.setDouble('realistic_tts_speed', realisticSpeed);

                      if (useRealisticVoice) {
                        // Selection from Tab 2 (Voz Realista)
                        final selectedTutor = realisticTutors.firstWhere((t) => t.displayName == currentTutorName);
                        await TtsHelper.saveTutorName(selectedTutor.displayName);
                        await TtsHelper.saveTutorGender(selectedTutor.isMale);

                        navigator.pop();
                        scaffoldMessenger.showSnackBar(
                          SnackBar(
                            content: Text('Tutor Realista ${selectedTutor.displayName} selecionado com sucesso!'),
                            backgroundColor: AppTheme.accentColor,
                          ),
                        );
                      } else {
                        // Selection from Tab 1 (Voz Padrão)
                        if (currentVoiceName != null) {
                          final selectedVoice = _englishVoices.firstWhere((v) => v.rawName == currentVoiceName);
                          await p.setString('selected_tts_voice_name', selectedVoice.rawName);
                          await p.setString('selected_tts_voice_locale', selectedVoice.rawLocale);
                          await TtsHelper.saveTutorName(selectedVoice.displayName);
                          await TtsHelper.saveTutorGender(selectedVoice.isMale);

                          navigator.pop();
                          scaffoldMessenger.showSnackBar(
                            SnackBar(
                              content: Text('Tutor Padrão ${selectedVoice.displayName} selecionado com sucesso!'),
                              backgroundColor: AppTheme.accentColor,
                            ),
                          );
                        } else {
                          navigator.pop();
                        }
                      }
                      if (mounted) setState(() {});
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.accentColor,
                      foregroundColor: Colors.black,
                    ),
                    child: Text(useRealisticVoice && !isPremium ? 'Seja Premium' : 'Selecionar'),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  Future<void> _previewVoice(double speed, double pitch) async {
    await TtsHelper.initTts(_flutterTts);
    await _flutterTts.setSpeechRate(speed);
    await _flutterTts.setPitch(pitch);
    String previewText = 'This is how I will speak.';
    if (AppConfig.activeLanguage == LanguageTarget.french) {
      previewText = "C'est assim que je vais falar.";
    } else if (AppConfig.activeLanguage == LanguageTarget.spanish) {
      previewText = "Así es como voy a hablar.";
    } else if (AppConfig.activeLanguage == LanguageTarget.german) {
      previewText = "So werde ich sprechen.";
    }
    await _flutterTts.speak(previewText);
  }

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final reminderEnabled = await NotificationService.isReminderEnabled();
    setState(() {
      _ttsSpeed = prefs.getDouble('tts_speed') ?? 0.35;
      _ttsPitch = prefs.getDouble('tts_pitch') ?? 1.0;
      _streakReminderEnabled = reminderEnabled;
    });
  }

  Future<void> _saveTtsSettings(double speed, double pitch) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('tts_speed', speed);
    await prefs.setDouble('tts_pitch', pitch);
    setState(() {
      _ttsSpeed = speed;
      _ttsPitch = pitch;
    });
  }

  void _showTtsSpeedDialog() {
    double tempSpeed = _ttsSpeed;
    double tempPitch = _ttsPitch;
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: AppTheme.surfaceColor,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
              title: const Text('Configurar Voz (TTS)', style: TextStyle(color: Colors.white)),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Velocidade da Fala',
                    style: TextStyle(color: Colors.white70, fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  Slider(
                    value: tempSpeed,
                    min: 0.1,
                    max: 1.0,
                    divisions: 9,
                    activeColor: AppTheme.accentColor,
                    inactiveColor: Colors.white24,
                    label: tempSpeed.toStringAsFixed(1),
                    onChanged: (value) {
                      setDialogState(() {
                        tempSpeed = value;
                      });
                    },
                  ),
                  Text(
                    "Velocidade: ${(tempSpeed * 100).toInt()}%",
                    style: const TextStyle(color: Colors.white60, fontSize: 12),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Timbre / Tom da Voz (Pitch)',
                    style: TextStyle(color: Colors.white70, fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  Slider(
                    value: tempPitch,
                    min: 0.5,
                    max: 1.5,
                    divisions: 10,
                    activeColor: AppTheme.accentColor,
                    inactiveColor: Colors.white24,
                    label: tempPitch.toStringAsFixed(1),
                    onChanged: (value) {
                      setDialogState(() {
                        tempPitch = value;
                      });
                    },
                  ),
                  Text(
                    "Tom: ${tempPitch == 1.0 ? 'Normal' : (tempPitch < 1.0 ? 'Mais Grave' : 'Mais Agudo')} (${(tempPitch * 100).toInt()}%)",
                    style: const TextStyle(color: Colors.white60, fontSize: 12),
                  ),
                ],
              ),
              actions: [
                TextButton.icon(
                  onPressed: () => _previewVoice(tempSpeed, tempPitch),
                  icon: const Icon(Icons.volume_up_rounded, color: AppTheme.accentColor, size: 20),
                  label: const Text('Testar voz', style: TextStyle(color: AppTheme.accentColor)),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancelar', style: TextStyle(color: Colors.white60)),
                ),
                ElevatedButton(
                  onPressed: () {
                    _saveTtsSettings(tempSpeed, tempPitch);
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('Configurações de voz salvas com sucesso!'),
                        backgroundColor: AppTheme.primaryColor,
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.accentColor,
                    foregroundColor: Colors.black,
                  ),
                  child: const Text('Salvar'),
                ),
              ],
            );
          }
        );
      },
    );
  }

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Não foi possível abrir o link.')),
        );
      }
    }
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            color: AppTheme.textColor,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: AppTheme.textSecondaryColor,
            fontSize: 11,
          ),
        ),
      ],
    );
  }

  void _showEditProfileDialog(BuildContext context, String currentName, int currentAvatarIndex) {
    final nameController = TextEditingController(
      text: (currentName == 'Estudante' && !UserService.hasCustomProfile) ? '' : currentName,
    );
    int selectedAvatarIndex = currentAvatarIndex;
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: AppTheme.surfaceColor,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
              title: Text(
                UserService.hasCustomProfile ? 'Editar Perfil' : 'Criar Perfil',
                style: const TextStyle(color: Colors.white),
              ),
              content: Form(
                key: formKey,
                child: SizedBox(
                  width: double.maxFinite,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextFormField(
                          controller: nameController,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            labelText: 'Seu Nome',
                            labelStyle: const TextStyle(color: Colors.white70),
                            filled: true,
                            fillColor: Colors.white.withAlpha(10),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide.none,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: const BorderSide(color: AppTheme.accentColor, width: 2),
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
                        const SizedBox(height: 20),
                        const Text(
                          'Escolha seu Avatar',
                          style: TextStyle(color: Colors.white70, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 12),
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: LocalLoginScreen.avatarOptions.length,
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                            childAspectRatio: 1.0,
                          ),
                          itemBuilder: (context, index) {
                            final option = LocalLoginScreen.avatarOptions[index];
                            final isSelected = selectedAvatarIndex == index;
                            final colors = option['colors'] as List<Color>;

                            return GestureDetector(
                              onTap: () {
                                setDialogState(() {
                                  selectedAvatarIndex = index;
                                });
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: colors,
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: isSelected ? Colors.white : Colors.transparent,
                                    width: isSelected ? 3 : 0,
                                  ),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  option['emoji'] as String,
                                  style: const TextStyle(fontSize: 24),
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancelar', style: TextStyle(color: Colors.white60)),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      final name = nameController.text.trim();
                      final navigator = Navigator.of(context);
                      if (!UserService.hasCustomProfile) {
                        await UserService.createUser(name, selectedAvatarIndex);
                      } else {
                        final user = UserService.currentUser;
                        final updated = user.copyWith(
                          name: name,
                          avatarIndex: selectedAvatarIndex,
                        );
                        await UserService.saveProfile(updated);
                      }
                      navigator.pop();
                      setState(() {});
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.accentColor,
                    foregroundColor: Colors.black,
                  ),
                  child: const Text('Salvar'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showResetConfirmDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppTheme.surfaceColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          title: const Text('Redefinir Aplicativo?', style: TextStyle(color: Colors.white)),
          content: const Text(
            'Isso apagará permanentemente o seu nome, avatar selecionado, nível, XP acumulado e progresso de todas as lições. Essa ação não pode ser desfeita.',
            style: TextStyle(color: Colors.white70),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar', style: TextStyle(color: Colors.white60)),
            ),
            ElevatedButton(
              onPressed: () async {
                final navigator = Navigator.of(context);
                await UserService.resetProfile();
                navigator.pop(); // Close dialog
                navigator.pop(); // Go back home
                navigator.pushReplacement(
                  MaterialPageRoute(builder: (_) => const SplashScreen())
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                foregroundColor: Colors.white,
              ),
              child: const Text('Excluir Tudo'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final activeLang = AppConfig.activeLanguage;
    final langName = activeLang == LanguageTarget.english
        ? 'inglês'
        : (activeLang == LanguageTarget.french
            ? 'francês'
            : (activeLang == LanguageTarget.spanish
                ? 'espanhol'
                : (activeLang == LanguageTarget.italian ? 'italiano' : 'alemão')));
    final appId = activeLang == LanguageTarget.english
        ? 'com.prolaser.aprendaingles'
        : (activeLang == LanguageTarget.french
            ? 'com.prolaser.aprendafrances'
            : (activeLang == LanguageTarget.spanish
                ? 'com.prolaser.aprendaespanhol'
                : (activeLang == LanguageTarget.italian
                    ? 'com.prolaser.aprendaitaliano'
                    : 'com.prolaser.aprendaalemao')));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Configurações'),
        centerTitle: true,
      ),
      body: Container(
        decoration: AppTheme.gradientBackground,
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
          children: [
            // User Profile Card
            ValueListenableBuilder(
              valueListenable: UserService.currentUserNotifier,
              builder: (context, user, _) {
                final displayUser = UserService.currentUser;
                final name = displayUser.name;
                final avatarIndex = displayUser.avatarIndex;
                final xp = displayUser.xp;
                final streak = displayUser.streak;

                final avatarOption = LocalLoginScreen.avatarOptions[avatarIndex.clamp(0, 5)];
                final emoji = avatarOption['emoji'] as String;
                final colors = avatarOption['colors'] as List<Color>;

                final level = UserService.getLevel(xp);
                final levelName = UserService.getLevelName(level);
                final hasProfile = UserService.hasCustomProfile;

                return Container(
                  margin: const EdgeInsets.only(bottom: 24),
                  padding: const EdgeInsets.all(24),
                  decoration: AppTheme.cardDecoration,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 64,
                            height: 64,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                colors: colors,
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              emoji,
                              style: const TextStyle(fontSize: 32),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      name,
                                      style: TextStyle(
                                        color: AppTheme.textColor,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    if (displayUser.isPremium) ...[
                                      const SizedBox(width: 6),
                                      const Icon(Icons.workspace_premium_rounded, color: AppTheme.accentColor, size: 20),
                                    ],
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  hasProfile
                                      ? "Nível $level - $levelName${displayUser.isPremium ? ' (Pro)' : ''}"
                                      : "Perfil Temporário / Padrão",
                                  style: TextStyle(
                                    color: hasProfile ? AppTheme.primaryColor : AppTheme.textSecondaryColor,
                                    fontSize: 14,
                                    fontWeight: hasProfile ? FontWeight.bold : FontWeight.normal,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (hasProfile)
                            IconButton(
                              icon: const Icon(Icons.edit_rounded, color: AppTheme.accentColor),
                              onPressed: () => _showEditProfileDialog(context, name, avatarIndex),
                            )
                          else
                            TextButton(
                              onPressed: () => _showEditProfileDialog(context, name, avatarIndex),
                              style: TextButton.styleFrom(
                                foregroundColor: AppTheme.accentColor,
                                textStyle: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              child: const Text('Criar Perfil'),
                            ),
                        ],
                      ),
                      if (hasProfile) ...[
                        const SizedBox(height: 20),
                        // Stats Row
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                          decoration: BoxDecoration(
                            color: AppTheme.isDark ? Colors.white.withAlpha(5) : Colors.black.withAlpha(5),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _buildStatItem("XP Total", "$xp XP"),
                              Container(width: 1, height: 24, color: AppTheme.isDark ? Colors.white24 : Colors.black12),
                              _buildStatItem("Ofensiva", "🔥 $streak"),
                              Container(width: 1, height: 24, color: AppTheme.isDark ? Colors.white24 : Colors.black12),
                              _buildStatItem("Nível", "# $level"),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                );
              },
            ),
            _buildSectionHeader('Assinatura'),
            _buildSettingsTile(
              icon: Icons.star_rounded,
              title: UserService.currentUser.isPremium ? 'Sua Assinatura Pro' : 'Seja Premium',
              subtitle: UserService.currentUser.isPremium
                  ? 'Você possui acesso ilimitado a todos os recursos!'
                  : 'Desbloqueie voz realista, gramática e conversas ilimitadas.',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const PaywallScreen()),
                ).then((_) {
                  setState(() {});
                });
              },
            ),
            _buildSectionHeader('Preferências do Aplicativo'),
            _buildSettingsSwitchTile(
              icon: Icons.notifications_active_rounded,
              title: 'Lembrete de Ofensiva',
              subtitle: 'Notificar diariamente às 20:00 para manter a ofensiva ativa.',
              value: _streakReminderEnabled,
              onChanged: (value) async {
                if (value) {
                  if (!UserService.hasCustomProfile) {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          backgroundColor: AppTheme.surfaceColor,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                          title: const Text('Perfil Necessário', style: TextStyle(color: Colors.white)),
                          content: const Text(
                            'Você precisa criar um perfil personalizado para poder ativar os lembretes de ofensiva.',
                            style: TextStyle(color: Colors.white70),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Cancelar', style: TextStyle(color: Colors.white60)),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                                _showEditProfileDialog(context, 'Estudante', 0);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppTheme.accentColor,
                                foregroundColor: Colors.black,
                              ),
                              child: const Text('Criar Perfil'),
                            ),
                          ],
                        );
                      },
                    );
                    return;
                  }
                  final granted = await NotificationService.requestPermission();
                  setState(() {
                    _streakReminderEnabled = granted;
                  });
                } else {
                  await NotificationService.updateReminderState(false);
                  setState(() {
                    _streakReminderEnabled = false;
                  });
                }
              },
            ),
            _buildSettingsTile(
              icon: Icons.tune_rounded,
              title: 'Velocidade e Tom da Voz',
              subtitle: 'Ajuste a velocidade e o timbre do tutor.',
              onTap: _showTtsSpeedDialog,
            ),
            _buildSettingsTile(
              icon: Icons.record_voice_over_rounded,
              title: 'Voz do Tutor (TTS)',
              subtitle: 'Escolha um timbre de voz diferente para o tutor.',
              onTap: _showTtsVoiceDialog,
            ),
            _buildSettingsTile(
              icon: AppTheme.isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
              title: 'Mudar para o Modo ${AppTheme.isDark ? 'Claro' : 'Escuro'}',
              subtitle: 'Altere a aparência de todo o aplicativo.',
              onTap: () {
                AppTheme.themeNotifier.value = AppTheme.isDark ? ThemeMode.light : ThemeMode.dark;
                setState(() {});
              },
            ),
            _buildSettingsTile(
              icon: Icons.help_outline_rounded,
              title: 'Como Usar o Aplicativo',
              subtitle: 'Entenda os recursos e a metodologia.',
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const HowToUseScreen()));
              },
            ),
            const SizedBox(height: 32),
            _buildSectionHeader('Suporte e Comunidade'),
            _buildSettingsTile(
              icon: Icons.star_rounded,
              title: 'Avalie o Aplicativo',
              subtitle: 'Deixe sua avaliação de 5 estrelas na Google Play!',
              onTap: () {
                _launchUrl('https://play.google.com/store/apps/details?id=$appId');
              },
            ),
            _buildSettingsTile(
              icon: Icons.share_rounded,
              title: 'Compartilhe com Amigos',
              subtitle: 'Ajude seus amigos a aprenderem $langName grátis.',
              onTap: () {
                SharePlus.instance.share(
                  ShareParams(text: 'Baixe o ${AppConfig.appName} na Google Play: https://play.google.com/store/apps/details?id=$appId'),
                );
              },
            ),
            const SizedBox(height: 32),
            _buildSectionHeader('Sobre'),
            _buildSettingsTile(
              icon: Icons.privacy_tip_rounded,
              title: 'Política de Privacidade',
              subtitle: 'Termos e diretrizes obrigatórias da loja.',
              onTap: () {
                _launchUrl('https://comunicarmarketing.com.br/privacy/privacy.html');
              },
            ),
            _buildSettingsTile(
              icon: Icons.info_outline_rounded,
              title: 'Versão do App',
              subtitle: '${AppConfig.appName} v1.0.0',
              onTap: () {},
            ),
            _buildSettingsTile(
              icon: Icons.logout_rounded,
              title: 'Sair e Redefinir Perfil',
              subtitle: 'Apaga todo o seu progresso local e perfil.',
              onTap: () {
                _showResetConfirmDialog(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, bottom: 8, top: 16),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
          color: AppTheme.accentColor,
          fontSize: 12,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: AppTheme.isDark ? Colors.white.withAlpha(10) : Colors.black.withAlpha(5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.isDark ? Colors.white.withAlpha(15) : Colors.black.withAlpha(10)),
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppTheme.primaryColor.withAlpha(50),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: AppTheme.isDark ? Colors.white : AppTheme.primaryColor),
        ),
        title: Text(title, style: TextStyle(color: AppTheme.isDark ? Colors.white : AppTheme.primaryColor, fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle, style: TextStyle(color: AppTheme.isDark ? Colors.white54 : AppTheme.primaryColor.withAlpha(150), fontSize: 13)),
        trailing: Icon(Icons.chevron_right_rounded, color: AppTheme.isDark ? Colors.white38 : AppTheme.primaryColor.withAlpha(100)),
        onTap: onTap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }

  Widget _buildSettingsSwitchTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: AppTheme.isDark ? Colors.white.withAlpha(10) : Colors.black.withAlpha(5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.isDark ? Colors.white.withAlpha(15) : Colors.black.withAlpha(10)),
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppTheme.primaryColor.withAlpha(50),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: AppTheme.isDark ? Colors.white : AppTheme.primaryColor),
        ),
        title: Text(title, style: TextStyle(color: AppTheme.isDark ? Colors.white : AppTheme.primaryColor, fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle, style: TextStyle(color: AppTheme.isDark ? Colors.white54 : AppTheme.primaryColor.withAlpha(150), fontSize: 13)),
        trailing: Switch(
          value: value,
          onChanged: onChanged,
          activeThumbColor: AppTheme.accentColor,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }
}
