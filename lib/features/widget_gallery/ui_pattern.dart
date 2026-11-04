import 'package:flutter/widgets.dart';
import 'package:portfolio/features/widget_gallery/widgets/authentication_preview.dart';
import 'package:portfolio/features/widget_gallery/widgets/dashboard_preview.dart';
import 'package:portfolio/features/widget_gallery/widgets/empty_state_preview.dart';
import 'package:portfolio/features/widget_gallery/widgets/loading_skeleton_preview.dart';
import 'package:portfolio/features/widget_gallery/widgets/profile_card_preview.dart';
import 'package:portfolio/features/widget_gallery/widgets/settings_preview.dart';

enum UiPatternCategory {
  form('Form'),
  dashboard('Dashboard'),
  settings('Settings'),
  feedback('Feedback'),
  card('Card');

  const UiPatternCategory(this.label);
  final String label;
}

class UiPattern {
  const UiPattern({
    required this.name,
    required this.description,
    required this.category,
    required this.preview,
  });

  final String name;
  final String description;
  final UiPatternCategory category;
  final Widget preview;

  bool matches(String query) {
    final q = query.toLowerCase();
    return name.toLowerCase().contains(q) ||
        description.toLowerCase().contains(q) ||
        category.label.toLowerCase().contains(q);
  }
}

const uiPatterns = [
  UiPattern(
    name: 'Authentication Form',
    description: 'Login & signup form with validation',
    category: UiPatternCategory.form,
    preview: AuthenticationPreview(),
  ),
  UiPattern(
    name: 'Dashboard Panel',
    description: 'Stats + chart layout',
    category: UiPatternCategory.dashboard,
    preview: DashboardPreview(),
  ),
  UiPattern(
    name: 'Settings Page',
    description: 'User preferences & toggles',
    category: UiPatternCategory.settings,
    preview: SettingsPreview(),
  ),
  UiPattern(
    name: 'Empty State',
    description: 'No data UI with CTA',
    category: UiPatternCategory.feedback,
    preview: EmptyStatePreview(),
  ),
  UiPattern(
    name: 'Loading Skeleton',
    description: 'Shimmer loading placeholder',
    category: UiPatternCategory.feedback,
    preview: LoadingSkeletonPreview(),
  ),
  UiPattern(
    name: 'Profile Card',
    description: 'User profile summary UI',
    category: UiPatternCategory.card,
    preview: ProfileCardPreview(),
  ),
];
