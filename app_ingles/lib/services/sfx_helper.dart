import 'package:flutter/services.dart';
import 'package:audioplayers/audioplayers.dart';

class SfxHelper {
  static final AudioPlayer _audioPlayer = AudioPlayer();

  static Future<void> playCorrect() async {
    try {
      HapticFeedback.lightImpact();
      await _audioPlayer.stop();
      await _audioPlayer.play(AssetSource('sounds/correct.mp3'));
    } catch (e) {
      // Ignore failures silently (e.g. running on simulator/desktop without sound)
    }
  }

  static Future<void> playIncorrect() async {
    try {
      HapticFeedback.vibrate();
      await _audioPlayer.stop();
      await _audioPlayer.play(AssetSource('sounds/incorrect.mp3'));
    } catch (e) {
      // Ignore failures silently
    }
  }

  static void vibrateMicStart() {
    HapticFeedback.mediumImpact();
  }

  static void vibrateMicStop() {
    HapticFeedback.lightImpact();
  }
}
