import 'package:flutter/material.dart';
import 'package:portfolio/features/app_simulator/demo_app_registry.dart';
import 'package:portfolio/features/app_simulator/demos/glass_tilt_card_demo.dart';
import 'package:portfolio/features/app_simulator/demos/magnetic_card_grid_demo.dart';
import 'package:portfolio/features/app_simulator/demos/origami_grid_animation_demo.dart';
import 'package:portfolio/features/app_simulator/widgets/app_demo_card.dart';
import 'package:portfolio/shared/layout/app_page.dart';
import 'package:portfolio/shared/layout/responsive_grid.dart';

class AppSimulatorPage extends StatelessWidget {
  const AppSimulatorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppPage(
      title: 'Interactive App Demos',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Explore interactive mini Flutter applications embedded right in this portfolio. Click "Launch Demo" to interact with real Flutter UI components.',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 32),
          ResponsiveGrid(
            childAspectRatio: 1.58,
            children: DemoAppRegistry.demos.map((demo) {
              return AppDemoCard(
                title: demo.title,
                description: demo.description,
                demoWidget: demo.demoWidget,
                uiPatterns: _getUiPatterns(demo.title),
                layoutStructure: _getLayoutStructure(demo.title),
                widgetsUsed: _getWidgetsUsed(demo.title),
              );
            }).toList(),
          ),
          const SizedBox(height: 40),
          Text(
            'My Animations',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 12),
          Text(
            'A space for custom motion studies and reusable animation widgets.',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 24),
          const ResponsiveGrid(
            childAspectRatio: 1.7,
            children: [
              AppDemoCard(
                title: 'Magnetic Card Grid',
                description:
                    'A responsive grid of cards that pull toward the cursor, lift on hover,',
                demoWidget: MagneticCardGridDemo(),
                useDeviceFrame: false,
                uiPatterns:
                    'Interactive card grid with global pointer tracking, proximity-based motion, hover lift, tilt, and parallax text shifts.',
                layoutStructure:
                    'Responsive 1 to 4 column grid driven by LayoutBuilder, with independent card tiles listening to a shared controller.',
                widgetsUsed:
                    'Scaffold, LayoutBuilder, Wrap, MouseRegion, TweenAnimationBuilder, Transform, ValueNotifier, GestureDetector.',
              ),
              AppDemoCard(
                title: 'Origami Grid Animation',
                description:
                    'A responsive paper-fortune-teller style fold animation driven by reusable step data.',
                demoWidget: OrigamiGridAnimationDemo(),
                useDeviceFrame: false,
                uiPatterns:
                    'Layered 2x2 panel animation with data-driven transforms, responsive square constraints, and tap-to-pause interaction.',
                layoutStructure:
                    'Scaffold-based demo screen with a centered square animation area that scales through LayoutBuilder and AspectRatio.',
                widgetsUsed:
                    'Scaffold, LayoutBuilder, Stack, Positioned, Transform, AnimatedBuilder, GestureDetector, AnimationController.',
              ),
              AppDemoCard(
                title: 'Glass Tilt Card',
                description:
                    'A glassmorphism card with 3D tilt, moving glare, parallax depth, and hover lift.',
                demoWidget: GlassTiltCardDemo(),
                useDeviceFrame: false,
                uiPatterns:
                    'Single interactive hero card with layered glass surfaces, cursor-driven glare, parallax content, and depth-based hover polish.',
                layoutStructure:
                    'Centered responsive card demo inside a constrained full-canvas surface, using LayoutBuilder and AspectRatio for scale control.',
                widgetsUsed:
                    'Scaffold, MouseRegion, LayoutBuilder, Stack, BackdropFilter, ClipRRect, TweenAnimationBuilder, Transform, ShaderMask.',
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _getUiPatterns(String title) {
    switch (title) {
      case 'Task Manager Demo':
        return 'List-based UI with input forms, checkboxes for state management, and action buttons for CRUD operations.';
      case 'Chat UI Demo':
        return 'Message bubbles with alignment, scrollable lists, and input fields with send actions.';
      case 'Dashboard Demo':
        return 'Multi-panel layout with navigation sidebar, statistics cards, and activity feeds.';
      default:
        return '';
    }
  }

  String _getLayoutStructure(String title) {
    switch (title) {
      case 'Task Manager Demo':
        return 'Column layout with input row at top, expanded list view below, using ListTile for items.';
      case 'Chat UI Demo':
        return 'Column with expanded ListView for messages and fixed input area at bottom.';
      case 'Dashboard Demo':
        return 'Row with fixed-width sidebar and expanded main content area, using Cards for sections.';
      default:
        return '';
    }
  }

  String _getWidgetsUsed(String title) {
    switch (title) {
      case 'Task Manager Demo':
        return 'Scaffold, AppBar, TextField, ElevatedButton, ListView, ListTile, Checkbox, IconButton.';
      case 'Chat UI Demo':
        return 'Scaffold, AppBar, ListView, Container, Text, TextField, ElevatedButton, ScrollController.';
      case 'Dashboard Demo':
        return 'Scaffold, AppBar, Row, Container, Column, Card, ListTile, Text, Icon.';
      default:
        return '';
    }
  }
}
