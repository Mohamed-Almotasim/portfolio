# Flutter Portfolio Architecture

This document describes the architecture of the Flutter Web portfolio project.

The purpose is to demonstrate professional Flutter development structure.

---

# High Level Structure

```
lib/
  core/
  shared/
  features/
  app.dart    # MaterialApp.router (light + dark theme, follows system)
  main.dart   # runApp(ProviderScope(...))
```

Each layer has a clear responsibility.

---

# Core Layer

`lib/core/` holds global infrastructure. It contains no UI pages.

```
core/
  theme/      app_theme.dart — Material 3 light/dark themes
  routing/    app_router.dart — GoRouter config
  state/      developer_mode_provider.dart — global providers
  dev_mode/   developer_info.dart
```

---

# Shared Layer

`lib/shared/` holds reusable UI building blocks. Shared widgets stay generic and must not depend on feature pages.

```
shared/
  layout/   AppPage (page wrapper), responsive grid
  demo/     DemoComponent (preview + optional code viewer)
  theme/    app_spacing.dart
  widgets/  navbar, footer, code viewer, device frame, hover card, ...
```

---

# Features Layer

`lib/features/` contains the portfolio sections, mostly one folder per route:

```
features/
  landing/         /
  ui_showcase/     /ui-showcase
  widget_gallery/  /widget-gallery
  architecture/    /architecture
  services/        /services
  contact/         /contact
  app_simulator/   /app-demos
  projects/        (no route; feeds the landing page's featured projects)
```

Each feature folder contains its page widget and small helper widgets.

---

# Routing System

Navigation uses GoRouter, defined in `core/routing/app_router.dart`.

```
/
/ui-showcase
/widget-gallery
/architecture
/services
/contact
/app-demos
```

---

# State Management

State management uses Riverpod. Global providers live in `core/state/`; feature-local providers live next to their page (e.g. `widget_gallery/widget_gallery_search_provider.dart`).

`developerModeProvider` controls whether additional technical information is shown.

---

# Developer Mode

Developer Mode lets technical visitors see how the project is built: when enabled, `DemoComponent` shows the source snippet under each live preview. Normal visitors see only the UI.

---

# Layout System

Every page is wrapped in `AppPage`:

* sticky navbar (inline links on desktop, `Drawer` at ≤ 600 px)
* content constrained to a max width of **1100 px**
* footer and scroll-to-top button

---

# Widget Gallery Design

Each gallery item includes:

1. UI preview
2. explanation
3. code snippet

Code snippets should be readable and selectable.

---

# UI Showcase and App Demos

`/ui-showcase` renders demos listed in `DemoRegistry`. `/app-demos` renders full app demos from `DemoAppRegistry` inside a device frame.

These are demonstrations only and include no backend logic.

---

# Animation Strategy

Animations should be subtle and lightweight, built with Flutter's own tools (`AnimatedContainer`, `AnimatedOpacity`, `AnimatedSwitcher`, `TweenAnimationBuilder`, `Hero`, or explicit `AnimationController`s). No animation packages.

---

# Performance Considerations

The portfolio targets Flutter Web, so prefer const widgets, avoid heavy rebuilds, and keep state management simple.

---

# Design Goals

The portfolio should feel like a real application.

Visitors should think:

"This developer writes production quality Flutter code."
