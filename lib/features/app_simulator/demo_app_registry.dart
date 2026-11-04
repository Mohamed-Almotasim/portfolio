import 'package:flutter/material.dart';
import 'demos/task_manager_demo.dart';
import 'demos/chat_demo.dart';
import 'demos/dashboard_demo.dart';

class DemoApp {
  final String title;
  final String description;
  final Widget demoWidget;

  const DemoApp({
    required this.title,
    required this.description,
    required this.demoWidget,
  });
}

class DemoAppRegistry {
  static final List<DemoApp> demos = [
    DemoApp(
      title: 'Task Manager Demo',
      description:
          'A simple task management app where you can add, remove, and toggle tasks.',
      demoWidget: const TaskManagerDemo(),
    ),
    DemoApp(
      title: 'Chat UI Demo',
      description: 'A chat interface with message bubbles and input field.',
      demoWidget: const ChatDemo(),
    ),
    DemoApp(
      title: 'Dashboard Demo',
      description: 'A responsive dashboard with navigation and content areas.',
      demoWidget: const DashboardDemo(),
    ),
  ];
}
