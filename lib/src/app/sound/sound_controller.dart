import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../theme/models/calculator_theme.dart';

class SoundController extends ChangeNotifier {
  static final SoundController _instance = SoundController._internal();
  factory SoundController() => _instance;

  SoundController._internal();

  final AudioPlayer _player = AudioPlayer();
  bool _isSoundEnabled = true;

  bool get isSoundEnabled => _isSoundEnabled;

  Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    _isSoundEnabled = prefs.getBool('is_sound_enabled') ?? true;
    notifyListeners();
  }

  Future<void> toggleSound(bool enabled) async {
    _isSoundEnabled = enabled;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_sound_enabled', enabled);
    notifyListeners();
  }

  Future<void> _playSound(String fileName) async {
    if (!_isSoundEnabled) return;
    try {
      await _player.stop();
      await _player.setSource(AssetSource('sounds/$fileName'));
      await _player.resume();
    } catch (e) {
      debugPrint('Error playing sound assets/sounds/$fileName: $e');
    }
  }

  void playDigit() => _playSound('digit.mp3');
  void playOperator() => _playSound('operator.mp3');
  void playEqual() => _playSound('equal.mp3');
  void playCommand() => _playSound('memory.mp3');
  void playDelete() => _playSound('delete.mp3');
  void playModeSwitch() => _playSound('mode_switch.mp3');
  void playTopButton() => _playSound('top_button.mp3');
  void playHistoryTap() => _playSound('history_tap.mp3');
  void playHistoryDelete() => _playSound('history_delete.mp3');
  void playAlert() => _playSound('alert.mp3');

  void playThemeSound(ThemeType type) {
    final fileName = switch (type) {
      ThemeType.neon => 'theme_neon.mp3',
      ThemeType.retro => 'theme_retro.mp3',
      ThemeType.cyber => 'theme_cyber.mp3',
      ThemeType.synthwave => 'theme_synthwave.mp3',
      ThemeType.glass => 'theme_glass.mp3',
      ThemeType.amberGlass => 'theme_amber_glass.mp3',
      ThemeType.classic => 'theme_classic.mp3',
    };
    _playSound(fileName);
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }
}
