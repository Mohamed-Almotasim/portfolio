import 'package:flutter/material.dart';

import 'package:portfolio/features/app_simulator/widgets/magnetic_card_grid/magnetic_model.dart';
import 'package:portfolio/features/app_simulator/widgets/magnetic_card_grid/magnetic_widget.dart';

class MagneticCardGridDemo extends StatelessWidget {
  const MagneticCardGridDemo({super.key});

  static const List<MagneticCardData> _sampleCards = [
    MagneticCardData(
      title: 'Portfolio Engine',
      subtitle: 'Modular UI systems, case studies, and product storytelling.',
      color: Color(0xFF0F766E),
    ),
    MagneticCardData(
      title: 'Motion Lab',
      subtitle:
          'Interactive motion studies with magnetic depth and soft inertia.',
      color: Color(0xFF2563EB),
    ),
    MagneticCardData(
      title: 'Client Dashboards',
      subtitle: 'Responsive interface experiments tuned for clarity and speed.',
      color: Color(0xFFF59E0B),
    ),
    // MagneticCardData(
    //   title: 'Prototype Stack',
    //   subtitle:
    //       'Hover systems, micro-interactions, and reusable component design.',
    //   color: Color(0xFFDB2777),
    // ),
    // MagneticCardData(
    //   title: 'Realtime Views',
    //   subtitle: 'Signal-rich surfaces that feel alive without looking noisy.',
    //   color: Color(0xFF7C3AED),
    // ),
    // MagneticCardData(
    //   title: 'Launch Boards',
    //   subtitle: 'Presentation-first tiles that react with depth and intention.',
    //   color: Color(0xFFEA580C),
    // ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest.withValues(
              alpha: 0.35,
            ),
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: theme.colorScheme.outlineVariant),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Magnetic Cards', style: theme.textTheme.headlineSmall),
                const SizedBox(height: 8),
                Text(
                  'Move the cursor near a tile to pull it off-axis. Hover directly to lift, tilt, and intensify the glow.',
                  style: theme.textTheme.bodyLarge,
                ),
                const SizedBox(height: 20),
                const Expanded(child: MagneticCardGrid(cards: _sampleCards)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
