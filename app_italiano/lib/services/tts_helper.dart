import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_tts/flutter_tts.dart';
import '../config/app_config.dart';

class CuratedVoice {
  final String rawName;
  final String rawLocale;
  final String displayName;
  final bool isMale;

  CuratedVoice({
    required this.rawName,
    required this.rawLocale,
    required this.displayName,
    required this.isMale,
  });
}

class RealisticVoiceConfig {
  static const Map<LanguageTarget, Map<String, String>> languageTutorToOpenAiVoice = {
    LanguageTarget.english: {
      'Emily': 'nova',
      'Sophia': 'shimmer',
      'Chloe': 'alloy',
      'Lily': 'nova',
      'Grace': 'shimmer',
      'John': 'onyx',
      'Daniel': 'echo',
      'James': 'fable',
      'Paul': 'onyx',
      'Harry': 'echo',
    },
    LanguageTarget.french: {
      'Camille': 'nova',
      'Chloé': 'shimmer',
      'Léa': 'alloy',
      'Manon': 'nova',
      'Sarah': 'shimmer',
      'Lucas': 'onyx',
      'Hugo': 'echo',
      'Thomas': 'fable',
      'Louis': 'onyx',
      'Nathan': 'echo',
    },
    LanguageTarget.spanish: {
      'Isabella': 'nova',
      'Sofia': 'shimmer',
      'Valentina': 'alloy',
      'Camila': 'nova',
      'Lucia': 'shimmer',
      'Mateo': 'onyx',
      'Santiago': 'echo',
      'Matias': 'fable',
      'Sebastian': 'onyx',
      'Diego': 'echo',
    },
    LanguageTarget.german: {
      'Emma': 'nova',
      'Mia': 'shimmer',
      'Sofia': 'alloy',
      'Hannah': 'nova',
      'Emilia': 'shimmer',
      'Ben': 'onyx',
      'Jonas': 'echo',
      'Leon': 'fable',
      'Finn': 'onyx',
      'Noah': 'echo',
    },
    LanguageTarget.italian: {
      'Giulia': 'nova',
      'Sofia': 'shimmer',
      'Alessandro': 'onyx',
      'Marco': 'echo',
    },
  };

  static String getOpenAiVoiceForTutor(String tutorName, LanguageTarget language) {
    final languageVoices = languageTutorToOpenAiVoice[language];
    if (languageVoices != null) {
      return languageVoices[tutorName] ?? 'nova';
    }
    return 'nova';
  }
}

class TtsHelper {
  static const String _tutorNameKey = 'tutor_name';
  static const String _tutorGenderKey = 'tutor_gender';

  static Future<void> initTts(FlutterTts flutterTts) async {
    final prefs = await SharedPreferences.getInstance();
    final speed = prefs.getDouble('tts_speed') ?? 0.35;
    final pitch = prefs.getDouble('tts_pitch') ?? 1.0;
    
    await flutterTts.setLanguage(AppConfig.ttsLocale);
    await flutterTts.setSpeechRate(speed);
    await flutterTts.setPitch(pitch);

    final voiceName = prefs.getString('selected_tts_voice_name');
    final voiceLocale = prefs.getString('selected_tts_voice_locale');
    
    if (voiceName != null && voiceLocale != null) {
      try {
        await flutterTts.setVoice({"name": voiceName, "locale": voiceLocale});
      } catch (e) {
        // Fallback if voice setting fails
        await flutterTts.setLanguage(AppConfig.ttsLocale);
      }
    }
  }

