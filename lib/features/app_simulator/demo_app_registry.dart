import 'package:flutter/material.dart';
import 'package:portfolio/features/app_simulator/demos/chat_demo.dart';
import 'package:portfolio/features/app_simulator/demos/dashboard_demo.dart';
import 'package:portfolio/features/app_simulator/demos/task_manager_demo.dart';

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
    const DemoApp(
      title: 'Task Manager Demo',
      description:
          'A simple task management app where you can add, remove, and toggle tasks.',
      demoWidget: TaskManagerDemo(),
    ),
    const DemoApp(
      title: 'Chat UI Demo',
      description: 'A chat interface with message bubbles and input field.',
      demoWidget: ChatDemo(),
    ),
    const DemoApp(
      title: 'Dashboard Demo',
      description: 'A responsive dashboard with navigation and content areas.',
      demoWidget: DashboardDemo(),
    ),
  ];
}
