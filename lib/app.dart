import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:portfolio/core/routing/app_router.dart';
import 'package:portfolio/core/state/theme_mode_provider.dart';
import 'package:portfolio/core/theme/app_spacing.dart';
import 'package:portfolio/core/theme/app_theme.dart';

class PortfolioApp extends ConsumerWidget {
  const PortfolioApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final compact = AppBreakpoints.isMobile(context);
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Portfolio',
      theme: AppTheme.light(compact: compact),
      darkTheme: AppTheme.dark(compact: compact),
      themeMode: ref.watch(themeModeProvider),
      routerConfig: ref.watch(routerProvider),
    );
  }
}