  /// Returns the stored tutor name.
  /// Falls back to localized defaults if not set.
  static Future<String> getStoredTutorName() async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getString(_tutorNameKey);
    if (stored != null) return stored;
    switch (AppConfig.activeLanguage) {
      case LanguageTarget.spanish:
        return 'Isabella';
      case LanguageTarget.french:
        return 'Camille';
      case LanguageTarget.german:
        return 'Emma';
      case LanguageTarget.english:
        return 'Emily';
      case LanguageTarget.italian:
        return 'Giulia';
    }
  }

  static Future<bool> getStoredTutorIsMale() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_tutorGenderKey) ?? false;
  }

  /// Saves the tutor name when the user picks a voice.
  static Future<void> saveTutorName(String name) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tutorNameKey, name);
  }

  static Future<void> saveTutorGender(bool isMale) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_tutorGenderKey, isMale);
  }

  static bool isMaleVoice(String name, String locale) {
    final lowerName = name.toLowerCase();
    
    // 1. Direct male/female indicator
    if (lowerName.contains('male') && !lowerName.contains('female')) {
      return true;
    }
    if (lowerName.contains('female')) {
      return false;
    }
    
    // Custom overrides for specific engine languages with mismatched genders
    if (lowerName.contains('en-ng-language')) {
      return true;
    }
    
    // Specific Italian Google TTS voice overrides (Android)
    if (lowerName.contains('it-it-x-itb-local') || lowerName.contains('it-it-x-itd-local')) {
      return false; // Actually Female
    }
    if (lowerName.contains('it-it-x-itc-local') || lowerName.contains('it-it-x-itg-local') || lowerName.contains('it-it-x-itc-network')) {
      return true; // Actually Male
    }
    
    // 2. Known male names/identifiers on iOS/Android
    final maleIdentifiers = [
      'john', 'daniel', 'oliver', 'james', 'arthur', 'harry', 
      'david', 'robert', 'william', 'michael', 'joseph', 'richard', 
      'charles', 'guy', 'george', 'gordon', 'aaron', 'nathan', 'thomas',
      'peter', 'paul', 'henry', 'brian', 'steve', 'mark', 'andrew',
      'lucas', 'hugo', 'louis', 'mateo', 'santiago', 'matias', 'sebastian',
      'diego', 'alejandro', 'ben', 'jonas', 'leon', 'finn', 'noah', 'luis',
      'nicolas', 'pierre', 'jean', 'jorge', 'juan', 'javier',
      'alessandro', 'marco', 'andrea', 'francesco', 'matteo', 'giovanni', 'davide', 'luca'
    ];
    for (final id in maleIdentifiers) {
      if (lowerName.contains(id)) {
        return true;
      }
    }
    
    // 3. Android Google TTS code patterns (e.g. en-us-x-tpf-local, en-gb-x-gba-local)
    if (lowerName.contains('-x-')) {
      final parts = lowerName.split('-x-');
      if (parts.length > 1) {
        final codePart = parts[1].split('-')[0];
        if (codePart.isNotEmpty) {
          const knownMaleCodes = {
            'iom', 'tpd', 'rjs', 'gbd', 'gdb', 'gdd', 'gdm', 'kdm', 'jc', 
            'gde', 'gdg', 'gdi', 'gdk', 'frb', 'frc', 'fre', 'frg', 'fri', 'gbb'
          };
          const knownFemaleCodes = {
            'sfg', 'iol', 'iog', 'tpf', 'gba', 'gdc', 'gdf', 'fis', 'ana', 'sfy', 'cne', 
            'vlf', 'vif', 'kdf', 'sfd', 'gda', 'gdh', 'gdj', 'fra', 'frd', 'frf', 'frh', 'aud', 'iob'
          };
          
          if (knownMaleCodes.contains(codePart)) {
            return true;
          }
          if (knownFemaleCodes.contains(codePart)) {
            return false;
          }
          
          final lastChar = codePart[codePart.length - 1];
          // Even letters/bdfhjlnprtvxz usually designate male voices in Google TTS
          if ('bdfhjlnprtvxz'.contains(lastChar)) {
            return true;
          } else if ('acegikmoqsuwy'.contains(lastChar)) {
            return false;
          }
        }
      }
    }
    
    return false;
  }
  
  static List<CuratedVoice> getCuratedVoices(List<Map<String, String>> rawVoices, LanguageTarget activeLanguage) {
    final Map<LanguageTarget, List<String>> femaleNamesMap = {
      LanguageTarget.english: ['Emily', 'Sophia', 'Chloe', 'Lily', 'Grace'],
      LanguageTarget.french: ['Camille', 'Chloé', 'Léa', 'Manon', 'Sarah'],
      LanguageTarget.spanish: ['Isabella', 'Sofia', 'Valentina', 'Camila', 'Lucia'],
      LanguageTarget.german: ['Emma', 'Mia', 'Sofia', 'Hannah', 'Emilia'],
      LanguageTarget.italian: ['Giulia', 'Sofia'],
    };

    final Map<LanguageTarget, List<String>> maleNamesMap = {
      LanguageTarget.english: ['John', 'Daniel', 'James', 'Paul', 'Harry'],
      LanguageTarget.french: ['Lucas', 'Hugo', 'Thomas', 'Louis', 'Nathan'],
      LanguageTarget.spanish: ['Mateo', 'Santiago', 'Matias', 'Sebastian', 'Diego'],
      LanguageTarget.german: ['Ben', 'Jonas', 'Leon', 'Finn', 'Noah'],
      LanguageTarget.italian: ['Alessandro', 'Marco'],
    };
 
    final femaleNames = femaleNamesMap[activeLanguage] ?? femaleNamesMap[LanguageTarget.english]!;
    final maleNames = maleNamesMap[activeLanguage] ?? maleNamesMap[LanguageTarget.english]!;

    List<CuratedVoice> femaleVoices = [];
    List<CuratedVoice> maleVoices = [];

    for (final voice in rawVoices) {
      final name = voice['name'] ?? '';
      final locale = voice['locale'] ?? '';
      final isMale = isMaleVoice(name, locale);

      if (isMale) {
        if (maleVoices.length < maleNames.length) {
          final index = maleVoices.length;
          maleVoices.add(CuratedVoice(
            rawName: name,
            rawLocale: locale,
            displayName: maleNames[index],
            isMale: true,
          ));
        }
      } else {
        if (femaleVoices.length < femaleNames.length) {
          final index = femaleVoices.length;
          femaleVoices.add(CuratedVoice(
            rawName: name,
            rawLocale: locale,
            displayName: femaleNames[index],
            isMale: false,
          ));
        }
      }

      if (femaleVoices.length >= femaleNames.length && maleVoices.length >= maleNames.length) {
        break;
      }
    }

    return [...femaleVoices, ...maleVoices];
  }

  static List<CuratedVoice> getRealisticTutors(LanguageTarget activeLanguage) {
    final Map<LanguageTarget, List<String>> femaleNamesMap = {
      LanguageTarget.english: ['Emily', 'Sophia', 'Chloe', 'Lily', 'Grace'],
      LanguageTarget.french: ['Camille', 'Chloé', 'Léa', 'Manon', 'Sarah'],
      LanguageTarget.spanish: ['Isabella', 'Sofia', 'Valentina', 'Camila', 'Lucia'],
      LanguageTarget.german: ['Emma', 'Mia', 'Sofia', 'Hannah', 'Emilia'],
      LanguageTarget.italian: ['Giulia', 'Sofia'],
    };
    final Map<LanguageTarget, List<String>> maleNamesMap = {
      LanguageTarget.english: ['John', 'Daniel', 'James', 'Paul', 'Harry'],
      LanguageTarget.french: ['Lucas', 'Hugo', 'Thomas', 'Louis', 'Nathan'],
      LanguageTarget.spanish: ['Mateo', 'Santiago', 'Matias', 'Sebastian', 'Diego'],
      LanguageTarget.german: ['Ben', 'Jonas', 'Leon', 'Finn', 'Noah'],
      LanguageTarget.italian: ['Alessandro', 'Marco'],
    };

    final females = femaleNamesMap[activeLanguage] ?? femaleNamesMap[LanguageTarget.english]!;
    final males = maleNamesMap[activeLanguage] ?? maleNamesMap[LanguageTarget.english]!;

    final List<CuratedVoice> list = [];
    for (final name in females) {
      list.add(CuratedVoice(
        rawName: name,
        rawLocale: 'OpenAI Cloud',
        displayName: name,
        isMale: false,
      ));
    }
    for (final name in males) {
      list.add(CuratedVoice(
        rawName: name,
        rawLocale: 'OpenAI Cloud',
        displayName: name,
        isMale: true,
      ));
    }
    return list;
  }
}
