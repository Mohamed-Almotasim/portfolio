import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:portfolio/app.dart';
import 'package:portfolio/core/theme/app_typography.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  usePathUrlStrategy();
  // Fonts are bundled in assets/google_fonts; never fall back to the CDN.
  GoogleFonts.config.allowRuntimeFetching = false;
  await preloadFonts();
  runApp(const ProviderScope(child: PortfolioApp()));
}
