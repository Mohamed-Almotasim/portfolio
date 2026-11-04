import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/demo/demo_component.dart';

class ThemeSwitcherDemo extends ConsumerStatefulWidget {
  const ThemeSwitcherDemo({super.key});

  @override
  ConsumerState<ThemeSwitcherDemo> createState() => _ThemeSwitcherDemoState();
}

class _ThemeSwitcherDemoState extends ConsumerState<ThemeSwitcherDemo>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Color?> _backgroundAnimation;
  ThemeMode _currentTheme = ThemeMode.light;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _backgroundAnimation =
        ColorTween(begin: Colors.white, end: const Color(0xFF1a1a1a)).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeInOut,
          ),
        );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _switchTheme(ThemeMode theme) {
    setState(() {
      _currentTheme = theme;
      switch (theme) {
        case ThemeMode.light:
          _backgroundAnimation = ColorTween(
            begin: _backgroundAnimation.value,
            end: Colors.white,
          ).animate(_animationController);
          break;
        case ThemeMode.dark:
          _backgroundAnimation = ColorTween(
            begin: _backgroundAnimation.value,
            end: const Color(0xFF1a1a1a),
          ).animate(_animationController);
          break;
        case ThemeMode.system:
          _backgroundAnimation = ColorTween(
            begin: _backgroundAnimation.value,
            end: const Color(0xFF6366f1),
          ).animate(_animationController);
          break;
      }
    });
    _animationController.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    return DemoComponent(
      title: "Theme Switcher Demo",
      description:
          "A theme switcher panel that demonstrates smooth UI transitions and state management. Toggle between light, dark, and gradient modes with animated background changes.",
      label: "UI Pattern",
      demoWidget: AnimatedBuilder(
        animation: _backgroundAnimation,
        builder: (context, child) {
          return Container(
            constraints: const BoxConstraints(minHeight: 220),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: _backgroundAnimation.value,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.12),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(_getThemeIcon(), size: 56, color: _getThemeIconColor()),
                const SizedBox(height: 16),
                Text(
                  _getThemeName(),
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: _getThemeTextColor(),
                  ),
                ),
                const SizedBox(height: 24),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  alignment: WrapAlignment.center,
                  children: [
                    _ThemeButton(
                      icon: Icons.wb_sunny,
                      label: 'Light',
                      isSelected: _currentTheme == ThemeMode.light,
                      onPressed: () => _switchTheme(ThemeMode.light),
                    ),
                    _ThemeButton(
                      icon: Icons.nightlight_round,
                      label: 'Dark',
                      isSelected: _currentTheme == ThemeMode.dark,
                      onPressed: () => _switchTheme(ThemeMode.dark),
                    ),
                    _ThemeButton(
                      icon: Icons.palette,
                      label: 'Gradient',
                      isSelected: _currentTheme == ThemeMode.system,
                      onPressed: () => _switchTheme(ThemeMode.system),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
      codeSnippet: '''
class ThemeSwitcherDemo extends ConsumerStatefulWidget {
  // Animated theme switcher with smooth transitions
  // Demonstrates state management and UI animations
  // Features light, dark, and gradient modes
}''',
    );
  }

  IconData _getThemeIcon() {
    switch (_currentTheme) {
      case ThemeMode.light:
        return Icons.wb_sunny;
      case ThemeMode.dark:
        return Icons.nightlight_round;
      case ThemeMode.system:
        return Icons.palette;
    }
  }

  Color _getThemeIconColor() {
    switch (_currentTheme) {
      case ThemeMode.light:
        return Colors.orange;
      case ThemeMode.dark:
        return Colors.blue;
      case ThemeMode.system:
        return Colors.purple;
    }
  }

  String _getThemeName() {
    switch (_currentTheme) {
      case ThemeMode.light:
        return 'Light Mode';
      case ThemeMode.dark:
        return 'Dark Mode';
      case ThemeMode.system:
        return 'Gradient Mode';
    }
  }

  Color _getThemeTextColor() {
    switch (_currentTheme) {
      case ThemeMode.light:
        return Colors.black87;
      case ThemeMode.dark:
        return Colors.white;
      case ThemeMode.system:
        return Colors.white;
    }
  }
}

class _ThemeButton extends StatelessWidget {
  const _ThemeButton({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onPressed,
  });

  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: isSelected
            ? theme.colorScheme.primary.withValues(alpha: 0.15)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isSelected
              ? theme.colorScheme.primary
              : theme.colorScheme.outline.withValues(alpha: 0.5),
          width: isSelected ? 1.5 : 1,
        ),
      ),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(24),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 18,
              color: isSelected
                  ? theme.colorScheme.primary
                  : theme.colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected
                    ? theme.colorScheme.primary
                    : theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
