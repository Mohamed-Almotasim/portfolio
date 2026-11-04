import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../widgets/glass_tilt_card/glass_tilt_model.dart';
import '../widgets/glass_tilt_card/glass_tilt_widget.dart';

class GlassTiltCardDemo extends StatelessWidget {
  const GlassTiltCardDemo({super.key});

  static const GlassCardData _cardData = GlassCardData(
    title: 'Glass Tilt Card',
    description:
        'Move across the surface to tilt the card,',
    icon: Icons.flare_rounded,
  );

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: theme.colorScheme.outlineVariant),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                const Color(0xFF0F172A).withValues(alpha: 0.96),
                const Color(0xFF1E3A8A).withValues(alpha: 0.78),
                const Color(0xFF111827).withValues(alpha: 0.92),
              ],
            ),
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              const horizontalPadding = 48.0;
              const reservedHeaderHeight = 170.0;
              const cardAspectRatio = 1.18;

              final availableWidth = math.max(
                220.0,
                constraints.maxWidth - horizontalPadding,
              );
              final availableHeight = math.max(
                180.0,
                constraints.maxHeight - reservedHeaderHeight,
              );
              final cardWidth = math.min(
                math.min(availableWidth, 420.0),
                availableHeight * cardAspectRatio,
              );

              return Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '3D Tilt + Light Reflection',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'A glassmorphism card that reacts like a physical object with tilt, glare, depth, and hover lift.',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: Colors.white.withValues(alpha: 0.82),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Expanded(
                      child: Center(
                        child: SizedBox(
                          width: cardWidth,
                          child: const GlassTiltCard(data: _cardData),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
