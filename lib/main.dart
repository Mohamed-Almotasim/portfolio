import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:portfolio/app.dart';
import 'package:portfolio/core/state/project_assets_provider.dart';
import 'package:portfolio/core/theme/app_typography.dart';

void main() {
  final binding = WidgetsFlutterBinding.ensureInitialized();
  usePathUrlStrategy();
  // Fonts are bundled in assets/google_fonts; never fall back to the CDN.
  GoogleFonts.config.allowRuntimeFetching = false;
  final container = ProviderContainer();
  // No frame reaches the screen (so the HTML splash stays) until fonts are
  // in and we know which project footage exists (no placeholder flash).
  binding.deferFirstFrame();
  Future.wait([
    preloadFonts(),
    container.read(projectAssetsProvider.future),
  ]).whenComplete(binding.allowFirstFrame).ignore();
  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const PortfolioApp(),
    ),
  );
}
