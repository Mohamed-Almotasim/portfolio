import 'package:flutter/material.dart';
import 'demos/dashboard_card_demo.dart';
import 'demos/kanban_board_demo.dart';
import 'demos/theme_switcher_demo.dart';
import 'demos/pricing_card_demo.dart';
import 'demos/smart_search_demo.dart';
import 'demos/faq_accordion_demo.dart';

class DemoRegistry {
  static List<Widget> getDemos() {
    return [
      const DashboardCardDemo(),
      const KanbanBoardDemo(),
      const ThemeSwitcherDemo(),
      const PricingCardDemo(),
      const SmartSearchDemo(),
      const FaqAccordionDemo(),
    ];
  }
}
