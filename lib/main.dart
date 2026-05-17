import 'package:flutter/material.dart';
import 'src/app/calculator_app.dart';
import 'src/app/theme/theme_controller.dart';
import 'src/app/sound/sound_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize the theme controller (loads from SharedPreferences)
  await ThemeController().initialize();
  // Initialize the sound controller
  await SoundController().initialize();

  runApp(const CalculatorApp());
}
