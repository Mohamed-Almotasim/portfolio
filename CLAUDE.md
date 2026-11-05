# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Commands

```bash
flutter run -d chrome          # Run on web (primary target)
flutter analyze                # Static analysis, must be zero issues
flutter test                   # All tests
flutter test test/work_test.dart   # One file
flutter build web --release    # Production build (add --wasm for WebAssembly)
GENERATE_ICONS=1 flutter test test/tool/generate_icons_test.dart   # Rebuild web icons from Profile.name
SHOT_DIR=out SHOT_PATHS="/,/work" SHOT_W=1280 SHOT_H=900 flutter test test/tool/screenshots_test.dart  # Render pages to PNG
```

Stack: Flutter web, Riverpod 3 (Notifiers), go_router 18 (ShellRoute, path URLs), google_fonts (bundled, runtime fetching off), url_launcher, flutter_web_plugins. Full design notes: `docs/architecture.md`.

## Architecture

- **`core/`**: `content/` (const models + all copy in `portfolio_content.dart`; widgets read it only through providers), `routing/` (`app_routes.dart` paths + `navDestinations`, `app_router.dart` with `createRouter`/`routerProvider`/`pageTitle`), `state/` (theme mode, developer mode, profile Notifiers/providers), `theme/` (design system: colors, typography, spacing/breakpoints, `AppDecorations` extension, code syntax, component themes).
- **`shared/`**: `layout/` (`AppShell` built once by the ShellRoute, `AppPage` per-page scroll wrapper, `ResponsiveGrid`, `DeferredPage`), `demo/` (`DemoComponent`, `source_snippet.dart`), `widgets/`, `utils/link_launcher.dart` (`openLink` + overridable `linkLauncherProvider`).
- **`features/`**: one folder per area (see table). Feature-local state is a `Notifier` next to the page. Simulator widgets (`features/app_simulator/widgets/<name>/`) follow the `*_controller` / `*_model` / `*_widget` triplet.

### Routes

| Path | Page | Folder |
|---|---|---|
| `/` | `LandingPage` | `landing/` |
| `/work`, `/work/:slug` | `WorkPage`, `CaseStudyPage` (404 for unknown slug) | `work/` |
| `/playground[?tab=patterns]` | `PlaygroundPage`, tabs over `ComponentsTab` (`ui_showcase/`) and `PatternsTab` (`widget_gallery/`); deferred | `playground/` |
| `/ui-showcase`, `/widget-gallery` | redirects into `/playground` | |
| `/app-demos` | `AppSimulatorPage`, demos from `DemoAppRegistry`; deferred | `app_simulator/` |
| `/architecture` | `ArchitecturePage` | `architecture/` |
| `/services` | `ServicesPage` | `services/` |
| `/contact` | `ContactPage` (Formspree POST, mailto fallback) | `contact/` |

### Conventions that bite if ignored

- New showcase demo: wrap in `DemoComponent(sourcePath: 'lib/...')`, mark the code to show with `// #region snippet` / `// #endregion`, list the file under `assets:` in `pubspec.yaml` and in `showcaseSnippetSources` (a test enforces markers).
- New app demo: add a `DemoApp` (with `tryHint`) to `DemoAppRegistry` and bump `liveDemoCount` (a test enforces it).
- External links go through `openLink`, never `launchUrl` directly.
- Don't use `pumpAndSettle` in widget tests: the landing page loops animations. Use `pumpApp` / `settle` from `test/helpers/pump_app.dart`, and `setUpAll(loadAppFonts)` for any test that measures layout.
- Don't make `/work/:slug`-style routes children of their list route (offstage parent breaks `SelectionArea`).

## AI Guardrails (from `AI_RULES.md`)

Refactor phase rules:

1. You may create, move, rename and delete files inside `lib/`, `test/`, `web/` and `docs/` when the task requires it. List every created/deleted file in your summary.
2. Only these packages are pre-approved: `google_fonts`, `flutter_web_plugins` (SDK). Ask before adding anything else.
3. After every task run `dart format .`, `flutter analyze` (must be zero issues) and `flutter test`.
4. Never use `withOpacity` (use `withValues(alpha:)`). Never hard-code `Colors.*` in UI; use `Theme.of(context).colorScheme` or theme extensions.
5. Use Flutter built-in widgets and animations (`AnimatedContainer`, `AnimatedOpacity`, `AnimatedSwitcher`, `TweenAnimationBuilder`, `Hero`) — no animation packages.
6. Keep the codebase intentionally small and focused; prefer simple solutions, no over-engineering.
7. Respect the `core/` / `shared/` / `features/` boundaries.

## Theme

`core/theme/`: indigo primary / cyan accent / slate neutrals, hand-tuned light and dark `ColorScheme`s, Space Grotesk (display) + Inter (body) + JetBrains Mono (code). Theme mode comes from `themeModeProvider` (default `ThemeMode.system`, visitor choice kept in localStorage). Use `AppSpacing`, `AppRadius`, `AppBreakpoints` and `AppDecorations.of(context)`; never `Colors.*` in UI.
