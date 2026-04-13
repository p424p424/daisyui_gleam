# Contributing to daisyui_gleam

Thank you for your interest in contributing. This document explains the
conventions that every component module and its example project must follow so
the library stays consistent and easy to extend.

---

## Table of contents

1. [Repository layout](#repository-layout)
2. [Component module conventions](#component-module-conventions)
   - [File location and naming](#file-location-and-naming)
   - [Module-level doc comment](#module-level-doc-comment)
   - [Imports](#imports)
   - [Section dividers](#section-dividers)
   - [The opaque builder type](#the-opaque-builder-type)
   - [Constructor — `new/0`](#constructor--new0)
   - [Setter functions](#setter-functions)
   - [The `build` function](#the-build-function)
   - [Reusing shared tokens](#reusing-shared-tokens)
   - [Component-local types](#component-local-types)
   - [When not to use a builder](#when-not-to-use-a-builder)
3. [Example projects](#example-projects)
   - [Project scaffold](#project-scaffold)
   - [App structure](#app-structure)
   - [Consistent layout](#consistent-layout)
   - [CSS setup](#css-setup)
4. [Checklist for a new component](#checklist-for-a-new-component)

---

## Repository layout

```
src/daisyui/          ← component modules (one file per DaisyUI component)
  tokens.gleam        ← shared Color, Size, TextSize, Weight, Variant types
  badge.gleam
  button.gleam
  …

examples/
  example_01/         ← reference app (accordion + text demo)
  example_badge/      ← one project per component
  example_button/
  …

test/                 ← unit tests (run with gleam test)
```

---

## Component module conventions

### File location and naming

- Path: `src/daisyui/<component>.gleam`
- The module name matches the DaisyUI component name in lower snake_case
  (e.g. `breadcrumbs.gleam`, not `bread_crumbs.gleam`).

---

### Module-level doc comment

Every file opens with a `///` module doc comment **before** the first import.
It must include:

1. **One-sentence description** of what the component is and what HTML element
   it renders.
2. **"New to Lustre?" callout** — a brief explanation that Lustre models UI as
   `Element(msg)` values and a link to the Lustre docs.
3. **Quick start** section — two or three `gleam` code-fenced examples showing
   the most common usage patterns.
4. **Reference** section — links to the Lustre docs and the DaisyUI component
   page.

Example (from `badge.gleam`):

```
/// A builder for DaisyUI badge elements.
///
/// Badges inform the user of the status of specific data — counts,
/// labels, states, and tags. The component renders as a single
/// `<span class="badge">` with optional colour, style variant, and size
/// modifiers.
///
/// > **New to Lustre?** …
///
/// ## Quick start
///
/// ```gleam
/// badge.new()
/// |> badge.primary
/// |> badge.sm
/// |> badge.text("New")
/// |> badge.build
/// ```
///
/// ## Reference
/// - [Lustre docs](https://hexdocs.pm/lustre/)
/// - [DaisyUI badge](https://daisyui.com/components/badge/)
```

---

### Imports

Imports come immediately after the module doc comment, with no blank line
between the doc comment and the first `import`.

Standard import order:

```gleam
import daisyui/tokens.{ … }   // shared tokens — first
import gleam/list
import gleam/option.{ … }
import gleam/string
import lustre/attribute.{ … }
import lustre/element.{ … }
import lustre/element/html
// any other lustre/* imports (event, etc.)
```

Only import what the file actually uses.

---

### Section dividers

Logical sections are separated by a long comment divider followed by a blank
line:

```gleam
// ---------------------------------------------------------------------------
// Types
// ---------------------------------------------------------------------------
```

Standard sections (in order):

| Section | Contents |
|---------|----------|
| `Types` | The opaque builder type and any component-local types |
| `Constructor` | `new/0` |
| First modifier group | e.g. `Color`, `Style`, `Size` — one section per logical group |
| `Attrs / Children` | `attrs`, `children`, and `text` helpers |
| `Build` | `build/1` |

---

### The opaque builder type

Every component exposes a single **opaque** type parameterised on `msg`:

```gleam
pub opaque type Badge(msg) {
  Badge(
    color:    Option(Color),
    variant:  Option(Variant),
    size:     Option(Size),
    attrs:    List(Attribute(msg)),
    children: List(Element(msg)),
  )
}
```

Rules:
- The type is **always opaque** — no pattern matching by callers.
- Optional modifiers use `Option(T)` so that "not set" and "default" are
  distinct; this avoids emitting a spurious class.
- `attrs: List(Attribute(msg))` and `children: List(Element(msg))` are present
  in every builder, even if the component has a `text` shorthand.
- The doc comment on the type explains the opaque guarantee and the `msg` type
  parameter.

---

### Constructor — `new/0`

```gleam
pub fn new() -> Badge(msg) {
  Badge(color: None, variant: None, size: None, attrs: [], children: [])
}
```

- No arguments.
- All fields initialised to their zero/empty values.
- Doc comment shows a minimal chain ending in `build`.

---

### Setter functions

Each setter is a one-liner that returns a new builder using the record-update
syntax `Builder(..b, field: value)`:

```gleam
/// Sets the badge colour to `badge-primary`.
///
/// ## Reference
/// - [DaisyUI colour tokens](https://daisyui.com/docs/colors/)
pub fn primary(b: Badge(msg)) -> Badge(msg) {
  Badge(..b, color: Some(tokens.Primary))
}
```

Guidelines:
- Every public function has a `///` doc comment. For setters a single sentence
  plus a `## Reference` link is enough.
- Use token values from `tokens.gleam` wherever possible
  (`tokens.Primary`, `tokens.SM`, etc.) rather than raw strings.
- Boolean flags (e.g. `disabled`, `wide`) are stored as `Bool` fields and set
  to `True` by the setter; no `Option` is needed for flags.
- When a flag has a CSS class *and* an HTML attribute side-effect (e.g.
  `disabled` also sets `attribute.disabled(True)`), document both in the
  setter's doc comment and handle both in `build/1`.

**Setter grouping** — group setters by concept with a section divider between
each group. Typical groups (not all are required for every component):

- Color modifiers (`neutral`, `primary`, `secondary`, `accent`, `info`,
  `success`, `warning`, `error`)
- Style / variant modifiers (`outline`, `soft`, `dash`, `ghost`, …)
- Size modifiers (`xs`, `sm`, `md`, `lg`, `xl`)
- Layout / behaviour modifiers (component-specific booleans)
- Slot setters (`figure`, `title`, `body`, `actions`, …)
- `attrs` / `children` / `text`

---

### The `build` function

`build/1` is always the last function in the file. It takes the builder and
returns `Element(msg)`.

The standard class-assembly idiom:

```gleam
pub fn build(b: Badge(msg)) -> Element(msg) {
  let classes =
    [
      Some("badge"),
      option.map(b.color,   color_class("badge", _)),
      option.map(b.variant, variant_class("badge", _)),
      option.map(b.size,    size_class("badge", _)),
    ]
    |> list.filter_map(fn(x) { option.to_result(x, Nil) })
    |> string.join(" ")

  html.span([attribute.class(classes), ..b.attrs], b.children)
}
```

Rules:
- Always start the class list with `Some("base-class")` so the base class is
  always present.
- Use `option.map` + the relevant `tokens.*_class` helper for each optional
  modifier.
- Collect with `list.filter_map(fn(x) { option.to_result(x, Nil) })` and join
  with `string.join(" ")`.
- Place the `attribute.class(classes)` first in the attribute list, then spread
  `..b.attrs` so user-provided attributes can override later.
- If a flag adds both a CSS class and an HTML attribute (e.g. `disabled`),
  conditionally prepend the HTML attribute before the class attribute:

```gleam
let all_attrs = case b.disabled {
  True  -> [attribute.disabled(True), attribute.class(classes), ..b.attrs]
  False -> [attribute.class(classes), ..b.attrs]
}
```

---

### Reusing shared tokens

`src/daisyui/tokens.gleam` defines:

| Type | Helper | Use for |
|------|--------|---------|
| `Color` | `color_class(prefix, _)` | Colour modifiers on any component |
| `Size` | `size_class(prefix, _)` | The `xs`–`xl` interactive-element scale |
| `TextSize` | `text_size_class(_)` | Tailwind `text-*` typography sizes |
| `Weight` | `weight_class(_)` | Tailwind `font-*` weights |
| `Variant` | `variant_class(prefix, _)` | `soft`, `outline`, `dash`, `ghost` |

Import only the types and helpers you actually use:

```gleam
import daisyui/tokens.{
  type Color, type Size, type Variant,
  color_class, size_class, variant_class,
}
```

---

### Component-local types

Sometimes a component needs a type that doesn't fit the shared tokens — for
example `button.gleam` adds a `Link` variant that doesn't exist in
`tokens.Variant`, and `card.gleam` uses `Border | Dash` instead of `outline`.
In these cases define a local type:

```gleam
pub type BtnStyle {
  Outline
  Dash
  Soft
  Ghost
  Link
}
```

Name the type after the component + the concept (e.g. `BtnStyle`, `CardStyle`,
`AlertDirection`). Document it with a table mapping each constructor to its
DaisyUI class.

---

### When not to use a builder

If a component has no configurable state (e.g. `calendar.gleam`, which just
wraps third-party web components), expose plain functions and constants rather
than a builder. Document why in the module doc comment.

---

## Example projects

### Project scaffold

Each component has a corresponding example project at
`examples/example_<component>/`. The scaffold is:

```
examples/example_<component>/
  gleam.toml          ← target = "javascript", lustre + lustre_dev_tools + daisyui_gleam path dep
  manifest.toml       ← auto-generated by gleam
  package.json        ← devDependency: daisyui ^5
  src/
    example_<component>.gleam   ← the Lustre app
    example_<component>.css     ← Tailwind + DaisyUI entry point
  test/
    example_<component>_test.gleam
```

**`gleam.toml`** must contain:

```toml
name = "example_<component>"
version = "1.0.0"
target = "javascript"

[dependencies]
gleam_stdlib = ">= 0.44.0 and < 2.0.0"
lustre = ">= 5.6.0 and < 6.0.0"
daisyui_gleam = { path = "../../" }

[dev_dependencies]
gleeunit = ">= 1.0.0 and < 2.0.0"
lustre_dev_tools = ">= 2.3.6 and < 3.0.0"
```

**Setting up Tailwind** — after scaffolding, run once from inside the project:

```sh
gleam run -m lustre/dev add tailwind
```

This downloads the Tailwind CLI binary into `.lustre/` and creates
`src/example_<component>.css` with a single `@import "tailwindcss";` line.
You must then add the DaisyUI import on the next line (see [CSS setup](#css-setup)).

**`package.json`** — initialise with `npm init -y` and install DaisyUI:

```sh
npm install --save-dev "daisyui@^5.0.0"
```

---

### App structure

Every example app follows the same Lustre architecture:

```gleam
pub type Model {
  Model(theme: String)
}

pub type Msg {
  UserChangedTheme(String)
}

pub fn main() {
  let app = lustre.simple(fn(_) { Model(theme: "light") }, update, view)
  let assert Ok(_) = lustre.start(app, "#app", Nil)
  Nil
}

fn update(model: Model, msg: Msg) -> Model {
  case msg {
    UserChangedTheme(t) -> Model(..model, theme: t)
  }
}
```

- Use `lustre.simple` (not `lustre.element`) so the theme state can be updated.
- The `init` function ignores its flags argument and returns `Model(theme: "light")`.
- Add component-specific `Msg` variants below `UserChangedTheme` as needed.

---

### Consistent layout

Every example renders the same two-part layout:

```
┌─────────────────────────────────────────────────────┐
│  Component Name                    [theme select]   │  ← fixed header
├─────────────────────────────────────────────────────┤
│                                                     │
│              component demonstration                │  ← centred content
│                                                     │
└─────────────────────────────────────────────────────┘
```

**Root div** — carries the `data-theme` attribute that drives DaisyUI theming:

```gleam
fn view(model: Model) -> Element(Msg) {
  html.div(
    [
      attribute.attribute("data-theme", model.theme),
      attribute.class("min-h-screen bg-base-200"),
    ],
    [page_header(model.theme), main_content()],
  )
}
```

**`page_header`** — fixed, full-width, flex row:

```gleam
fn page_header(current_theme: String) -> Element(Msg) {
  html.header(
    [
      attribute.class(
        "fixed top-0 left-0 right-0 z-50 flex items-center justify-between px-6 h-16 bg-base-100 shadow",
      ),
    ],
    [
      html.h1([attribute.class("text-lg font-semibold")], [
        html.text("ComponentName"),
      ]),
      theme_select(current_theme),
    ],
  )
}
```

**`theme_select`** — uses `daisyui/select` with `event.on_input`:

```gleam
fn theme_select(current: String) -> Element(Msg) {
  select.new()
  |> select.sm
  |> select.attrs([attribute.value(current), event.on_input(UserChangedTheme)])
  |> select.children([
    html.option([attribute.value("light")],     "Light"),
    html.option([attribute.value("dark")],      "Dark"),
    html.option([attribute.value("cupcake")],   "Cupcake"),
    html.option([attribute.value("corporate")], "Corporate"),
    html.option([attribute.value("synthwave")], "Synthwave"),
    html.option([attribute.value("retro")],     "Retro"),
    html.option([attribute.value("cyberpunk")], "Cyberpunk"),
    html.option([attribute.value("valentine")], "Valentine"),
    html.option([attribute.value("aqua")],      "Aqua"),
    html.option([attribute.value("dracula")],   "Dracula"),
  ])
  |> select.build
}
```

Note: `html.option` in Lustre takes `(List(Attribute(msg)), String)` — the
second argument is the label string, **not** a list of child elements.

**`main_content`** — centred below the fixed header:

```gleam
fn main_content() -> Element(Msg) {
  html.main(
    [attribute.class("pt-16 flex items-center justify-center min-h-screen")],
    [ … component demonstration … ],
  )
}
```

The `pt-16` offsets the content below the 4 rem header.

---

### CSS setup

The CSS entry point for each example must contain exactly:

```css
@import "tailwindcss";
@import "../node_modules/daisyui/daisyui.css";
```

**Why the explicit import path?** The standalone Tailwind CLI binary used by
`lustre_dev_tools` does not reliably scan Gleam's compiled JavaScript output
for DaisyUI class names. Using `@plugin "daisyui"` causes Tailwind to only
emit CSS for classes it finds during content scanning, which often excludes
component rules (e.g. the rule that hides the checkbox inside `.collapse`).
The explicit `@import` path unconditionally includes all DaisyUI CSS and avoids
this problem.

---

## Checklist for a new component

- [ ] `src/daisyui/<component>.gleam` created
  - [ ] Module-level `///` doc comment with description, Lustre callout, quick
        start examples, and reference links
  - [ ] Imports ordered: `daisyui/tokens`, `gleam/*`, `lustre/*`
  - [ ] Section dividers in the standard order
  - [ ] Opaque builder type with `Option` for optional modifiers, plain `Bool`
        for flags
  - [ ] `new/0` initialises all fields to zero/empty values
  - [ ] Setters use record-update syntax and token helpers where possible
  - [ ] Every public function has a `///` doc comment
  - [ ] `build/1` uses the `[Some("base"), option.map(…), …] |> filter_map |> join` idiom
- [ ] `examples/example_<component>/` scaffolded
  - [ ] `gleam.toml` has `target = "javascript"` and `daisyui_gleam = { path = "../../" }`
  - [ ] `gleam run -m lustre/dev add tailwind` has been run
  - [ ] `src/example_<component>.css` contains the two-line Tailwind + DaisyUI import
  - [ ] `npm install --save-dev "daisyui@^5.0.0"` has been run
  - [ ] App uses `lustre.simple` with `Model { theme }` and `UserChangedTheme`
  - [ ] `view` applies `data-theme` to the root div
  - [ ] `page_header` is fixed, shows the component name, and renders `theme_select`
  - [ ] `main_content` is centred with `pt-16`
- [ ] `gleam build` passes in the example project
- [ ] `README.md` component table updated with the new module
- [ ] `CHANGELOG.md` updated under `[Unreleased]`
