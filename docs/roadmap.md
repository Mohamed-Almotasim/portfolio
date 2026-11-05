# Portfolio – Claude Code Roadmap

Step-by-step prompts for finishing, polishing and restructuring the Flutter web portfolio.
Run them in order, one per Claude Code session (or `/clear` between them). Review the diff and commit after each step.

---

## What the audit found

**Bugs that break the site right now**
- `AppPage` calls `Scaffold.of(context)` with a context that sits *above* its own Scaffold, so the mobile hamburger menu throws instead of opening the drawer.
- Dead links: Hero "View Projects" → `/projects` and CTA "View App Demos" → `/app-simulator` point to routes that don't exist. There's no 404 page (`errorBuilder`).
- The desktop navbar has 7 inline links and will overflow between ~600–1000 px.

**Placeholder content a client would notice**
- "Your Name", "Portfolio" as the logo, a person icon as the avatar, `example.com` demo links, `github.com` / `linkedin.com` / `mailto:example@email.com`, and "© 2024".
- The contact form only shows a "Message sent!" SnackBar and sends nothing. The social icons on the contact page do nothing.
- Projects live in two places with different data (`projectsProvider` on the landing page vs. case studies hard-coded inside `ServicesPage.build`). The Services page is titled "Projects" with a section called "App Demos", so it never says what services you offer.
- Several `codeSnippet`s in developer mode are fake (e.g. the theme switcher's "snippet" is an empty class with comments).

**Structure / best-practice issues**
- Nav links are duplicated in 3 places (navbar, drawer, footer). No single source of truth.
- Dead files: `skills_section`, `architecture_section`, `architecture_diagram`, `tech_stack_section`, `service_card`, `demo_card`, `responsive_container`, `reusable_card_demo`, `widget_playground`, plus root scratch files `prompt.text` and `copilot_prompt_template.md`, and an empty `docs/portfolio_spec.md`.
- `kanban_board_demo.dart` / `KanbanBoardDemo` actually renders an "Analytics Dashboard".
- Metadata is looked up by matching title strings (`_getUiPatterns(title)` switch). Patterns are `Map<String, String>` rather than typed models.
- Deprecated APIs: `withOpacity` (17 uses), `surfaceVariant`. Riverpod `StateProvider` is legacy, and go_router 13 is several majors behind.
- Hard-coded colors (`Colors.blue` drawer header, `Colors.blue[50]` dev panel, `Colors.grey.shade300` borders, `Colors.white` avatar icon) break dark mode. There's also no theme toggle, even though a dark theme exists.
- Fixed `childAspectRatio` grids will clip text at some widths. `DeviceFrame` wraps a fixed-height child in a scroll view.
- Web URLs use `/#/`. `index.html` still says "A new Flutter project." / title "portfolio". The README is the default template. There are zero tests.

**Your own rules will block this work.** `AI_RULES.md` / `CLAUDE.md` say "never create files", "never invent folders" and "only modify files listed in the prompt". Step 0 relaxes them, or Claude Code will keep stopping to ask.

---

## Step 0 — Safety net + update the rules

```
Before we change any code:

1. If this folder isn't a git repo, run `git init`, make sure .gitignore covers build/, .dart_tool/, .idea/, and commit everything as "chore: baseline before refactor".
2. Run `flutter --version`, `flutter pub get`, and `flutter analyze` and report the results (don't fix anything yet).
3. Update CLAUDE.md and AI_RULES.md for a refactor phase. Keep the spirit (small, clean, no over-engineering, built-in animations) but replace these rules:
   - "Never create files / never invent folders / only modify listed files" → "You may create, move, rename and delete files inside lib/, test/, web/ and docs/ when the task requires it. List every created/deleted file in your summary."
   - "Do not introduce new packages" → "Only these packages are pre-approved: google_fonts, flutter_web_plugins (SDK). Ask before adding anything else."
   - Add: "After every task run `dart format .`, `flutter analyze` (must be zero issues) and `flutter test`."
   - Add: "Never use withOpacity (use withValues(alpha:)), never hard-code Colors.* in UI. Use Theme.of(context).colorScheme or theme extensions."
   - Remove the Firebase mention unless it's actually used (it isn't).
4. Make docs/architecture.md match reality (1100 px max width, actual routes including /app-demos). Delete the empty docs/portfolio_spec.md.
Commit as "docs: update AI rules for refactor phase".
```

## Step 1 — Fix the crashes and broken navigation

```
Fix these bugs only, nothing cosmetic:

1. lib/shared/layout/app_page.dart: the hamburger calls Scaffold.of(context) using a context above the Scaffold, so it throws. Fix with a GlobalKey<ScaffoldState> or a Builder below the Scaffold.
2. Dead routes: hero_section.dart goes to '/projects' and call_to_action_section.dart goes to '/app-simulator'. Neither exists. Point them at real routes.
3. Add an errorBuilder to the GoRouter with a simple, on-brand 404 page (inside AppPage) and a "Back home" button.
4. The desktop navbar has 7 links and overflows on medium widths. Switch to the drawer/hamburger below ~1024 px (not 600) and make sure nothing overflows from 320 px to 1920 px.
5. Find any other context.go/push targets that don't match a defined route.

Verify by running `flutter run -d chrome`, resizing across widths, and opening the drawer on a narrow window. Report what you changed. Commit "fix: drawer crash, dead routes, navbar overflow, 404 page".
```

## Step 2 — Clean out dead code and deprecated APIs

```
Cleanup pass, behaviour must stay the same:

1. Confirm each of these is unused (grep for imports), then delete it: features/landing/widgets/skills_section.dart, features/architecture/architecture_section.dart, features/architecture/widgets/architecture_diagram.dart, features/architecture/widgets/tech_stack_section.dart, features/services/service_card.dart, shared/widgets/demo_card.dart, shared/widgets/responsive_container.dart, features/ui_showcase/demos/reusable_card_demo.dart, features/widget_gallery/widget_playground.dart. Also delete the root scratch files prompt.text and copilot_prompt_template.md.
2. Rename features/ui_showcase/demos/kanban_board_demo.dart → analytics_dashboard_demo_card.dart (class AnalyticsDashboardDemoCard), because it renders an analytics dashboard, not a kanban board. Update DemoRegistry and the special-case width switch in ui_showcase_page.dart.
3. Replace every withOpacity(x) with withValues(alpha: x) and surfaceVariant with surfaceContainerHighest.
4. Strengthen analysis_options.yaml: add prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_final_locals, require_trailing_commas, prefer_single_quotes, avoid_redundant_argument_values, sort_child_properties_last, use_super_parameters, unawaited_futures, directives_ordering. Then run `dart fix --apply` and fix the rest by hand.
5. Switch every relative import in lib/ to package:portfolio/... imports for consistency.

`flutter analyze` must report zero issues. Commit "refactor: remove dead code, deprecated APIs, stricter lints".
```

## Step 3 — One source of truth for content and navigation

```
Right now my personal info, projects, skills and nav links are hard-coded inside widgets and duplicated (navbar, drawer and footer each list the routes; projects exist in both projects_provider.dart and inside ServicesPage.build). Restructure:

1. Create lib/core/routing/app_routes.dart with route path constants and a typed list of NavDestination(label, path, icon). Make AppNavbar, the drawer and AppFooter all build from that list, and remove the hard-coded links.
2. Create lib/core/content/ (data only, no widgets) with immutable, const-constructible models:
   - profile.dart: Profile(name, title, tagline, shortBio, location, email, availability, socials: List<SocialLink>), with a resumeUrl as optional.
   - skill.dart: Skill(name, category, icon), replacing the switch statements in skill_card.dart.
   - case_study.dart: one CaseStudy model (slug, title, tagline, problem, solution, result, techStack, role, year, links, optional image path, featured flag) that replaces BOTH Project and _ProjectCaseStudy.
   - service_offering.dart: ServiceOffering(title, description, deliverables, icon).
   - Put all actual content in lib/core/content/portfolio_content.dart as const values, with clear `// TODO(me):` markers where I need to supply real data (name, email, GitHub, LinkedIn, real projects).
3. Expose the content through Riverpod providers in the matching feature folders (or core/state) and make the UI read only from those providers.
4. Give DemoApp in demo_app_registry.dart the uiPatterns, layoutStructure, widgetsUsed and useDeviceFrame fields, put the three "My Animations" demos in the registry too, and delete the _getUiPatterns/_getLayoutStructure/_getWidgetsUsed string switches in app_simulator_page.dart.
5. Replace the Map<String,String> patterns in ui_patterns_page.dart with a typed UiPattern model + enum category, and split the private preview widgets into their own files under features/widget_gallery/widgets/.
6. Replace the hard-coded "© 2024" with the current year.

Don't change visuals in this step. Commit "refactor: centralize content, models and navigation".
```

> **You, before Step 4:** open `portfolio_content.dart` and fill in your real name, title, email, links and real projects. Every later step looks better with real content.

## Step 4 — Upgrade dependencies and web URL handling

```
1. Run `flutter pub outdated`. Upgrade go_router and flutter_riverpod to their latest stable major versions and fix every breaking change.
2. Replace the legacy StateProvider usages (developerModeProvider, uiPatternsSearchProvider, uiPatternsCategoryProvider) with Notifier/NotifierProvider classes that expose intent methods (toggle(), setQuery(), setCategory()).
3. Make AppRouter a provider (or at least a top-level final) instead of a static field in a class, so it can be overridden in tests.
4. Use clean URLs on web: call usePathUrlStrategy() from flutter_web_plugins in main.dart. Add a note in README about server rewrites to index.html for hosting.
5. Remove unused dependencies (check equatable and cupertino_icons) and update the pubspec description.

Verify with `flutter analyze`, `flutter test` and running in Chrome, including a hard refresh on a deep link like /architecture. Commit "chore: upgrade go_router & riverpod, path URLs".
```

## Step 5 — Design system: theme, typography, tokens, dark mode

```
Use the frontend-design skill. Goal: the site should look like a premium product studio site, not a default Material demo. Keep it clean and developer-focused.

1. Rewrite lib/core/theme/ into a small design system:
   - app_colors.dart: a deliberate palette with brand primary, accent, neutrals and success/warning, tuned separately for light and dark (not just ColorScheme.fromSeed defaults).
   - app_typography.dart: a distinctive but readable pairing via google_fonts (e.g. a geometric display font for headings + Inter or similar for body), with a full TextTheme scale. Make display sizes responsive (smaller on mobile).
   - app_spacing.dart → move to core/theme and extend: spacing scale (4/8/12/16/24/32/48/64/96), radius scale, max content width, breakpoints (mobile < 600, tablet < 1024, desktop).
   - A ThemeExtension (e.g. AppDecorations) for things ColorScheme doesn't cover: card border color, subtle gradient, glass surface color, code block background, shadow presets.
   - Component themes: Card, ElevatedButton/FilledButton/OutlinedButton, InputDecoration, Chip, NavigationDrawer, SnackBar, Divider, Tooltip.
2. Add a themeModeProvider (light / dark / system) and a theme toggle button in the navbar and drawer. Wire it into MaterialApp.themeMode. Default to dark.
3. Replace every hard-coded Colors.* in the UI (drawer header Colors.blue, Colors.blue[50] in DeveloperInfoPanel, Colors.grey.shade300 borders, CodeViewer greys, avatar Colors.white…) with theme values. Demo widgets that intentionally show their own colors can keep them, but they must still be readable in both modes.
4. Check every page in both light and dark mode and fix contrast issues.

Commit "feat: design system, typography, theme toggle".
```

## Step 6 — App shell, navbar and page transitions

```
1. Move to a GoRouter ShellRoute (or StatefulShellRoute) so the navbar and footer are built once and persist between pages, instead of every page rebuilding AppPage's Stack. AppPage becomes a thin content wrapper (scroll view, max width, padding, optional title).
2. Navbar: sticky, translucent with a BackdropFilter blur once the page is scrolled, a subtle bottom border, a text/monogram logo from Profile, active-link indicator with an animated underline, a "Hire me" FilledButton on the right, the theme toggle and the developer-mode toggle (as an icon button with tooltip). Use the drawer below the tablet breakpoint.
3. Add tasteful page transitions (fade + slight slide) with CustomTransitionPage. No packages.
4. Keep ScrollToTopButton but make it theme-aware, and scroll to top on route change.
5. Set a per-page browser tab title (Title widget or onGenerateTitle per route), e.g. "Work — <My Name>".
6. Wrap content in SelectionArea so visitors can select text on web.

Commit "feat: persistent app shell, navbar polish, page transitions".
```

## Step 7 — Landing page redesign (the one clients judge)

```
Use the frontend-design skill. Redesign the landing page. A potential freelance client should understand within 5 seconds who I am, what I build and how to hire me. All text comes from the content providers.

Sections, top to bottom:
1. Hero: availability pill ("Available for freelance — <month>"), name, strong one-line value proposition, short supporting line, primary CTA "Start a project" → /contact and secondary "See my work" → work page. On the right, replace the person icon with something that shows skill. For example, a live mini Flutter device mockup cycling through 2–3 of my existing demos, or an animated layered-card composition. Add a subtle animated background (slow-moving gradient mesh or grid with CustomPainter). It must stay at 60fps and respect reduced motion (MediaQuery.disableAnimations).
2. Proof strip: 3–4 stats (years of experience, apps shipped, platforms, etc.). Values from content, with a TODO if unknown. Never invent numbers.
3. Services teaser: 3 cards from ServiceOffering, linking to /services.
4. Featured work: 2–3 featured CaseStudy cards with image/preview area, tags and hover elevation + scale, linking to the case study detail page.
5. Skills: grouped by category (chips or a clean grid), not one undifferentiated grid.
6. How I work: a 4-step process (Discover → Design → Build → Ship) with icons.
7. Final CTA band.

Use AnimatedSection for scroll-reveal, but trigger it when the section enters the viewport (use a small visibility check on scroll, no packages) instead of on build. Make every section responsive from 320 px to 1920 px with no overflow. Remove DeveloperInfo from the landing page body and move that content to the Architecture page.

Commit "feat: redesigned landing page".
```

## Step 8 — Work (case studies) and Services pages

```
The current /services page actually shows case studies and is titled "Projects", which is confusing. Restructure:

1. New route /work: a filterable grid of all CaseStudy items (filter chips by tech/type), with responsive cards that size to content (no fixed childAspectRatio that clips text. Use Wrap or a masonry-style column layout).
2. New route /work/:slug: a case study detail page with header (title, role, year, stack), problem → solution → result sections, an image/screenshot gallery area (placeholders if no images yet), links (live demo / GitHub / store, hidden when a URL is missing), and "next project" navigation. Use a Hero animation from card to header. Show a 404 for an unknown slug.
3. Rewrite /services as an actual services page: what I offer (from ServiceOffering), deliverables, my process, an engagement models section (fixed-scope / hourly / retainer, without prices unless content has them), an FAQ (reuse the FAQ accordion component), and a CTA to /contact.
4. Update nav destinations, footer and all internal links. Delete features/projects/ if it's fully replaced by the new work feature.

Commit "feat: work and case study pages, real services page".
```

## Step 9 — Polish the showcase pages and developer mode

```
Pages: /ui-showcase, /widget-gallery (UI Patterns), /app-demos, /architecture.

1. Developer mode is my differentiator, so make it honest. Every DemoComponent codeSnippet must be a real, trimmed excerpt of the widget's actual code (no placeholder comments or empty classes). Check each one.
2. CodeViewer: add lightweight Dart syntax highlighting (a small regex-based TextSpan highlighter in shared/, no packages), line numbers, theme-aware colors, a filename header and an "Copied" state on the copy button.
3. DemoComponent: replace the manual AnimationController height trick with AnimatedSize/AnimatedCrossFade, use theme borders, and make the dev-mode switch feel like a feature (small banner explaining what it reveals the first time it's enabled).
4. App demos: fix DeviceFrame (proper phone proportions that scale down on small screens, notch, no scroll view around a fixed-height child). Make the launch dialog responsive and full-screen on mobile. Add a short "what to try" hint per demo.
5. Show a lazy-loaded preview thumbnail on each app demo card instead of only a title + button.
6. Consider merging /ui-showcase and /widget-gallery into one "Playground" page with tabs if they overlap. Propose this first and ask me before doing it.
7. Architecture page: make the diagrams theme-aware and responsive, and fold in the old DeveloperInfo text.
8. Check every heavy animation demo (origami, magnetic grid, glass tilt) for jank in profile mode (`flutter run -d chrome --profile`). Wrap them in RepaintBoundary, and pause tickers when off-screen or when the dialog closes.

Commit "feat: showcase polish, real code snippets, syntax highlighting".
```

## Step 10 — Contact page that actually converts

```
The contact form currently only shows a fake "Message sent!" SnackBar. Make it real without a backend:

1. Ask me which option I want before implementing: (a) open the visitor's mail client with a prefilled mailto: (url_launcher, no new packages), or (b) POST to a form service like Formspree using the http package. Default to (a) if I don't answer.
2. Redesign the page as two columns on desktop: left side has a short pitch, availability, response time, email with a copy-to-clipboard button, and real social links from Profile. Right side is the form.
3. Form fields: name, email, project type (dropdown/chips), budget range (optional), message. Add proper validation, autofill hints, keyboard submit, a loading state, success and error states, and no double-submits.
4. Fix the three no-op social IconButtons. Use Profile.socials everywhere (footer included), with tooltips and semantic labels.
5. Wrap launchUrl calls in a small helper that handles failure (SnackBar) and opens external links in a new tab on web.

Commit "feat: working contact flow".
```

## Step 11 — Web production polish: SEO, accessibility, performance

```
1. web/index.html: real <title>, meta description, theme-color, Open Graph + Twitter card tags (title, description, image placeholder path), canonical URL TODO, and a lightweight branded loading splash in plain HTML/CSS that is removed when Flutter's first frame renders. Update manifest.json (name, short_name, colors, description). Replace the default Flutter favicon/icons with a simple monogram (generate PNGs) or leave clear TODOs.
2. Accessibility: Semantics labels for icon-only buttons, visible focus states for keyboard navigation, tab order through the navbar, minimum 44 px tap targets, text scaling up to 1.3 without overflow, and reduced-motion support across all animations.
3. Performance: const constructors everywhere possible, avoid rebuilding big trees on hover (scope setState to the small widget), use deferred imports (`import ... deferred as`) for the heavy demo pages so the landing page loads fast, and precache fonts. Build with `flutter build web --release` (and try `--wasm`) and report bundle size before/after.
4. Make sure every route works on direct load/refresh and that images have errorBuilders.

Commit "chore: SEO, accessibility, performance".
```

## Step 12 — Tests

```
The test/ folder is empty. Add a focused test suite (use the flutter-add-widget-test and dart-add-unit-test skills):

1. Unit tests: content providers return valid data (unique slugs, valid URLs or empty), Notifier providers (developer mode toggle, theme mode, search/category filtering logic), the syntax highlighter.
2. Widget tests: every route renders inside the shell without exceptions at mobile (390x844) and desktop (1440x900) sizes; unknown route shows the 404 page; drawer opens on mobile; nav links navigate; theme toggle switches mode; developer mode reveals code snippets; contact form validation messages appear and success state shows on valid submit (mock the launcher).
3. A golden or overflow smoke test that pumps each page at 320, 768 and 1440 widths and fails on RenderFlex overflow.
4. Add a test helper (test/helpers/pump_app.dart) that wraps widgets in ProviderScope + router + theme.

`flutter test` must pass. Commit "test: add unit and widget tests".
```

## Step 13 — README, docs and deployment

```
1. Rewrite README.md as a portfolio-quality README: what this is, live link placeholder, a screenshot/GIF placeholder, feature list (developer mode, demos, architecture), tech stack, folder structure, how to run/test/build, and design decisions. A client or recruiter reading the repo should be impressed by it.
2. Update docs/architecture.md and CLAUDE.md to describe the final structure (shell route, content layer, design system, providers, testing).
3. Add a GitHub Actions workflow (.github/workflows/deploy.yml) that runs analyze + test and deploys `flutter build web --release` to GitHub Pages (with correct --base-href and a 404.html copy of index.html for deep links). Also document the alternative of Firebase Hosting / Netlify / Vercel with SPA rewrites.

Commit "docs: README, architecture docs, CI deploy".
```

## Step 14 — Final review

```
Do a final review of the whole app as if you were a senior Flutter reviewer AND a potential client:

1. Run `flutter analyze`, `flutter test`, and `flutter build web --release`. Everything must be clean.
2. Click through every page at 390 px, 768 px and 1440 px in both themes, with developer mode on and off. List any visual bugs, overflow, inconsistent spacing, or copy that still reads like a placeholder, then fix them.
3. grep for TODO, example.com, "Your Name", lorem, print( and report what's left that I need to fill in myself.
4. Give me a short list of the 3 highest-impact improvements still remaining.
```

---

## Tips for running these
- **One step per session.** Start each with `/clear` so Claude Code re-reads CLAUDE.md fresh.
- **Ask for a plan first on big steps (3, 5, 7, 8).** Prefix with "Plan this first and wait for my OK" and approve before it edits.
- **Watch it live.** Keep `flutter run -d chrome` running and ask Claude Code to hot-reload and check, especially for the visual steps.
- **Real content makes the biggest difference.** Screenshots of your real apps in `assets/images/` (step 8) will impress clients more than any animation.