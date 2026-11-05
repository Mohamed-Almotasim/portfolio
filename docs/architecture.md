# Architecture

How the portfolio is put together, and the rules that keep it that way.

## Layers

```
lib/
  main.dart     preload fonts, path URLs, runApp(ProviderScope)
  app.dart      MaterialApp.router: light/dark themes, themeMode, router
  core/         app-wide infrastructure, no pages
  shared/       reusable layout, widgets and utils, no feature imports
  features/     one folder per area of the site
```

Dependencies point inward: `features` may use `shared` and `core`; `shared` may use `core`; `core` never imports a feature (except the router, which wires pages to paths).

## core/

| Folder | Contents |
|---|---|
| `content/` | Immutable, const models (`Profile`, `CaseStudy`, `ServiceOffering`, `Skill`, `ProcessStep`, `EngagementModel`, `FaqItem`, `ProofStat`) and **all site copy** in `portfolio_content.dart`. `TODO(me)` marks what the owner must fill in. |
| `routing/` | `app_routes.dart` (path constants + `navDestinations`, the single source for navbar, drawer and footer), `app_router.dart` (`createRouter`, `routerProvider`, `pageTitle`). |
| `state/` | Global Notifiers: `themeModeProvider` (dark by default), `developerModeProvider`, `profileProvider`. |
| `theme/` | The design system: `app_colors.dart` (palette, light/dark `ColorScheme`), `app_typography.dart` (Archivo Expanded / IBM Plex Sans / IBM Plex Mono, responsive sizes, `lead`, and `preloadFonts`, which main() waits on before the first frame), `app_spacing.dart` (4px spacing scale, margins, radius, breakpoints, `AppMotion` tokens), `app_decorations.dart` (`ThemeExtension` for rules, the accent roles, code, floating shadows, status colours), `code_syntax.dart`, `app_theme.dart` (component themes). |

## shared/

| Folder | Contents |
|---|---|
| `layout/` | `AppShell` (Scaffold, drawer, sticky navbar; built once by the `ShellRoute`), `AppPage` (per-page scroll, max width, title, `SelectionArea`, footer, back-to-top), `ResponsiveGrid`, `DeferredPage`. |
| `demo/` | `DemoComponent` (live preview + real source in developer mode) and `source_snippet.dart` (extracts `// #region snippet` blocks from bundled source files). |
| `widgets/` | Navbar, footer, brand logo, theme toggle, hover card, code viewer + `dart_highlighter`, device frame, FAQ accordion, CTA band, `AnimatedSection` (scroll reveal), `LazyInView`. |
| `utils/` | `link_launcher.dart`: `linkLauncherProvider` (overridable in tests) and `openLink`, which opens web links in a new tab and reports failures. |

## features/

| Folder | Route | Notes |
|---|---|---|
| `landing/` | `/` | Hero (mesh backdrop, layered visual), proof strip, sections. |
| `work/` | `/work`, `/work/:slug` | Filterable case studies (`workTechFilterProvider`), detail page, Hero cover. |
| `services/` | `/services` | Offerings, process, engagement models, FAQ. |
| `playground/` | `/playground[?tab=patterns]` | Tabs over `ui_showcase/` (components) and `widget_gallery/` (patterns). `/ui-showcase` and `/widget-gallery` redirect here. Deferred-loaded. |
| `app_simulator/` | `/app-demos` | `DemoAppRegistry`; demos in `DeviceFrame`; heavy animations follow the `*_controller / *_model / *_widget` triplet. Deferred-loaded. |
| `architecture/` | `/architecture` | Diagrams, flows, details, notes on this codebase. |
| `contact/` | `/contact` | Validated form → JSON POST to `contactFormEndpoint` (Formspree) when set, else a prefilled `mailto:` (`contact_mailto.dart`). |
| `not_found/` | any unknown path | 404 inside the shell. |

## Routing

- `ShellRoute` keeps the navbar alive between pages; each `GoRoute` uses a `CustomTransitionPage` (fade + slight slide; none under reduced motion) wrapped in a `Title` for the browser tab.
- Path URL strategy on the web; hosts must rewrite unknown paths to `index.html` (see README).
- `/work/:slug` is a sibling of `/work`, not a child: a child route keeps the parent page laid out offstage, which breaks its `SelectionArea`.
- Routes don't request focus on push; `AppShell` orders traversal so keyboard users reach the navbar first.

## State

Riverpod 3. Content is exposed through plain `Provider`s; UI state uses `Notifier`s with intent methods (`toggle()`, `set()`, `setQuery()`, `setCategory()`, `setTech()`). Widgets read providers, never `portfolio_content.dart` directly.

## Design system rules

- Colours only from `Theme.of(context).colorScheme` or `AppDecorations`; never `Colors.*` in UI.
- Spacing and radii from `AppSpacing` / `AppRadius`; breakpoints from `AppBreakpoints` (mobile < 600, tablet < 1024).
- Fonts are bundled under `assets/google_fonts/` and preloaded; runtime fetching is disabled.
- Cards declare elevation once: hairline border at rest, shadow on hover.

## Testing

`test/helpers/pump_app.dart` pumps the full app (ProviderScope + router + theme) with real fonts. The suite covers:

- every route at 320–1920 px with no layout errors, and at 1.3× text;
- routing (404, redirects, deep links, case-study slugs, tab URLs), the drawer, nav persistence and Tab order;
- the contact form (validation, success, failure, double submit) with a fake launcher;
- theme toggle and developer-mode snippets;
- unit tests for content validity, Notifiers, filters, the snippet extractor and the highlighter.

`test/tool/` holds opt-in generators (icons, screenshots) that only run when their environment variable is set.
