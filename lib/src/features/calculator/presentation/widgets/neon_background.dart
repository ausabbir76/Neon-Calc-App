import 'package:flutter/material.dart';
import '../../../../app/theme/models/calculator_theme.dart';

class NeonBackground extends StatefulWidget {
  const NeonBackground({
    required this.child,
    required this.theme,
    this.animate = true,
    this.trigger,
    this.isZoomed = false,
    this.shakeToken = 0,
    super.key,
  });

  final Widget child;
  final CalculatorTheme theme;
  final bool animate;
  final dynamic trigger;
  final bool isZoomed;
  final int shakeToken;

  @override
  State<NeonBackground> createState() => _NeonBackgroundState();
}

class _NeonBackgroundState extends State<NeonBackground>
    with SingleTickerProviderStateMixin {
  bool _isInitialized = false;
  late final AnimationController _shakeController;
  late final Animation<Offset> _shakeAnimation;

  @override
  void initState() {
    super.initState();

    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    // Rapid shake sequence
    _shakeAnimation =
        TweenSequence<Offset>([
          TweenSequenceItem(
            tween: Tween(begin: Offset.zero, end: const Offset(8, 0)),
            weight: 1,
          ),
          TweenSequenceItem(
            tween: Tween(begin: const Offset(8, 0), end: const Offset(-8, 0)),
            weight: 2,
          ),
          TweenSequenceItem(
            tween: Tween(begin: const Offset(-8, 0), end: const Offset(8, 0)),
            weight: 2,
          ),
          TweenSequenceItem(
            tween: Tween(begin: const Offset(8, 0), end: const Offset(-8, 0)),
            weight: 2,
          ),
          TweenSequenceItem(
            tween: Tween(begin: const Offset(-8, 0), end: Offset.zero),
            weight: 1,
          ),
        ]).animate(
          CurvedAnimation(parent: _shakeController, curve: Curves.easeInOut),
        );

    if (widget.animate) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() => _isInitialized = true);
        }
      });
    } else {
      _isInitialized = true;
    }
  }

  @override
  void didUpdateWidget(covariant NeonBackground oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.shakeToken != oldWidget.shakeToken && widget.shakeToken > 0) {
      _shakeController.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _shakeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Stack(
        children: [
          // 1. Animated Background Layer
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _shakeAnimation,
              builder: (context, child) {
                return Transform.translate(
                  offset: _shakeAnimation.value,
                  child: child,
                );
              },
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 1500),
                switchInCurve: Curves.easeOutCubic,
                switchOutCurve: Curves.easeInCubic,
                layoutBuilder:
                    (Widget? currentChild, List<Widget> previousChildren) {
                      return Stack(
                        fit: StackFit.expand,
                        alignment: Alignment.center,
                        children: <Widget>[
                          ...previousChildren,
                          ?currentChild,
                        ],
                      );
                    },
                transitionBuilder: (Widget child, Animation<double> animation) {
                  // Check if the child being built is the incoming theme background
                  final isIncoming =
                      child.key is ValueKey &&
                      (child.key as ValueKey).value.toString().startsWith(
                        widget.theme.type.toString(),
                      );

                  if (isIncoming && widget.animate) {
                    return FadeTransition(
                      opacity: animation,
                      child: ScaleTransition(
                        scale: Tween<double>(begin: 2, end: 1.0).animate(
                          CurvedAnimation(
                            parent: animation,
                            curve: Curves.easeOutCubic,
                          ),
                        ),
                        child: child,
                      ),
                    );
                  } else {
                    return FadeTransition(opacity: animation, child: child);
                  }
                },
                child: _isInitialized
                    ? _buildBackgroundContent(widget.theme)
                    : const SizedBox.shrink(key: ValueKey('empty_background')),
              ),
            ),
          ),

          // 2. The Main Content (UI)
          widget.child,
        ],
      ),
    );
  }

  Widget _buildBackgroundContent(CalculatorTheme theme) {
    // We wrap the background layers in an AnimatedScale for the "Interactive Zoom"
    return AnimatedScale(
      key: ValueKey('${theme.type}_${widget.trigger ?? ''}'),
      scale: widget.isZoomed ? 1.2 : 1.0,
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeInOutCubic,
      child: Container(
        color: theme.backgroundDark,
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (theme.backgroundImage != null)
              Image.asset(theme.backgroundImage!, fit: BoxFit.cover),
            if (theme.backgroundPainter != null)
              RepaintBoundary(
                child: CustomPaint(painter: theme.backgroundPainter),
              ),
          ],
        ),
      ),
    );
  }
}
