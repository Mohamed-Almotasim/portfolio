import 'package:flutter/material.dart';
import 'package:portfolio/l10n/app_localizations.dart';

abstract final class AppRoutes {
  static const home = '/';
  static const work = '/work';
  static String caseStudy(String slug) => '/work/$slug';
  static const playground = '/playground';
  static String specimen(String slug) => '/playground/$slug';
  static const about = '/about';

  /// About, scrolled to "How this site is built".
  static const aboutBuilt = '/about?section=built';
  static const contact = '/contact';

  // Old URLs, kept as redirects.
  static const uiShowcase = '/ui-showcase'; // → playground
  static const widgetGallery = '/widget-gallery'; // → playground
  static const appDemos = '/app-demos'; // → playground
  static const architecture = '/architecture'; // → aboutBuilt
  static const services = '/services'; // → contact
}

class NavDestination {
  const NavDestination({
    required this.label,
    required this.path,
    required this.icon,
  });

  /// English; widgets show [localizedLabel].
  final String label;
  final String path;
  final IconData icon;

  String localizedLabel(AppLocalizations l10n) => switch (path) {
    AppRoutes.work => l10n.navWork,
    AppRoutes.playground => l10n.navPlayground,
    AppRoutes.about => l10n.navAbout,
    AppRoutes.contact => l10n.navContact,
    _ => label,
  };
}

/// Single source for the navbar, drawer and footer links, in display order.
/// Home is the wordmark.
const navDestinations = [
  NavDestination(label: 'Work', path: AppRoutes.work, icon: Icons.work_outline),
  NavDestination(
    label: 'Playground',
    path: AppRoutes.playground,
    icon: Icons.widgets_outlined,
  ),
  NavDestination(
    label: 'About',
    path: AppRoutes.about,
    icon: Icons.person_outline,
  ),
  NavDestination(label: 'Contact', path: AppRoutes.contact, icon: Icons.mail),
];
