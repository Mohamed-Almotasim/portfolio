import 'package:flutter/material.dart';
import 'package:portfolio/features/app_simulator/demos/chat_demo.dart';
import 'package:portfolio/features/app_simulator/demos/dashboard_demo.dart';
import 'package:portfolio/features/app_simulator/demos/glass_tilt_card_demo.dart';
import 'package:portfolio/features/app_simulator/demos/magnetic_card_grid_demo.dart';
import 'package:portfolio/features/app_simulator/demos/origami_grid_animation_demo.dart';
import 'package:portfolio/features/app_simulator/demos/task_manager_demo.dart';

class DemoApp {
  const DemoApp({
    required this.title,
    required this.description,
    required this.demoWidget,
    required this.uiPatterns,
    required this.layoutStructure,
    required this.widgetsUsed,
    required this.tryHint,
    this.useDeviceFrame = true,
  });

  final String title;
  final String description;
  final Widget demoWidget;
  final String uiPatterns;
  final String layoutStructure;
  final String widgetsUsed;

  /// One line telling the visitor what to do once the demo is open.
  final String tryHint;
  final bool useDeviceFrame;
}

class DemoAppRegistry {
  static const List<DemoApp> demos = [
    DemoApp(
      title: 'Task Manager Demo',
      description:
          'A simple task management app where you can add, remove, and toggle tasks.',
      demoWidget: TaskManagerDemo(),
      tryHint: 'Add a task, tick it off, then delete it.',
      uiPatterns:
          'List-based UI with input forms, checkboxes for state management, and action buttons for CRUD operations.',
      layoutStructure:
          'Column layout with input row at top, expanded list view below, using ListTile for items.',
      widgetsUsed:
          'Scaffold, AppBar, TextField, ElevatedButton, ListView, ListTile, Checkbox, IconButton.',
    ),
    DemoApp(
      title: 'Chat UI Demo',
      description: 'A chat interface with message bubbles and input field.',
      demoWidget: ChatDemo(),
      tryHint: 'Type a message and send it; the list scrolls to it.',
      uiPatterns:
          'Message bubbles with alignment, scrollable lists, and input fields with send actions.',
      layoutStructure:
          'Column with expanded ListView for messages and fixed input area at bottom.',
      widgetsUsed:
          'Scaffold, AppBar, ListView, Container, Text, TextField, ElevatedButton, ScrollController.',
    ),
    DemoApp(
      title: 'Dashboard Demo',
      description: 'A responsive dashboard with navigation and content areas.',
      demoWidget: DashboardDemo(),
      tryHint: 'See how the sidebar and stat cards share a phone-width screen.',
      uiPatterns:
          'Multi-panel layout with navigation sidebar, statistics cards, and activity feeds.',
      layoutStructure:
          'Row with fixed-width sidebar and expanded main content area, using Cards for sections.',
      widgetsUsed:
          'Scaffold, AppBar, Row, Container, Column, Card, ListTile, Text, Icon.',
    ),
  ];

  /// Shown under "My Animations"; rendered full-canvas, without a device frame.
  static const List<DemoApp> animations = [
    DemoApp(
      title: 'Magnetic Card Grid',
      description:
          'A responsive grid of cards that pull toward the cursor, lift on hover,',
      demoWidget: MagneticCardGridDemo(),
      tryHint: 'Move your cursor across the grid; cards lean toward it.',
      useDeviceFrame: false,
      uiPatterns:
          'Interactive card grid with global pointer tracking, proximity-based motion, hover lift, tilt, and parallax text shifts.',
      layoutStructure:
          'Responsive 1 to 4 column grid driven by LayoutBuilder, with independent card tiles listening to a shared controller.',
      widgetsUsed:
          'Scaffold, LayoutBuilder, Wrap, MouseRegion, TweenAnimationBuilder, Transform, ValueNotifier, GestureDetector.',
    ),
    DemoApp(
      title: 'Origami Grid Animation',
      description:
          'A responsive paper-fortune-teller style fold animation driven by reusable step data.',
      demoWidget: OrigamiGridAnimationDemo(),
      tryHint: 'Tap the animation to pause and resume the fold.',
      useDeviceFrame: false,
      uiPatterns:
          'Layered 2x2 panel animation with data-driven transforms, responsive square constraints, and tap-to-pause interaction.',
      layoutStructure:
          'Scaffold-based demo screen with a centered square animation area that scales through LayoutBuilder and AspectRatio.',
      widgetsUsed:
          'Scaffold, LayoutBuilder, Stack, Positioned, Transform, AnimatedBuilder, GestureDetector, AnimationController.',
    ),
    DemoApp(
      title: 'Glass Tilt Card',
      description:
          'A glassmorphism card with 3D tilt, moving glare, parallax depth, and hover lift.',
      demoWidget: GlassTiltCardDemo(),
      tryHint: 'Hover and move across the card to tilt it.',
      useDeviceFrame: false,
      uiPatterns:
          'Single interactive hero card with layered glass surfaces, cursor-driven glare, parallax content, and depth-based hover polish.',
      layoutStructure:
          'Centered responsive card demo inside a constrained full-canvas surface, using LayoutBuilder and AspectRatio for scale control.',
      widgetsUsed:
          'Scaffold, MouseRegion, LayoutBuilder, Stack, BackdropFilter, ClipRRect, TweenAnimationBuilder, Transform, ShaderMask.',
    ),
  ];
}
