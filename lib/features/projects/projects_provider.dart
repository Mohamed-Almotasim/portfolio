import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:portfolio/features/projects/project_model.dart';

final projectsProvider = Provider<List<Project>>((ref) {
  return const [
    Project(
      title: 'E-Commerce App',
      description:
          'A full-featured e-commerce application with user authentication, product catalog, shopping cart, and payment integration.',
      techStack: ['Flutter', 'Firebase', 'Stripe', 'Riverpod'],
      demoUrl: 'https://demo.example.com',
      githubUrl: 'https://github.com/example/ecommerce',
    ),
    Project(
      title: 'Task Management Tool',
      description:
          'A collaborative task management application with real-time updates, team collaboration, and project tracking.',
      techStack: ['Flutter', 'Dart', 'SQLite', 'WebSocket'],
      demoUrl: 'https://demo.example.com/taskmanager',
      githubUrl: 'https://github.com/example/taskmanager',
    ),
    Project(
      title: 'Weather Dashboard',
      description:
          'A beautiful weather dashboard with location-based forecasts, interactive maps, and weather alerts.',
      techStack: ['Flutter', 'REST API', 'Geolocation', 'Charts'],
      demoUrl: 'https://demo.example.com/weather',
      githubUrl: 'https://github.com/example/weather',
    ),
  ];
});
