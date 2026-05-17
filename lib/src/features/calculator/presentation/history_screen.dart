import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:neon_calc/src/features/calculator/presentation/calculator_controller.dart';
import 'package:neon_calc/src/features/calculator/presentation/widgets/neon_background.dart';
import '../../../app/theme/theme_controller.dart';
import '../../../app/theme/models/calculator_theme.dart';
import '../../../app/sound/sound_controller.dart';
import '../domain/history_item.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({required this.controller, super.key});

  final CalculatorController controller;

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  late List<HistoryItem> _items;

  @override
  void initState() {
    super.initState();
    _items = List.from(widget.controller.history);
  }

  @override
  Widget build(BuildContext context) {
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
              title: Text('LOGS', style: currentTheme.appBarTitleStyle),
              centerTitle: true,
              leading: IconButton(
                icon: Icon(
                  currentTheme.icons.back,
                  color: currentTheme.appBarIconColor,
                  size: 40,
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
              actions: [
                if (_items.isNotEmpty)
                  _GlowIconButton(
                    icon: currentTheme.icons.deleteSweep,
                    color: currentTheme.historyDeleteIconColor,
                    onPressed: () => _showClearDialog(context),
                  ),
                const SizedBox(width: 8),
              ],
              shape: currentTheme.appBarBorder,
            ),
          ),
        ),
      ),
      body: NeonBackground(
        theme: currentTheme,
        animate: false,
        child: _items.isEmpty
            ? const _EmptyHistoryState()
            : AnimatedList(
                key: _listKey,
                initialItemCount: _items.length,
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).padding.top + kToolbarHeight + 20,
                  bottom:
                      MediaQuery.of(context).padding.bottom +
                      kBottomNavigationBarHeight +
                      12,
                  left: 20,
                  right: 20,
                ),
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, index, animation) {
                  return _buildAnimatedItem(_items[index], animation, index);
                },
              ),
      ),
    );
  }

  Widget _buildAnimatedItem(
    HistoryItem item,
    Animation<double> animation,
    int index,
  ) {
    final scaleAnimation = CurvedAnimation(
      parent: animation,
      curve: const Interval(0.4, 1.0, curve: Curves.easeOutCubic),
    );

    final sizeAnimation = CurvedAnimation(
      parent: animation,
      curve: const Interval(0.0, 0.8, curve: Curves.easeInOutCubic),
    );

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: SizeTransition(
        sizeFactor: sizeAnimation,
        axisAlignment: -1.0,
        child: FadeTransition(
          opacity: scaleAnimation,
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.8, end: 1.0).animate(scaleAnimation),
            child: _HistoryItemWidget(
              item: item,
              onTap: (expression) => Navigator.of(context).pop(expression),
              onDelete: () => _removeItem(index),
            ),
          ),
        ),
      ),
    );
  }

  void _removeItem(int index) {
    if (index < 0 || index >= _items.length) return;

    SoundController().playHistoryDelete();
    final removedItem = _items.removeAt(index);
    _listKey.currentState?.removeItem(
      index,
      (context, animation) => _buildAnimatedItem(removedItem, animation, index),
      duration: const Duration(milliseconds: 350),
    );

    if (removedItem.id != null) {
      widget.controller.deleteHistoryItem(removedItem.id!);
    }

    if (_items.isEmpty) setState(() {});
  }

  Future<void> _clearAll() async {
    SoundController().playHistoryDelete();
    final count = _items.length;
    for (var i = count - 1; i >= 0; i--) {
      final removedItem = _items.removeAt(i);
      _listKey.currentState?.removeItem(
        i,
        (context, animation) => _buildAnimatedItem(removedItem, animation, i),
        duration: const Duration(milliseconds: 300),
      );
      await Future.delayed(const Duration(milliseconds: 60));
    }
    await widget.controller.clearHistory();
    setState(() {});
  }

  void _showClearDialog(BuildContext context) {
    final currentTheme = ThemeController().currentTheme;
    SoundController().playAlert();

    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Dismiss',
      barrierColor: Colors.transparent,
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, animation, secondaryAnimation) =>
          const SizedBox.shrink(),
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        final curve = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutCubic,
        );
        return ScaleTransition(
          scale: Tween<double>(begin: 0.9, end: 1.0).animate(curve),
          child: FadeTransition(
            opacity: curve,
            child: Dialog(
              backgroundColor: Colors.transparent,
              elevation: 0,
              insetPadding: const EdgeInsets.symmetric(horizontal: 24),
              child: _buildThemedDialogContent(context, currentTheme),
            ),
          ),
        );
      },
    );
  }

  Widget _buildThemedDialogContent(
    BuildContext context,
    CalculatorTheme theme,
  ) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(theme.borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: theme.dialogBlur,
          sigmaY: theme.dialogBlur,
        ),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: theme.dialogDecoration,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icon Section
              Container(
                padding: const EdgeInsets.all(16),
                decoration: theme.getDialogIconDecoration(theme.primaryColor),
                child: Icon(
                  theme.icons.warning,
                  color: theme.primaryColor,
                  size: 40,
                ),
              ),
              const SizedBox(height: 24),
              // Title
              Text(
                theme.getDialogTitle('warning'),
                textAlign: TextAlign.center,
                style: theme.dialogTitleStyle,
              ),
              const SizedBox(height: 16),
              // Message
              Text(
                theme.getDialogMessage('warning'),
                textAlign: TextAlign.center,
                style: theme.dialogMessageStyle,
              ),
              const SizedBox(height: 32),
              // Buttons
              Row(
                children: [
                  Expanded(
                    child: _ThemedDialogButton(
                      label: theme.getDialogCancelLabel('warning'),
                      color: Colors.white38,
                      onPressed: () => Navigator.of(context).pop(),
                      theme: theme,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _ThemedDialogButton(
                      label: theme.getDialogConfirmLabel('warning'),
                      color: theme.primaryColor,
                      onPressed: () {
                        Navigator.of(context).pop();
                        _clearAll();
                      },
                      theme: theme,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ThemedDialogButton extends StatelessWidget {
  final String label;
  final Color color;
  final VoidCallback onPressed;
  final CalculatorTheme theme;

  const _ThemedDialogButton({
    required this.label,
    required this.color,
    required this.onPressed,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: theme.getDialogButtonDecoration(color),
        child: Center(
          child: Text(label, style: theme.getDialogButtonTextStyle(color)),
        ),
      ),
    );
  }
}

class _HistoryItemWidget extends StatefulWidget {
  const _HistoryItemWidget({
    required this.item,
    required this.onTap,
    required this.onDelete,
  });

  final HistoryItem item;
  final Function(String) onTap;
  final VoidCallback onDelete;

  @override
  State<_HistoryItemWidget> createState() => _HistoryItemWidgetState();
}

class _HistoryItemWidgetState extends State<_HistoryItemWidget> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final currentTheme = ThemeController().currentTheme;
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapCancel: () => setState(() => _pressed = false),
      onTapUp: (_) async {
        // Keep the pressed state visible for a moment
        SoundController().playHistoryTap();
        await Future.delayed(const Duration(milliseconds: 150));
        if (mounted) {
          setState(() => _pressed = false);
          widget.onTap(widget.item.expression);
        }
      },
      child: AnimatedContainer(
        margin: EdgeInsets.symmetric(horizontal: _pressed ? 4 : 0),
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.all(12),
        decoration: currentTheme.getHistoryItemDecoration(_pressed),
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.item.expression,
                      style: currentTheme.historyExpressionStyle,
                    ),
                    const SizedBox(height: 8),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        widget.item.result,
                        style: currentTheme.historyResultStyle,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            _GlowIconButton(
              onPressed: widget.onDelete,
              icon: currentTheme.icons.delete,
              color: currentTheme.historyDeleteIconColor,
            ),
            Icon(
              currentTheme.icons.arrowForward,
              color: Colors.white.withValues(alpha: 0.2),
            ),
          ],
        ),
      ),
    );
  }
}

