# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added

- **First-class event handler functions** on all interactive components —
  no need to reach for `attrs([event.on_X(...)])` for common cases.
  Each function appends to the builder's attribute list so it composes
  freely with `attrs/2` and other event functions.

  | Component | New functions |
  |-----------|--------------|
  | `button` | `on_click`, `on_mouse_down`, `on_mouse_up`, `on_mouse_enter`, `on_mouse_leave`, `on_focus`, `on_blur`, `on_keydown`, `on_keyup` |
  | `input` | `on_input`, `on_change`, `on_focus`, `on_blur`, `on_keydown`, `on_keyup` |
  | `textarea` | `on_input`, `on_change`, `on_focus`, `on_blur`, `on_keydown`, `on_keyup` |
  | `toggle` | `on_check`, `on_focus`, `on_blur` |
  | `radio` | `on_check`, `on_focus`, `on_blur` |
  | `select` | `on_change`, `on_focus`, `on_blur` |
  | `range` | `on_input`, `on_change`, `on_focus`, `on_blur` |
  | `file_input` | `on_change`, `on_focus`, `on_blur` |
  | `link` | `on_click`, `on_mouse_enter`, `on_mouse_leave`, `on_focus`, `on_blur` |
  | `card` | `on_click`, `on_mouse_enter`, `on_mouse_leave` |

### Changed

- **`attrs/2` now appends** on all components that previously replaced
  (`input`, `textarea`, `toggle`, `radio`, `select`, `range`, `file_input`,
  `link`). Calling `attrs` more than once now accumulates attributes rather
  than wiping the previous call. `button` and `card` were already appending.

## [0.1.0] - 2026-04-13

### Added

#### Core

- **`tokens`** — Shared design-token types (`Color`, `Size`, `TextSize`, `Weight`,
  `Variant`) and their class-building helper functions (`color_class`, `size_class`,
  `text_size_class`, `weight_class`, `variant_class`). All component modules
  import from here to stay consistent.

#### Components

- **`accordion`** — Collapse/accordion builder. Supports checkbox (default), radio
  (accordion group), and native `<details>` variants. Optional arrow/plus icons and
  forced open/close state.

- **`alert`** — Alert banner builder. Supports `info`, `success`, `warning`, and
  `error` colours; `soft`, `outline`, and `dash` style variants; and `horizontal` /
  `vertical` layout directions.

- **`avatar`** — Avatar builder with online/offline status indicators, placeholder
  mode for initials, Tailwind width sizes (`w8`–`w32`), and shape modifiers
  (`rounded`, `circle`, etc.). Includes a `group/2` helper for avatar stacks.

- **`badge`** — Badge builder. Full colour, variant, and size support via shared
  tokens. Renders as `<span>`.

- **`breadcrumbs`** — Breadcrumb trail builder. `link/2` and `item/1` helpers
  produce `<li>` elements; the outer wrapper is a `<div class="breadcrumbs">`.

- **`button`** — Button builder. Full colour, size, and layout modifier support.
  Local `BtnStyle` type covers `outline`, `dash`, `soft`, `ghost`, and `link`
  variants. `disabled/1` sets both the CSS class and HTML `disabled` attribute.

- **`calendar`** — External library integration module (no builder). Provides
  element helpers and class constants for:
  - **Cally** web component (`cally/2`, `cally_month/0`, `prev_arrow/0`,
    `next_arrow/0`) — works in Lustre.
  - **Pikaday** input (`pikaday_input/1`) — works in Lustre via JS effects.
  - **React Day Picker** — class constant only; React-only, not usable in Lustre.

- **`card`** — Card builder with figure, title, body, and actions slots.
  `CardStyle` covers `border` and `dash`. Standalone `title_part/2`,
  `body_part/2`, and `actions_part/2` helpers for custom layouts.

- **`carousel`** — Carousel builder. `SnapPosition` (`start`, `center`, `end`)
  and `CarouselDirection` (`horizontal`, `vertical`) modifiers. `item/1` helper
  for individual slides.

- **`text`** — Styled text builder for `<span>`, `<p>`, and `<h1>`–`<h6>`.
  Full Tailwind font-size, font-weight, and DaisyUI semantic colour support.

#### Examples

- **`examples/example_01`** — Reference Lustre app demonstrating `accordion` and
  `text` components with DaisyUI v5 and Tailwind v4.
- Scaffolded (no application code yet) example projects for each component:
  `example_accordion`, `example_alert`, `example_avatar`, `example_badge`,
  `example_breadcrumbs`, `example_button`, `example_calendar`, `example_card`,
  `example_carousel`, `example_text`.

[Unreleased]: https://github.com/p424p424/daisyui_gleam/compare/v0.1.0...HEAD
[0.1.0]: https://github.com/p424p424/daisyui_gleam/releases/tag/v0.1.0
