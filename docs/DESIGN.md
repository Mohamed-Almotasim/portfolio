# DESIGN.md: "The Inspector"

This file is the source of truth for every UI change. If code and this file disagree, this file wins; change it first and then change the code.

Status: **brief, waiting on choices.** The items marked **[CHOOSE]** have options below. Once you pick, Phase 2 deletes the options you didn't choose and turns your picks into tokens in `lib/core/theme/`.

---

## 0. Product context

- **What it is:** the portfolio of a freelance Flutter developer. The site is itself a live Flutter web app, so the medium is part of the proof.
- **Who visits:**
  - founders and product leads looking for someone to build or rescue a Flutter app
  - hiring managers who skim for 30 seconds
  - developers who open developer mode to check the code
- **What the visitor should do:** see shipped work, believe the craft, then get in touch (`/contact`).
- **Mode:** Experience on `/` (the site is the artifact). Read and Operate on `/work` (a register you scan and filter).
- **Hard constraints:**
  - Flutter web only, with no HTML or CSS layer.
  - Fonts are bundled in `assets/`, and runtime fetching stays off.
  - Copy comes only from `portfolio_content.dart` through providers.
  - Never invent facts. Missing content shows a visible `TODO(me)` placeholder or is hidden.
- *Assumption, inferred from the brief, not from an interview:* the tone is calm and exact rather than playful, and there are no client logos, testimonials or real screenshots yet.

## 1. Direction

Flutter DevTools crossed with an architect's spec sheet: precise, calm, technical, confident. The page reads like a drawing set. It has a title block, numbered sheets, dimension lines and a register of drawings. Every part of it is a real widget you can inspect.

**The idea.** On this site, *the Flutter widget tree the site is built from* becomes *the drawing itself*. Inspector mode lays the real layout over the real page, so nobody else's portfolio can use this sentence.

- **Light ("paper") is primary:**
  - a warm off-white ground with near-black ink
  - hairline rules that mark real structure
  - lots of space
- **Dark ("night blueprint"):** the same system with the values inverted onto deep blue-slate. Same rules, same layout, same accent role. It is not a different style.
- **One accent,** used sparingly:
  - the primary action
  - active nav and focus
  - key links
  - inspector highlights
  - It never fills large areas, and it is never a gradient.

## 2. Color

### Neutrals (fixed for every accent option)

Ratios are WCAG contrast against the ground of the same theme, measured.

| Role | Paper (light) | Night (dark) | Use |
|---|---|---|---|
| `ground` | `#F4F1EA` | `#0E1A22` | page background |
| `ground-2` | `#ECE8DE` | `#14232D` | a tone step for panels, table hover, image wells; never a shadow |
| `ink` | `#16150F` (16.2:1) | `#E6E2D6` (13.6:1) | all running text and headlines |
| `ink-mute` | `#5C5A52` (6.1:1, and 5.7:1 on ground-2) | `#93A0A6` (6.6:1, and 6.0:1 on ground-2) | secondary metadata only, never running text |
| `rule` | `ink` at 14% | `ink` at 16% | hairlines and grid |
| `rule-strong` | `ink` at 100% | `ink` at 100% | the title block and the table header rule |
| `error` | `#B42318` | `#FF8A7A` | form errors, always shown with an icon and text |

### Accent **[CHOOSE one]**

Each accent has three jobs, and each job needs its own value to pass contrast:
- **fill:** buttons and highlights. Ink text sits on it.
- **line:** outlines, focus rings and inspector boxes. Needs 3:1 against the ground.
- **text:** links and active labels. Needs 4.5:1 against the ground.

