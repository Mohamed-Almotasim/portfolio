# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Commands

```bash
flutter run -d chrome          # Run on web (primary target)
flutter analyze                # Static analysis / lint check
flutter test                   # Run all tests
flutter build web              # Production web build
flutter test test/<file>_test.dart  # Run a single test file (test/ is currently empty)
```

Stack: Flutter web, Riverpod 2 (`ProviderScope` in `main.dart`), GoRouter, `url_launcher`, `equatable`. Design intent and spec live in `docs/architecture.md` and `docs/portfolio_spec.md`.

## Architecture

Three top-level layers under `lib/`:

- **`core/`** — App-wide singletons: `theme/app_theme.dart` (Material 3 light/dark; `app.dart` sets no `themeMode`, so it follows the system), `routing/app_router.dart` (static GoRouter), `state/developer_mode_provider.dart` (Riverpod `StateProvider<bool>` toggled from the navbar/drawer), `dev_mode/developer_info.dart`.
- **`shared/`** — Reusable building blocks consumed across features: `AppPage` layout wrapper, `DemoComponent` shell, responsive layout helpers, and common widgets (navbar, footer, hover card, device frame, code viewer).
- **`features/`** — Mostly one folder per route; folder names don't always match the path (see table). `features/projects/` has no route and feeds the landing page's featured projects via `projectsProvider`. Feature-local state is plain Riverpod `StateProvider`s next to the page (e.g. `widget_gallery_search_provider.dart`).
- Interactive simulator widgets (`features/app_simulator/widgets/<name>/`) are split into `*_controller.dart`, `*_model.dart`, `*_widget.dart`; follow that triplet for new ones.

### Routes (`core/routing/app_router.dart`)

| Path | Page | Folder |
|---|---|---|
| `/` | `LandingPage` | `landing/` |
| `/ui-showcase` | `UIShowcasePage` — demos from `DemoRegistry` | `ui_showcase/` |
| `/widget-gallery` | `UIPatternsPage` — searchable/filterable pattern library | `widget_gallery/` |
| `/architecture` | `ArchitecturePage` | `architecture/` |
| `/services` | `ServicesPage` | `services/` |
| `/contact` | `ContactPage` | `contact/` |
| `/app-demos` | `AppSimulatorPage` — full app demos in a device frame | `app_simulator/` |

### Key shared patterns

- **`AppPage`** (`shared/layout/app_page.dart`) — wrap every page. Provides sticky navbar, 1100 px max-width constraint, padding, footer, and scroll-to-top button. Mobile (≤ 600 px) gets a `Drawer`; desktop gets an inline horizontal navbar.
- **`DemoComponent`** (`shared/demo/demo_component.dart`) — wrap individual widget showcases. Shows a live preview always; shows a `CodeViewer` with the source snippet only when `developerModeProvider` is `true`.
- **Registries** — `DemoRegistry` (`features/ui_showcase/`) lists `UIShowcasePage` demos; `DemoAppRegistry` (`features/app_simulator/`) lists full-app demos for the device-frame simulator.

## AI Guardrails (from `AI_RULES.md`)

1. Never invent new folders.
2. Ask before creating any new file.
3. Only modify files explicitly listed in the prompt.
4. Do not introduce new packages.
5. Use Flutter built-in widgets and animations (`AnimatedContainer`, `AnimatedOpacity`, `AnimatedSwitcher`, `TweenAnimationBuilder`, `Hero`) — no animation packages.
6. Keep the codebase intentionally small and focused; prefer simple solutions.
7. Respect the `core/` / `shared/` / `features/` boundaries; Firebase is allowed only for an optional contact form.

## Theme

Defined in `core/theme/app_theme.dart`. Primary seed color `#1976D2` (blue). Uses Material 3 (`useMaterial3: true`). Add spacing constants to `shared/theme/app_spacing.dart`.
