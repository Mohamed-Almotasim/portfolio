# AI Development Rules – Flutter Portfolio

This file defines strict development rules for AI assistants contributing to this project.

The goal is to prevent hallucinations, architecture drift, unnecessary complexity, and incorrect file creation.

AI assistants must follow these rules exactly.

---

# Core Principles

The portfolio must demonstrate professional Flutter development practices.

The codebase itself is part of the portfolio and should communicate:

* clean architecture
* modular design
* readable code
* reusable components
* performance awareness
* UI/UX quality

This project is intentionally **small and focused**.

Do not increase complexity without a clear reason.

---

# Strict AI Guardrails

AI assistants must follow these rules:

1. You may create, move, rename and delete files inside `lib/`, `test/`, `web/` and `docs/` when the task requires it. List every created/deleted file in your summary.
2. Only these packages are pre-approved: `google_fonts`, `flutter_web_plugins` (SDK). Ask before adding anything else.
3. After every task run `dart format .`, `flutter analyze` (must be zero issues) and `flutter test`.
4. Never use `withOpacity` (use `withValues(alpha:)`). Never hard-code `Colors.*` in UI; use `Theme.of(context).colorScheme` or theme extensions.
5. Follow the defined project architecture.
6. Prefer simple solutions over complex ones.
7. Avoid over-engineering.
8. Use Flutter built-in widgets whenever possible.
9. Keep the code readable and well structured.
10. Avoid deeply nested widgets when unnecessary.

---

# Technology Stack

The project uses the following technologies:

Flutter (Web target)
Dart
Riverpod (state management)
GoRouter (navigation)

Do not introduce additional frameworks.

---

# UI and Design Guidelines

The design should follow these principles:

* clean
* modern
* minimal
* developer-focused
* professional

Avoid overly decorative UI.

Use Material 3 design guidelines.

---

# Theme System

The application must support:

Light Theme
Dark Theme

Themes are defined in:

```
core/theme/app_theme.dart
```

Use a minimal color palette.

Primary accent: blue/teal style.

---

# Animation Guidelines

Animations must be lightweight.

Preferred Flutter animation tools:

* AnimatedContainer
* AnimatedOpacity
* AnimatedSwitcher
* TweenAnimationBuilder
* Hero

Do NOT introduce animation packages unless explicitly requested.

---

# Architecture Rules

The project uses a modular architecture:

```
core/
shared/
features/
```

Each has a specific responsibility.

AI must respect these boundaries.

---

# Folder Responsibilities

core/

Contains global systems used by the entire app:

* theme
* routing
* global state (Riverpod providers)

shared/

Reusable, feature-agnostic widgets and layout. Must not import from `features/`.

features/

One folder per page/section, each self-contained with its own widgets.