| | A. Signal orange (recommended) | B. Acid chartreuse | C. Signal red |
|---|---|---|---|
| Light fill | `#EB4700` (ink on it: 4.7:1) | `#CFFF3E` (ink on it: 15.7:1) | `#E8202A` (white on it: 4.5:1) |
| Light line (needs 3:1) | `#EB4700`, 3.4:1 ✓ | can't: 1.0:1 on paper; uses `#3F5600` instead | `#E8202A`, 4.0:1 ✓ |
| Light text (needs 4.5:1) | `#B83A00`, 5.1:1 ✓ | `#3F5600`, 7.3:1 ✓ | `#C8102E`, 5.2:1 ✓ |
| Dark fill / line / text | `#FF6A2B` (6.2:1 on night; night text on it ✓) | `#CFFF3E` (15.2:1) | `#FF5147` (5.5:1) |
| Character | a surveyor's marker, a safety tag, a measuring tape | a highlighter on a blueprint, very "tool" | a red pencil correction mark, an alarm |
| Risk | the most common of the three, but it never collides with meaning | on paper it only works as a fill under ink, so the inspector lines turn olive, and the light and dark themes feel like two accents | it collides with error and destructive meaning, so errors have to move to ink plus an icon |

**Recommendation: A.** It is the only option where one hue does all three jobs in both themes with a shade change only. It reads as "measurement" and leaves red free for errors.

## 3. Typography **[CHOOSE one]**

Three roles:
- **display:** headlines only, one weight
- **text:** body and UI
- **mono:** metadata, section numbers, captions, nav, inspector tags and code

All the faces below are SIL OFL, so they can be bundled. Inter and Space Grotesk are removed.

| | 1. Drafting set (recommended) | 2. Engineered grotesque | 3. Spec + serif |
|---|---|---|---|
| Display | **Archivo Expanded**, SemiBold. Wide and flat-topped, like the lettering in a drawing's title block. | **Schibsted Grotesk**, Bold. A tight newspaper grotesque with real character in the R, G and a. | **Instrument Serif**, Regular. Condensed and high-contrast, an editorial voice set against the technical mono. |
| Text | **IBM Plex Sans**, 400/600 | **Public Sans**, 400/600 | **IBM Plex Sans**, 400/600 |
| Mono | **IBM Plex Mono**, 400/500 (shares Plex metrics, so labels and body align) | **JetBrains Mono**, 400 (already bundled) | **JetBrains Mono**, 400 |
| Feel | the blueprint title block | DevTools crossed with a newspaper | a monograph about engineering |
| Risk | Archivo's width axis isn't exposed by `google_fonts`, so the Expanded cut is bundled as its own TTF and loaded with `FontLoader` | the most conventional of the three | Instrument Serif is the 2024–25 "tasteful AI landing page" default, and the serif against mono can read as costume |

**Recommendation: 1.** Plex Sans and Plex Mono read as one family, so the page effectively has two voices (display and Plex), which keeps Taste's two-typeface limit in spirit. The Expanded display cut is the least overused option.

**Mono alternatives** if you want to swap only the mono:
- **Martian Mono:** wide and very technical, but heavy at small sizes.
- **JetBrains Mono:** keep what's bundled. It's warmer than Plex Mono and has less of a drafting feel.

### Type scale (one scale, both pickers)

Body sits on a 16px base. Only five sizes do visible work.

| Token | Phone | Desktop (≥1024) | Face / weight | Leading | Tracking |
|---|---|---|---|---|---|
| `display` | 44 | 88 | display | 0.95 | -0.03em |
| `heading` | 28 | 40 | display | 1.05 | -0.02em |
| `lead` | 19 | 22 | text 400 | 1.45 | 0 |
| `body` | 16 | 17 | text 400 (600 for emphasis) | 1.55 | 0 |
| `label` | 12 | 13 | mono 400 (500 when active) | 1.35 | +0.02em, sentence case or real identifiers, never tracked all-caps |

- **Measure:** 45–72 characters.
- **Alignment:** left-aligned everywhere, except one centred moment per page at most.
- **Headlines:** two lines or fewer at every width from 320 to 1920, and at text scale 1.3 they may grow to three.
- **Figures:** tabular figures in the register and the metadata.

## 4. Space, grid and shape

