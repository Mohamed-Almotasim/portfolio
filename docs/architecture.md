# Flutter Portfolio Architecture

This document describes the architecture of the Flutter Web portfolio project.

The purpose is to demonstrate professional Flutter development structure.

---

# High Level Structure

The project follows a modular structure.

```
lib/

core/
shared/
features/

app.dart
main.dart
```

Each layer has a clear responsibility.

---

# Core Layer

Location:

```
lib/core/
```

Purpose:

Global infrastructure used across the application.

Subfolders:

theme
constants
routing
state
utils

Examples:

theme → app_theme.dart
routing → app_router.dart
state → global providers such as developer mode

The core layer should not contain UI pages.

---

# Shared Layer

Location:

```
lib/shared/
```

Purpose:

Reusable UI building blocks.

Subfolders:

widgets
components
animations

Examples:

widgets → navbar, layout containers
components → cards, buttons, UI elements
animations → reusable animation helpers

Shared widgets should remain generic.

They must not depend on specific feature pages.

---

# Features Layer

Location:

```
lib/features/
```

Purpose:

Contains the actual portfolio sections.

Each feature represents one page.

Structure example:

```
features/
  landing/
  ui_showcase/
  widget_gallery/
  architecture_demo/
  services/
  contact/
```

Each feature folder contains:

* page widget
* small helper widgets

---

# Routing System

Navigation uses GoRouter.

Routes:

```
/
/ui-showcase
/widget-gallery
/architecture
/services
/contact
```

The router is defined in:

```
core/routing/app_router.dart
```

---

# State Management

State management uses Riverpod.

Global providers live in:

```
core/state/
```

Example:

developer_mode_provider.dart

The developer mode state controls whether additional technical information is shown.

---

# Developer Mode

Developer Mode is a key feature of the portfolio.

Purpose:

Allow technical visitors to see how the project is built.

Example content when enabled:

* widget explanations
* architecture notes
* state management usage
* development decisions

Normal visitors see only the UI.

---

# Layout System

Pages should use a consistent layout pattern.

Example:

Navigation bar
Responsive container
Page content

The responsive container should limit page width to roughly:

1200px

This improves readability on large screens.

---

# Widget Gallery Design

The widget gallery demonstrates reusable components.

Each item includes:

1. UI preview
2. explanation
3. code snippet

Code snippets should be readable and selectable.

---

# UI Showcase

This section demonstrates example UI screens.

Examples may include:

login screen
dashboard layout
profile UI
product card layout

These are demonstrations only.

They do not include backend logic.

---

# Animation Strategy

Animations should be subtle and lightweight.

Recommended Flutter tools:

AnimatedContainer
AnimatedOpacity
AnimatedSwitcher
TweenAnimationBuilder

Avoid animation libraries unless necessary.

---

# Performance Considerations

The portfolio targets Flutter Web.

Therefore:

Prefer const widgets.

Avoid heavy rebuilds.

Avoid complex state management.

Keep UI efficient.

---

# Design Goals

The portfolio should feel like a real application.

Visitors should think:

"This developer writes production quality Flutter code."

The architecture should communicate professionalism and clarity.
