import 'package:flutter/material.dart';
import 'package:portfolio/features/ui_showcase/demos/analytics_dashboard_demo_card.dart';
import 'package:portfolio/features/ui_showcase/demos/dashboard_card_demo.dart';
import 'package:portfolio/features/ui_showcase/demos/faq_accordion_demo.dart';
import 'package:portfolio/features/ui_showcase/demos/pricing_card_demo.dart';
import 'package:portfolio/features/ui_showcase/demos/smart_search_demo.dart';
import 'package:portfolio/features/ui_showcase/demos/theme_switcher_demo.dart';

class DemoRegistry {
  static List<Widget> getDemos() {
    return [
      const DashboardCardDemo(),
      const AnalyticsDashboardDemoCard(),
      const ThemeSwitcherDemo(),
      const PricingCardDemo(),
      const SmartSearchDemo(),
      const FaqAccordionDemo(),
    ];
  }
}
