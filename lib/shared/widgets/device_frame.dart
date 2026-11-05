import 'package:flutter/material.dart';
import 'package:portfolio/core/theme/app_decorations.dart';

/// A phone with real proportions (360 × 760 logical px, ~19.5:9) and a notch.
/// It scales down to fit whatever space it gets; the screen never scrolls.
/// The child sees a MediaQuery with phone-sized safe-area padding.
class DeviceFrame extends StatelessWidget {
  const DeviceFrame({super.key, required this.child});

  final Widget child;

  static const Size screen = Size(360, 760);
  static const double _bezel = 10;

  @override
  Widget build(BuildContext context) {
    final bezel = AppDecorations.of(context).deviceBezel;
    final shadow = AppDecorations.of(context).shadowElevated;
    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Container(
        width: screen.width + _bezel * 2,
        height: screen.height + _bezel * 2,
        padding: const EdgeInsets.all(_bezel),
        decoration: BoxDecoration(
          color: bezel,
          borderRadius: BorderRadius.circular(44),
          boxShadow: shadow,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(34),
          child: Stack(
            children: [
              Positioned.fill(
                child: MediaQuery(
                  data: MediaQuery.of(context).copyWith(
                    size: screen,
                    padding: const EdgeInsets.only(top: 36, bottom: 20),
                    viewPadding: const EdgeInsets.only(top: 36, bottom: 20),
                  ),
                  child: child,
                ),
              ),
              Align(
                alignment: Alignment.topCenter,
                child: Container(
                  margin: const EdgeInsets.only(top: 10),
                  width: 96,
                  height: 26,
                  decoration: BoxDecoration(
                    color: bezel,
                    borderRadius: BorderRadius.circular(13),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
