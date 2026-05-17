import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:neon_calc/src/features/calculator/presentation/widgets/neon_background.dart';
import '../../../app/theme/theme_controller.dart';
import '../../../app/theme/models/calculator_theme.dart';
import '../../../app/sound/sound_controller.dart';

class ThemeScreen extends StatefulWidget {
  const ThemeScreen({super.key});

  @override
  State<ThemeScreen> createState() => _ThemeScreenState();
}

class _ThemeScreenState extends State<ThemeScreen> {
  late List<CalculatorTheme> _themes;

  @override
  void initState() {
    super.initState();
    _themes = ThemeController().availableThemes;
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: ThemeController(),
      builder: (context, _) {
        final currentTheme = ThemeController().currentTheme;
        return Scaffold(
          extendBody: true,
          extendBodyBehindAppBar: true,
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(kToolbarHeight),
            child: ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: currentTheme.appBarBlur,
                  sigmaY: currentTheme.appBarBlur,
                ),
                child: AppBar(
                  backgroundColor: currentTheme.appBarColor,
                  elevation: 0,
                  title: Text('THEMES', style: currentTheme.appBarTitleStyle),
                  centerTitle: true,
                  leading: IconButton(
                    icon: Icon(
                      currentTheme.icons.back,
                      color: currentTheme.appBarIconColor,
                      size: 40,
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  shape: currentTheme.appBarBorder,
                ),
              ),
            ),
          ),
          body: NeonBackground(
            theme: currentTheme,
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: _themes.length,
                    padding: EdgeInsets.only(
                      top:
                          MediaQuery.of(context).padding.top +
                          kToolbarHeight +
                          24,
                      bottom: 24,
                      left: 20,
                      right: 20,
                    ),
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      final theme = _themes[index];
                      final isSelected = currentTheme.type == theme.type;

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _ThemeItemWidget(
                          theme: theme,
                          isSelected: isSelected,
                          currentActiveTheme: currentTheme,
                          onTap: () {
                            SoundController().playThemeSound(theme.type);
                            ThemeController().setTheme(theme.type);
                          },
                        ),
                      );
                    },
                  ),
                ),
                const _SoundToggleWidget(),
                SizedBox(height: MediaQuery.of(context).padding.bottom + 20),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _SoundToggleWidget extends StatelessWidget {
  const _SoundToggleWidget();

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Listenable.merge([
        SoundController(),
        ThemeController(),
      ]),
      builder: (context, _) {
        final soundController = SoundController();
        final currentTheme = ThemeController().currentTheme;
        final isEnabled = soundController.isSoundEnabled;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: GestureDetector(
            onTap: () => soundController.toggleSound(!isEnabled),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: currentTheme.getThemeItemDecoration(isEnabled),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      shape: currentTheme.type == ThemeType.retro
                          ? BoxShape.rectangle
                          : BoxShape.circle,
                      color: isEnabled
                          ? currentTheme.primaryColor.withValues(alpha: 0.2)
                          : Colors.grey.withValues(alpha: 0.1),
                      border: Border.all(
                        color: isEnabled
                            ? currentTheme.primaryColor
                            : Colors.grey,
                        width: 2,
                      ),
                    ),
                    child: Icon(
                      isEnabled ? Icons.volume_up : Icons.volume_off,
                      color:
                          isEnabled ? currentTheme.primaryColor : Colors.grey,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'SYSTEM AUDIO',
                          style: currentTheme.themeItemTitleStyle,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          isEnabled ? 'AUDIO ACTIVE' : 'AUDIO MUTED',
                          style: currentTheme.themeItemStatusStyle,
                        ),
                      ],
                    ),
                  ),
                  Switch(
                    value: isEnabled,
                    onChanged: (value) => soundController.toggleSound(value),
                    activeThumbColor: currentTheme.primaryColor,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _ThemeItemWidget extends StatelessWidget {
  const _ThemeItemWidget({
    required this.theme,
    required this.isSelected,
    required this.currentActiveTheme,
    required this.onTap,
  });

  final CalculatorTheme theme;
  final bool isSelected;
  final CalculatorTheme currentActiveTheme;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(12),
        decoration: currentActiveTheme.getThemeItemDecoration(isSelected),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                shape: currentActiveTheme.type == ThemeType.retro
                    ? BoxShape.rectangle
                    : BoxShape.circle,
                borderRadius: currentActiveTheme.type == ThemeType.retro
                    ? BorderRadius.zero
                    : null,
                gradient: LinearGradient(
                  colors: [theme.primaryColor, theme.secondaryColor],
                ),
                border: currentActiveTheme.type == ThemeType.retro
                    ? Border.all(
                        color: currentActiveTheme.primaryColor,
                        width: 2,
                      )
                    : null,
              ),
              child: Icon(
                isSelected
                    ? currentActiveTheme.icons.check
                    : theme.icons.settings,
                color: currentActiveTheme.type == ThemeType.retro
                    ? currentActiveTheme.backgroundDark
                    : Colors.white,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    theme.name.toUpperCase(),
                    style: currentActiveTheme.themeItemTitleStyle,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    isSelected ? 'SYSTEM ACTIVE' : 'TAP TO INITIALIZE',
                    style: currentActiveTheme.themeItemStatusStyle,
                  ),
                ],
              ),
            ),
            Icon(
              isSelected
                  ? currentActiveTheme.icons.check
                  : currentActiveTheme.icons.arrowForward,
              color: (currentActiveTheme.type == ThemeType.retro
                  ? currentActiveTheme.primaryColor
                  : Colors.white24),
            ),
          ],
        ),
      ),
    );
  }
}
