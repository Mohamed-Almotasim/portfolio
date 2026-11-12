import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:portfolio/core/routing/app_router.dart';
import 'package:portfolio/core/state/locale_provider.dart';
import 'package:portfolio/core/state/theme_mode_provider.dart';
import 'package:portfolio/core/state/theme_tokens_provider.dart';
import 'package:portfolio/core/theme/app_spacing.dart';
import 'package:portfolio/core/theme/app_theme.dart';
import 'package:portfolio/l10n/app_localizations.dart';
import 'package:portfolio/shared/layout/locale_transition_host.dart';

class PortfolioApp extends ConsumerWidget {
  const PortfolioApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final compact = AppBreakpoints.isMobile(context);
    final tokens = ref.watch(themeTokensProvider);
    final arabic = ref.watch(isArabicProvider);
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Portfolio',
      locale: ref.watch(localeProvider),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: AppTheme.light(compact: compact, arabic: arabic, tokens: tokens),
      darkTheme: AppTheme.dark(
        compact: compact,
        arabic: arabic,
        tokens: tokens,
      ),
      themeMode: ref.watch(themeModeProvider),
      routerConfig: ref.watch(routerProvider),
      // Above every page, so the language transition covers the whole app.
      builder: (context, child) => LocaleTransitionHost(
        onLocaleChanged: ref.read(localeProvider.notifier).set,
        child: child!,
      ),
    );
  }
}