- **Base unit:** 4. The scale is `4 8 12 16 24 32 48 64 96 128 160`. Any other value has to be justified in code review.
- **Grid:**

  | | Phone | Tablet | Desktop |
  |---|---|---|---|
  | Columns | 4 | 8 | 12 |
  | Gutter | 16 | 24 | 24 |
  | Outer margin | 16 | 32 | 48 |

  Content max width is 1280 and the frame centres it. Margins are equal on both sides at every width.
- **Section rhythm:** 128–160 between sections on desktop and 80 on phone. Gaps inside a section stay at 48 or less, so sections read as separate blocks.
- **Asymmetry** lives inside the grid, for example a 5/7 split or an offset start column. It never lives in the frame.
- **Radius:**
  - `0` by default: images, frames, panels, the register
  - `2` for buttons, inputs and chips
  - `4` at most, for the inspector tag
  - No pills except the focus ring around a pill-shaped control, and there shouldn't be any of those.
- **Elevation:** none at rest. A shadow appears only on things that really float: menus, dialogs, the mobile drawer and the inspector tag.

## 5. Lines and spec-sheet marks

Lines mark structure. They are not ornament. Every line separates two real regions, or measures something that is really there.

| Mark | Spec | Where |
|---|---|---|
| Hairline rule | 1px `rule` | register rows, the title-block cells, the top of each numbered section |
| Strong rule | 1px `rule-strong` | the top and bottom of the title block (navbar and case-study header), the register header |
| Dimension line | 1px `ink-mute`, dashed 4/3, with 6px end ticks and a centred mono label (e.g. `1280`) | at most one per section, measuring a real box |
| Ruler ticks | minor 4px every 8, major 8px every 64, 1px `rule`, labels in mono `label` at majors | along the hero's top edge, and in inspector mode along the viewport edge |
| Crop marks | 12px L-shaped corners in 1px `ink`, offset 6px outside the frame | image and preview frames, and the live-demo frame only |
| Section number | mono `label` in `ink-mute`, on the heading's baseline, e.g. `01 Selected work` | numbered sections only (see the Taste notes) |
| Annotation | mono `label` in `ink-mute`, e.g. `padding: 24` or `Column → 3 children` | 0–1 per section in normal mode. Inspector mode adds the rest. |

## 6. Motion

Minimal and precise, like a measuring tool snapping into place.

| Token | Duration | Curve | Use |
|---|---|---|---|
| `instant` | 0 | n/a | reduced motion: every token collapses to this |
| `snap` | 120ms | `Cubic(0.2, 0, 0, 1)` | hover, press, focus, chip toggle |
| `measure` | 200ms | `Curves.linear` | drawing a dimension line, the inspector outline and tag appearing |
| `settle` | 240ms | `Cubic(0.2, 0, 0, 1)` | a section's parts entering, once: a 0→1 opacity fade plus at most an 8px rise, staggered 60ms |
| `route` | 200ms | `Cubic(0.2, 0, 0, 1)` | page change (cross-fade only), plus the existing Hero image transition from the index to the case study |

- **Banned:** floating idle loops, glows, parallax, spring overshoot, scale-on-hover, card lift.
- **Reduced motion:** `MediaQuery.disableAnimationsOf(context)` sets every duration to zero, and content is never hidden waiting for an animation.
- Built-in Flutter animation widgets only (`AnimatedContainer`, `AnimatedOpacity`, `TweenAnimationBuilder`, `Hero`).

## 7. Inspector mode (developer mode, restyled)

When developer mode is on, the real site shows its own layout:
- **Outlines:** a 1px accent `line` around each `Inspectable` box. When it's active, the outline becomes 2px and the box gets a 4% accent fill.
- **Padding:** shown as 45° hatching (1px accent at 35%, 6px pitch) in the area between the box and its child.
- **Tag:** a small mono tag at the box's top-left, outside the box when there's room, reading `<label> <w>×<h>` with the size rounded to whole logical pixels, e.g. `Card 352×240`. It uses ink on the accent fill (A and B) or white on the accent fill (C), with radius 4. The tag is the one thing that has a shadow.
- **Interaction:**
  - Desktop: hovering highlights the box and shows its tag. The innermost hovered box wins.
  - Touch: a tap toggles the highlight and doesn't trigger the child. A second tap passes through.
  - Keyboard: focus inside a box highlights it.
