import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:portfolio/core/routing/app_router.dart';
import 'package:portfolio/core/theme/app_theme.dart';

class PortfolioApp extends ConsumerWidget {
  const PortfolioApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Portfolio',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      routerConfig: ref.watch(routerProvider),
    );
  }
}
