import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:portfolio/core/theme/app_spacing.dart';
import 'package:portfolio/l10n/app_localizations.dart';
import 'package:portfolio/shared/layout/locale_transition_host.dart';

/// The other language, to switch to.
Locale otherLocale(BuildContext context) =>
    Localizations.localeOf(context).languageCode == 'ar'
    ? const Locale('en')
    : const Locale('ar');

/// The toggle's label: the other language's own name. Always in the Arabic
/// face, because the English theme's fonts have no Arabic glyphs.
Text languageLabel(BuildContext context) => Text(
  AppLocalizations.of(context).switchLanguage,
  style: GoogleFonts.ibmPlexSansArabic(
    textStyle: Theme.of(context).textTheme.labelMedium,
    letterSpacing: 0,
  ),
);

/// Navbar button that switches between English and Arabic through the
/// [LocaleTransitionHost]. Disabled while the transition runs.
class LanguageToggle extends StatelessWidget {
  const LanguageToggle({super.key});

  @override
  Widget build(BuildContext context) {
    final host = LocaleTransitionHost.of(context);
    return ValueListenableBuilder(
      valueListenable: host.running,
      builder: (context, running, _) => TextButton(
        onPressed: running
            ? null
            : () => host.switchLocale(otherLocale(context)),
        style: TextButton.styleFrom(
          foregroundColor: Theme.of(context).colorScheme.onSurface,
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s12),
        ),
        child: languageLabel(context),
      ),
    );
  }
}