- **Engine:** `shared/layout/inspectable.dart`, with `Inspectable(label: 'HeroSection', padding: …, child: …)`. It is one custom `RenderProxyBox` that is always in the tree, so turning developer mode on or off never remounts the child or loses its state.
  - When off, `paint` only paints the child: no extra layer, no extra composited layer, and no mouse annotation (`validForMouseTracker` is false).
  - It does not rebuild on toggle. It reads the provider with `ref.listen` and flips a field on the render object, which calls `markNeedsPaint`.
  - It works in release builds and never uses `debugPaintSizeEnabled`.
- **What gets wrapped:** sections, cards, frames and the hero's live element, about 6–12 per page. Never text runs or icons.
- The existing per-demo "Show code" source viewer stays as it is and is restyled with the mono face.

## 8. Components (rules shared across pages)

- **Navbar:**
  - The wordmark in display or mono, then the existing destinations in mono `label`, then one action.
  - The active link is accent text with a 2px accent underline.
  - The bar is a plain ground strip with a strong bottom rule. No blur and no glass.
- **Buttons:**
  - Primary is the accent fill with ink text (or white for C), radius 2, height ≥ 44.
  - Secondary is ink text with a 1px ink border.
  - No gradients, no icons for decoration, no lift on hover. Hover only steps the fill tone.
- **Focus:** a 2px accent `line` ring with a 2px offset on every interactive element, in both themes.
- **Tap targets:** ≥ 44×44 with an 8px gap between them.
- **Images and previews:** square corners, crop marks, and a mono caption below (`Fig. 2 · Booking flow`). A missing image shows a `ground-2` well with crop marks and the caption `TODO(me): screenshot`, never an icon in a box.

## 9. Banned (generic AI UI)

- purple, indigo or blue gradients, and any gradient at all
- glow blobs and radial background lighting
- glassmorphism and backdrop blur
- green "available" dot pills
- floating code-card collages
- icon-in-rounded-square card grids
- three identical feature cards in a row
- hover lift on cards
- emoji
- self-referential stats ("6 demos on this site")
- filler copy ("passionate developer with a keen eye")
- shadows on things at rest
- a styled accent word inside a headline
- tracked tiny all-caps eyebrows above headings

## 10. Taste guardrail: conflicts with this brief, resolved

The Taste skill's house rules ban mono outside code, index numbering, hairline rules, grid lines and crop marks, which are this brief's signature. Impeccable's rule is that *the brief wins*, so they stay, with discipline that keeps them functional rather than costume:
1. **Mono** is used for things that really are metadata or identifiers: the year, the stack, sizes, widget names, nav and captions. It is never used for running text or headlines.
2. **Numbers** go only where the order is real: the numbered sections of the home page and the case study, the drawing register and the 4 process steps.
3. **Lines** must separate two real regions or measure a real box (§5). There are no decorative boxes and no full-page background grid. Ruler ticks appear only along the hero's top edge, and along the viewport edge in inspector mode.
4. **Crop marks** go only on media frames.
5. **Annotations:** at most one per section in normal mode.

Taste rules that apply unchanged:
- no eyebrows
- running text in full ink
- headlines of two lines or fewer
- one primary action per screen
- flat colour
- a section never shares its neighbour's layout
- the footer is a designed close

## 11. Content gaps (owner to fill, never invented)

These show as `TODO(me)` until real values exist, or are hidden:
- the real name and monogram
- the email
- case-study images and outcomes
- proof stats (hidden until real)
- repository and demo links (shown only when real)
