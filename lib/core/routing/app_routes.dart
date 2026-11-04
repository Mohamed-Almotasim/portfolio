import 'package:flutter/material.dart';

abstract final class AppRoutes {
  static const home = '/';
  static const work = '/work';
  static String caseStudy(String slug) => '/work/$slug';
  static const uiShowcase = '/ui-showcase';
  static const widgetGallery = '/widget-gallery';
  static const appDemos = '/app-demos';
  static const architecture = '/architecture';
  static const services = '/services';
  static const contact = '/contact';
}

class NavDestination {
  const NavDestination({
    required this.label,
    required this.path,
    required this.icon,
  });

  final String label;
  final String path;
  final IconData icon;
}

/// Single source for the navbar, drawer and footer links, in display order.
const navDestinations = [
  NavDestination(label: 'Home', path: AppRoutes.home, icon: Icons.home),
  NavDestination(label: 'Work', path: AppRoutes.work, icon: Icons.work_outline),
  NavDestination(
    label: 'UI Showcase',
    path: AppRoutes.uiShowcase,
    icon: Icons.widgets,
  ),
  NavDestination(
    label: 'UI Patterns',
    path: AppRoutes.widgetGallery,
    icon: Icons.dashboard_customize,
  ),
  NavDestination(
    label: 'App Demos',
    path: AppRoutes.appDemos,
    icon: Icons.phone_android,
  ),
  NavDestination(
    label: 'Architecture',
    path: AppRoutes.architecture,
    icon: Icons.account_tree,
  ),
  NavDestination(
    label: 'Services',
    path: AppRoutes.services,
    icon: Icons.design_services,
  ),
  NavDestination(label: 'Contact', path: AppRoutes.contact, icon: Icons.mail),
];