class _GlowIconButton extends StatefulWidget {
  const _GlowIconButton({
    required this.onPressed,
    required this.icon,
    required this.color,
  });

  final VoidCallback onPressed;
  final IconData icon;
  final Color color;

  @override
  State<_GlowIconButton> createState() => _GlowIconButtonState();
}

class _GlowIconButtonState extends State<_GlowIconButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _glowAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentTheme = ThemeController().currentTheme;

    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapCancel: () => _controller.reverse(),
      onTapUp: (_) async {
        // Ensure the glow plays out fully
        await _controller.forward();
        await _controller.reverse();
        widget.onPressed();
      },
      child: AnimatedBuilder(
        animation: _glowAnimation,
        builder: (context, child) {
          return Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              shape: currentTheme.type == ThemeType.retro
                  ? BoxShape.rectangle
                  : BoxShape.circle,
              border: currentTheme.type == ThemeType.retro
                  ? Border.all(
                      color: widget.color.withValues(
                        alpha: _glowAnimation.value > 0 ? 1 : 0.3,
                      ),
                      width: 2,
                    )
                  : null,
              boxShadow: [
                if (currentTheme.type != ThemeType.retro)
                  BoxShadow(
                    color: widget.color.withValues(
                      alpha: _glowAnimation.value * 0.5,
                    ),
                    blurRadius: 15 * _glowAnimation.value,
                    spreadRadius: 2 * _glowAnimation.value,
                  ),
              ],
            ),
            child: Icon(
              widget.icon,
              color: currentTheme.type == ThemeType.retro
                  ? widget.color
                  : Color.lerp(
                      widget.color.withValues(alpha: 0.7),
                      widget.color,
                      _glowAnimation.value,
                    ),
            ),
          );
        },
      ),
    );
  }
}

class _EmptyHistoryState extends StatefulWidget {
  const _EmptyHistoryState();

  @override
  State<_EmptyHistoryState> createState() => _EmptyHistoryStateState();
}

class _EmptyHistoryStateState extends State<_EmptyHistoryState>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _scaleAnimation = Tween<double>(begin: 1.5, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentTheme = ThemeController().currentTheme;

    return SizedBox.expand(
      child: Center(
        child: FutureBuilder<void>(
          future: Future.delayed(const Duration(milliseconds: 300)),
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const SizedBox.shrink();
            }
            return ScaleTransition(
              scale: _scaleAnimation,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(currentTheme.borderRadius),
                child: BackdropFilter(
                  filter: ImageFilter.blur(
                    sigmaX: currentTheme.dialogBlur,
                    sigmaY: currentTheme.dialogBlur,
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                        currentTheme.borderRadius,
                      ),
                      border: Border.all(
                        color: Colors.grey.withValues(alpha: 0.3),
                        width: 2,
                      ),
                      color: Colors.transparent,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 96,
                          height: 96,
                          decoration: currentTheme.emptyStateIconDecoration,
                          child: Icon(
                            currentTheme.icons.history,
                            size: 64,
                            color: currentTheme.emptyStateIconColor,
                          ),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          'NO DATA FOUND',
                          style: currentTheme.appBarTitleStyle.copyWith(
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Memory core is currently empty.',
                          textAlign: TextAlign.center,
                          style: currentTheme.dialogMessageStyle,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
