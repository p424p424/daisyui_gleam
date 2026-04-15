# daisyui_gleam ✨

> **Work in progress** — the API is taking shape but is not yet stable.
> Expect additions and occasional breaking changes before v1.0.0.

[![Hex Package](https://img.shields.io/hexpm/v/daisyui_gleam)](https://hex.pm/packages/daisyui_gleam)
[![Hex Docs](https://img.shields.io/badge/hex-docs-ffaff3)](https://hexdocs.pm/daisyui_gleam/)
[![License: MIT](https://img.shields.io/badge/license-MIT-blue)](LICENSE)

Type-safe [DaisyUI](https://daisyui.com) component builders for the
[Lustre](https://hexdocs.pm/lustre/) web framework. Write Gleam, get beautiful
UI — no class strings scattered through your view code.

```gleam
button.new()
|> button.primary
|> button.lg
|> button.text("Get started")
|> button.build
```

---

## 📋 Table of Contents

- [What is this?](#-what-is-this)
- [Installation](#-installation)
- [Quick Start](#-quick-start)
- [How the builder pattern works](#-how-the-builder-pattern-works)
- [The colour system](#-the-colour-system)
- [Theming](#-theming)
  - [Built-in themes](#built-in-themes)
  - [Enabling themes](#enabling-themes)
  - [Applying a theme](#applying-a-theme)
  - [Scoped themes](#scoped-themes)
  - [Custom themes](#custom-themes)
  - [Customising a built-in theme](#customising-a-built-in-theme)
  - [Tailwind dark: selector](#tailwind-dark-selector)
  - [Theme switching in Lustre apps](#theme-switching-in-lustre-apps)
- [Components](#-components)
  - [🎬 Actions](#-actions)
  - [🗃️ Data Display](#️-data-display)
  - [🧭 Navigation](#-navigation)
  - [💬 Feedback](#-feedback)
  - [📝 Data Input](#-data-input)
  - [📐 Layout](#-layout)
  - [🖥️ Mockup](#️-mockup)
- [Development](#-development)
- [Contributing](#-contributing)

---

## 🤔 What is this?

[DaisyUI](https://daisyui.com) is a component library built on top of
[Tailwind CSS](https://tailwindcss.com). It gives you semantic class names like
`btn-primary` and `card-body` that automatically adapt to themes.

[Lustre](https://hexdocs.pm/lustre/) is a Gleam web framework that models your
UI as a tree of `Element(msg)` values — think Elm architecture but in Gleam.

**daisyui_gleam** bridges the two. Every component is an opaque builder:

```gleam
// ❌ Instead of remembering class strings...
html.button(
  [attribute.class("btn btn-outline btn-primary btn-lg")],
  [html.text("Click")],
)

// ✅ You get autocomplete and a compiler that catches typos
button.new()
|> button.outline
|> button.primary
|> button.lg
|> button.text("Click")
|> button.build
```

The library does **not** ship any CSS — it generates the correct DaisyUI class
strings for you. You bring DaisyUI and Tailwind via npm (one-time setup below).

---

## 📦 Installation

### 1. Add the Gleam package

```sh
gleam add daisyui_gleam
```

Your project must target JavaScript (`target = "javascript"` in `gleam.toml`)
since Lustre renders in the browser.

### 2. Install DaisyUI via npm

DaisyUI v5 ships Tailwind v4 as a peer dependency — one install gets both:

```sh
npm install --save-dev daisyui
```

### 3. Wire up your CSS

Create a CSS entry point (e.g. `src/app.css`):

```css
@import "tailwindcss";
@import "../node_modules/daisyui/daisyui.css";
```

Then reference it from your HTML. If you are using
[`lustre_dev_tools`](https://hexdocs.pm/lustre_dev_tools/) the dev server picks
it up automatically when the CSS file matches your module name.

> 📚 **Further reading:** [DaisyUI install guide](https://daisyui.com/docs/install/) · [Lustre getting started](https://hexdocs.pm/lustre/)

---

## 🚀 Quick Start

A minimal Lustre app that renders a card with a button:

```gleam
import daisyui/button
import daisyui/card
import lustre
import lustre/attribute
import lustre/element.{type Element}
import lustre/element/html
import lustre/event

pub type Msg {
  UserClickedBuy
}

pub fn main() {
  let app = lustre.simple(fn(_) { Nil }, fn(_, _) { Nil }, view)
  let assert Ok(_) = lustre.start(app, "#app", Nil)
  Nil
}

fn view(_model: Nil) -> Element(Msg) {
  html.div(
    [attribute.class("min-h-screen bg-base-200 flex items-center justify-center")],
    [
      card.new()
      |> card.border
      |> card.attrs([attribute.class("w-96 bg-base-100 shadow-sm")])
      |> card.title([html.text("Hello, DaisyUI!")])
      |> card.body([
        html.p([], [html.text("Type-safe components for Lustre.")]),
      ])
      |> card.actions(
        attrs: [attribute.class("justify-end")],
        children: [
          button.new()
          |> button.primary
          |> button.on_click(UserClickedBuy)
          |> button.text("Buy Now")
          |> button.build,
        ],
      )
      |> card.build,
    ],
  )
}
```

---

## 🏗️ How the builder pattern works

Every component follows the same three-step rhythm:

```
new()           ← create a blank builder
|> modifier()   ← chain as many setters as you need
|> build        ← produce a Lustre Element(msg)
```

Builders are **opaque** — you can't pattern-match on them, only use the
provided functions. This keeps the internal representation free to evolve.

```gleam
// A soft warning badge at small size
badge.new()
|> badge.warning      // colour
|> badge.soft         // style variant
|> badge.sm           // size
|> badge.text("Beta") // content
|> badge.build        // → Element(msg)
```

Interactive components expose named event functions that fit naturally in the builder chain:

```gleam
button.new()
|> button.primary
|> button.on_click(UserSubmitted)
|> button.text("Submit")
|> button.build

input.new()
|> input.primary
|> input.on_input(UserTyped)
|> input.attrs([attribute.placeholder("Search…")])
|> input.build
```

Every builder also exposes an `attrs/2` function for arbitrary Lustre attributes — multiple calls accumulate rather than replace, so you can freely mix event functions with `attrs`:

```gleam
button.new()
|> button.primary
|> button.on_click(UserSubmitted)
|> button.attrs([attribute.id("submit-btn"), attribute.type_("submit")])
|> button.text("Submit")
|> button.build
```

For advanced cases (`event.advanced`, `event.prevent_default`, custom decoders), drop the raw attribute into `attrs` as the escape hatch.

Some thin-wrapper components (e.g. `skeleton`, `link`, `theme_controller`)
expose plain functions instead of a builder — there is no state to accumulate.

---

## 🎨 The colour system

DaisyUI's semantic colour tokens are consistent across every component:

| Function | DaisyUI class suffix | CSS variable |
|----------|----------------------|--------------|
| `.primary` | `*-primary` | `--color-primary` |
| `.secondary` | `*-secondary` | `--color-secondary` |
| `.accent` | `*-accent` | `--color-accent` |
| `.neutral` | `*-neutral` | `--color-neutral` |
| `.info` | `*-info` | `--color-info` |
| `.success` | `*-success` | `--color-success` |
| `.warning` | `*-warning` | `--color-warning` |
| `.error` | `*-error` | `--color-error` |

Switching DaisyUI themes updates every colour automatically — your Gleam code
stays the same.

> 📚 [DaisyUI colour tokens](https://daisyui.com/docs/colors/)

---

## 🎭 Theming

DaisyUI ships **35 built-in themes** that instantly transform your entire UI.
Because every component uses semantic colour tokens (`--color-primary`, etc.),
switching themes requires zero changes to your Gleam code — just swap a
`data-theme` attribute on the `<html>` element.

### Built-in themes

<details>
<summary>View all 35 themes</summary>

| Theme | | Theme | | Theme | |
|-------|--|-------|--|-------|--|
| `light` ⭐ default | 🤍 | `dark` 🌑 prefersdark | 🖤 | `cupcake` | 🧁 |
| `bumblebee` | 🐝 | `emerald` | 💚 | `corporate` | 🏢 |
| `synthwave` | 🌆 | `retro` | 📼 | `cyberpunk` | 🤖 |
| `valentine` | 💝 | `halloween` | 🎃 | `garden` | 🌸 |
| `forest` | 🌲 | `aqua` | 🌊 | `lofi` | 🎵 |
| `pastel` | 🎨 | `fantasy` | 🧝 | `wireframe` | 📐 |
| `black` | ⬛ | `luxury` | 👑 | `dracula` | 🧛 |
| `cmyk` | 🖨️ | `autumn` | 🍂 | `business` | 💼 |
| `acid` | 🧪 | `lemonade` | 🍋 | `night` | 🌃 |
| `coffee` | ☕ | `winter` | ❄️ | `dim` | 🔅 |
| `nord` | 🧊 | `sunset` | 🌅 | `caramellatte` | 🍮 |
| `abyss` | 🌌 | `silk` | 🪡 | | |

</details>

---

### Enabling themes

Control which themes are bundled in your CSS via the `@plugin` directive.
By default only `light` and `dark` are included.

```css
/* src/app.css */
@import "tailwindcss";

/* Default: light + dark only */
@plugin "daisyui" {
  themes: light --default, dark --prefersdark;
}

/* Add extra themes */
@plugin "daisyui" {
  themes: light --default, dark --prefersdark, cupcake, dracula, nord;
}

/* Enable all 35 built-in themes */
@plugin "daisyui" {
  themes: all;
}

/* Disable theming entirely (removes all daisyUI colour variables) */
@plugin "daisyui" {
  themes: false;
}
```

> 💡 **Tip:** Use `themes: all` during development so you can test every theme,
> then narrow the list before shipping to keep your CSS bundle lean.

---

### Applying a theme

Set `data-theme` on the `<html>` element to activate a theme for the whole page:

```html
<html data-theme="cupcake">
  ...
</html>
```

In Lustre you can do this from your `view` or by manipulating the DOM directly.
For persistent user-selectable themes, the
[`theme_controller`](https://hexdocs.pm/daisyui_gleam/daisyui/theme_controller.html)
component handles it with pure CSS (no JS required), or reach for
[theme-change](https://github.com/saadeghi/theme-change) for localStorage
persistence.

---

### Scoped themes

`data-theme` can be placed on **any** element — themes nest freely with no limit:

```html
<html data-theme="dark">
  <div data-theme="light">
    This section is always light...
    <span data-theme="retro">...and this span is always retro!</span>
  </div>
</html>
```

This is useful for things like always-dark sidebars, always-light modals, or
per-widget theme previews.

---

### Custom themes

Define a brand-new theme with `@plugin "daisyui/theme"` in your CSS file.
Every colour token can be set; omitted tokens fall back to the DaisyUI defaults.

```css
/* src/app.css */
@import "tailwindcss";
@plugin "daisyui";

@plugin "daisyui/theme" {
  name: "mytheme";
  default: true;          /* use as the page default */
  prefersdark: false;     /* use as the dark-mode default */
  color-scheme: light;    /* hint for browser UI (scrollbars, inputs, etc.) */

  /* Backgrounds */
  --color-base-100: oklch(98% 0.02 240);
  --color-base-200: oklch(95% 0.03 240);
  --color-base-300: oklch(92% 0.04 240);
  --color-base-content: oklch(20% 0.05 240);

  /* Brand colours */
  --color-primary: oklch(55% 0.3 240);
  --color-primary-content: oklch(98% 0.01 240);
  --color-secondary: oklch(70% 0.25 200);
  --color-secondary-content: oklch(98% 0.01 200);
  --color-accent: oklch(65% 0.25 160);
  --color-accent-content: oklch(98% 0.01 160);
  --color-neutral: oklch(50% 0.05 240);
  --color-neutral-content: oklch(98% 0.01 240);

  /* Semantic colours */
  --color-info: oklch(70% 0.2 220);
  --color-info-content: oklch(98% 0.01 220);
  --color-success: oklch(65% 0.25 140);
  --color-success-content: oklch(98% 0.01 140);
  --color-warning: oklch(80% 0.25 80);
  --color-warning-content: oklch(20% 0.05 80);
  --color-error: oklch(65% 0.3 30);
  --color-error-content: oklch(98% 0.01 30);

  /* Shape */
  --radius-selector: 1rem;    /* checkboxes, radios, badges */
  --radius-field: 0.25rem;    /* inputs, selects */
  --radius-box: 0.5rem;       /* cards, modals, dropdowns */

  /* Sizing */
  --size-selector: 0.25rem;
  --size-field: 0.25rem;

  /* Border */
  --border: 1px;

  /* Effects */
  --depth: 1;   /* shadow depth multiplier */
  --noise: 0;   /* noise texture overlay opacity */
}
```

Activate it the same way as a built-in theme:

```html
<html data-theme="mytheme">…</html>
```

> 🌐 If you are loading DaisyUI from a CDN (no build step), define your theme
> with plain CSS variables instead:
> ```css
> :root:has(input.theme-controller[value=mytheme]:checked),
> [data-theme="mytheme"] {
>   color-scheme: light;
>   --color-primary: oklch(55% 0.3 240);
>   /* …rest of your variables */
> }
> ```

---

### Customising a built-in theme

Override only the tokens you want to change — everything else is inherited from
the original theme:

```css
@import "tailwindcss";
@plugin "daisyui";

@plugin "daisyui/theme" {
  name: "light";       /* same name as built-in = override */
  default: true;
  --color-primary: oklch(50% 0.3 260);   /* custom purple primary */
  --color-secondary: oklch(65% 0.2 180); /* custom teal secondary */
}
```

You can also add element-level overrides scoped to a specific theme:

```css
[data-theme="light"] {
  .btn-brand {
    background-color: #1EA1F1;
    border-color: #1EA1F1;
  }
  .btn-brand:hover {
    background-color: #1C96E1;
    border-color: #1C96E1;
  }
}
```

---

### Tailwind `dark:` selector

Configure daisyUI so that Tailwind's `dark:` prefix maps to a specific theme.
This is done with `@custom-variant` after your plugin declarations:

```css
@import "tailwindcss";
@plugin "daisyui" {
  themes: winter --default, night --prefersdark;
}

/* Map dark: to the "night" daisyUI theme */
@custom-variant dark (&:where([data-theme=night], [data-theme=night] *));
```

Now you can use `dark:` utilities in your markup:

```html
<div class="p-10 dark:p-20">
  10px padding on the winter theme, 20px on the night theme
</div>
```

> 📚 [Full DaisyUI theming docs](https://daisyui.com/docs/themes/)

---

### Theme switching in Lustre apps

There are three approaches to theme switching in a Lustre application. They can
all coexist — pick whichever fits your needs.

#### 1️⃣ Model-driven (recommended for full control)

Store the active theme name in your model. A `Msg` triggers `update`, which
stores the new theme name, and `view` re-renders the root element with the
updated `data-theme` attribute. This is the right choice when you need to react
to the theme in code (e.g. swap a chart palette or load different assets).

```gleam
import daisyui/select
import lustre
import lustre/attribute
import lustre/element.{type Element}
import lustre/element/html
import lustre/event

pub type Model { Model(theme: String) }
pub type Msg   { UserPickedTheme(String) }

pub fn main() {
  let app = lustre.simple(fn(_) { Model(theme: "light") }, update, view)
  let assert Ok(_) = lustre.start(app, "#app", Nil)
  Nil
}

fn update(_model: Model, msg: Msg) -> Model {
  case msg {
    UserPickedTheme(t) -> Model(theme: t)
  }
}

fn view(model: Model) -> Element(Msg) {
  // Set data-theme on the root — the whole page inherits the theme.
  html.div(
    [
      attribute.attribute("data-theme", model.theme),
      attribute.class("min-h-screen bg-base-200"),
    ],
    [
      // A <select> fires UserPickedTheme on every change
      select.new()
      |> select.on_change(UserPickedTheme)
      |> select.attrs([attribute.value(model.theme)])
      |> select.children([
        html.option([attribute.value("light")],     "light"),
        html.option([attribute.value("dark")],      "dark"),
        html.option([attribute.value("cupcake")],   "cupcake"),
        html.option([attribute.value("synthwave")], "synthwave"),
      ])
      |> select.build,
      // ...rest of your UI
    ],
  )
}
```

#### 2️⃣ CSS-only toggle (two themes, no JS)

A `theme_controller` checkbox swaps between two themes entirely through CSS —
no `Msg`, no `update`, no JavaScript. Ideal for a simple dark/light toggle.

```gleam
import daisyui/theme_controller as tc
import lustre/element/html
import lustre/attribute

// A labelled toggle: checking it activates "dark", unchecking restores the default
html.label(
  [attribute.class("flex items-center gap-2 cursor-pointer")],
  [
    html.span([], [html.text("Light")]),
    tc.toggle("dark", []),
    html.span([], [html.text("Dark")]),
  ],
)
```

#### 3️⃣ CSS-only dropdown (many themes, no JS)

Radio inputs inside a dropdown each carry a `theme-controller` class. DaisyUI
activates whichever radio is checked. Still no JavaScript needed.

```gleam
import daisyui/theme_controller as tc
import lustre/element/html
import lustre/attribute
import gleam/list

html.div([attribute.class("dropdown")], [
  html.div(
    [attribute.role("button"), attribute.class("btn btn-outline m-1")],
    [html.text("Theme ▾")],
  ),
  html.ul(
    [attribute.class("dropdown-content bg-base-300 rounded-box w-48 p-2 shadow-2xl")],
    list.map(["light", "dark", "cupcake", "dracula", "nord"], fn(t) {
      html.li([], [tc.radio_dropdown("theme-pick", t, t, [])])
    }),
  ),
])
```

> 💻 **[See the full working example →](examples/theme_switcher_example)**  
> Run it with `cd examples/theme_switcher_example && gleam run -m lustre/dev start`

---

## 🧩 Components

**60 components across 7 categories.** Click any category to expand.

A shared [`tokens`](https://hexdocs.pm/daisyui_gleam/daisyui/tokens.html)
module defines the `Color`, `Size`, `TextSize`, `Weight`, and `Variant` types
reused across components — you rarely need to import it directly.

---

<details>
<summary><strong>🎬 Actions</strong> &nbsp;—&nbsp; Button · Dropdown · FAB · Modal · Swap · Theme Controller</summary>

---

#### 🔘 Button &nbsp;·&nbsp; [`daisyui/button`](https://hexdocs.pm/daisyui_gleam/daisyui/button.html)

<table><tr>
<td width="280"><img src="https://img.daisyui.com/images/components/button.webp" width="280" alt="Button preview"/></td>
<td valign="top">

All colours, styles (outline, ghost, soft, dash, link), sizes, and layout modifiers. Works as `<button>`, `<a>`, or `<input>`.

```gleam
import daisyui/button
import lustre/event

// Primary button with click handler
button.new()
|> button.primary
|> button.lg
|> button.on_click(Clicked)
|> button.text("Get started")
|> button.build

// Outline ghost button
button.new()
|> button.outline
|> button.ghost
|> button.text("Cancel")
|> button.build

// Loading state
button.new()
|> button.secondary
|> button.loading
|> button.text("Saving…")
|> button.build
```

🌐 [DaisyUI docs](https://daisyui.com/components/button/) · 💻 [Example](examples/example_button)

</td>
</tr></table>

---

#### 📂 Dropdown &nbsp;·&nbsp; [`daisyui/dropdown`](https://hexdocs.pm/daisyui_gleam/daisyui/dropdown.html)

<table><tr>
<td width="280"><img src="https://img.daisyui.com/images/components/dropdown.webp" width="280" alt="Dropdown preview"/></td>
<td valign="top">

Opens a menu or arbitrary content when a trigger is clicked. Supports hover, force-open, and 9 placement combinations.

```gleam
import daisyui/button
import daisyui/dropdown
import lustre/element/html

dropdown.new()
|> dropdown.bottom
|> dropdown.align_end
|> dropdown.trigger([
  button.new()
  |> button.text("Open menu")
  |> button.build,
])
|> dropdown.content([
  html.ul([attribute.class("menu bg-base-100 rounded-box w-52")], [
    html.li([], [html.a([], [html.text("Profile")])]),
    html.li([], [html.a([], [html.text("Settings")])]),
    html.li([], [html.a([], [html.text("Logout")])]),
  ]),
])
|> dropdown.build
```

🌐 [DaisyUI docs](https://daisyui.com/components/dropdown/) · 💻 [Example](examples/example_dropdown)

</td>
</tr></table>

---

#### 🚀 FAB / Speed Dial &nbsp;·&nbsp; [`daisyui/fab`](https://hexdocs.pm/daisyui_gleam/daisyui/fab.html)

<table><tr>
<td width="280"><img src="https://img.daisyui.com/images/components/fab.webp" width="280" alt="FAB preview"/></td>
<td valign="top">

Floating Action Button fixed to a corner of the screen. Optionally reveals Speed Dial sub-buttons on focus.

```gleam
import daisyui/button
import daisyui/fab

// Simple FAB
fab.new()
|> fab.main_action([
  button.new()
  |> button.circle
  |> button.primary
  |> button.text("+")
  |> button.build,
])
|> fab.build

// Speed Dial with sub-actions
fab.new()
|> fab.flower
|> fab.trigger([button_el])
|> fab.items([item1, item2, item3])
|> fab.build
```

🌐 [DaisyUI docs](https://daisyui.com/components/fab/) · 💻 [Example](examples/example_fab)

</td>
</tr></table>

---

#### 🪟 Modal &nbsp;·&nbsp; [`daisyui/modal`](https://hexdocs.pm/daisyui_gleam/daisyui/modal.html)

<table><tr>
<td width="280"><img src="https://img.daisyui.com/images/components/modal.webp" width="280" alt="Modal preview"/></td>
<td valign="top">

Dialog overlay using native `<dialog>` (recommended) or a legacy checkbox approach. Supports 9 positioning combinations.

```gleam
import daisyui/modal
import lustre/element/html

// Native <dialog> modal
html.div([], [
  // Trigger button
  modal.trigger("confirm-modal", [
    modal.trigger_text("Open"),
  ]),
  // Dialog
  modal.dialog("confirm-modal", [
    modal.box([
      modal.title([html.text("Are you sure?")]),
      html.p([], [html.text("This action cannot be undone.")]),
      modal.action([
        modal.close_button([]),
        confirm_button,
      ]),
    ]),
    modal.backdrop_form([]),
  ]),
])
```

🌐 [DaisyUI docs](https://daisyui.com/components/modal/) · 💻 [Example](examples/example_modal)

</td>
</tr></table>

---

#### 🔀 Swap &nbsp;·&nbsp; [`daisyui/swap`](https://hexdocs.pm/daisyui_gleam/daisyui/swap.html)

<table><tr>
<td width="280"><img src="https://img.daisyui.com/images/components/swap.webp" width="280" alt="Swap preview"/></td>
<td valign="top">

Toggles between two elements via a hidden checkbox or the `swap-active` class. Supports rotate and flip animations.

```gleam
import daisyui/swap
import lustre/element/html

// Hamburger ↔ close icon toggle
swap.new()
|> swap.rotate
|> swap.on(html.text("✕"))
|> swap.off(html.text("☰"))
|> swap.build

// Emoji toggle with flip animation
swap.new()
|> swap.flip
|> swap.on(html.text("🌙"))
|> swap.off(html.text("🌞"))
|> swap.build
```

🌐 [DaisyUI docs](https://daisyui.com/components/swap/) · 💻 [Example](examples/example_swap)

</td>
</tr></table>

---

#### 🎨 Theme Controller &nbsp;·&nbsp; [`daisyui/theme_controller`](https://hexdocs.pm/daisyui_gleam/daisyui/theme_controller.html)

<table><tr>
<td width="280"><img src="https://img.daisyui.com/images/components/theme-controller.webp" width="280" alt="Theme Controller preview"/></td>
<td valign="top">

CSS-only page theme switching via a checked checkbox or radio input. No JavaScript required.

```gleam
import daisyui/theme_controller as tc

// Toggle button (checkbox)
tc.toggle_button("synthwave", "Dark theme", [])

// Dropdown of theme options
html.div([attribute.class("dropdown")], [
  tc.radio_item("cupcake", "Cupcake", []),
  tc.radio_item("dracula", "Dracula", []),
  tc.radio_item("forest", "Forest", []),
])

// Inside a swap for icon toggle
tc.swap_checkbox("synthwave", [])
```

🌐 [DaisyUI docs](https://daisyui.com/components/theme-controller/) · 💻 [Example](examples/example_theme_controller)

</td>
</tr></table>

</details>

---

<details>
<summary><strong>🗃️ Data Display</strong> &nbsp;—&nbsp; Accordion · Avatar · Badge · Card · Carousel · Chat · Collapse · Countdown · Diff · Hover 3D · Hover Gallery · Kbd · List · Stat · Status · Table · Text Rotate · Timeline</summary>

---

#### 🪗 Accordion &nbsp;·&nbsp; [`daisyui/accordion`](https://hexdocs.pm/daisyui_gleam/daisyui/accordion.html)

<table><tr>
<td width="280"><img src="https://img.daisyui.com/images/components/accordion.webp" width="280" alt="Accordion preview"/></td>
<td valign="top">

Expand/collapse content panels. Supports checkbox (independent), radio (exclusive), and `<details>` variants.

```gleam
import daisyui/accordion

// Radio accordion — only one open at a time
accordion.new()
|> accordion.radio("my-group", False)
|> accordion.arrow
|> accordion.title([html.text("What is Gleam?")])
|> accordion.content([
  html.p([], [html.text("A type-safe language on the BEAM.")])
])
|> accordion.build
```

🌐 [DaisyUI docs](https://daisyui.com/components/accordion/) · 💻 [Example](examples/example_accordion)

</td>
</tr></table>

---

#### 👤 Avatar &nbsp;·&nbsp; [`daisyui/avatar`](https://hexdocs.pm/daisyui_gleam/daisyui/avatar.html)

<table><tr>
<td width="280"><img src="https://img.daisyui.com/images/components/avatar.webp" width="280" alt="Avatar preview"/></td>
<td valign="top">

User profile images with online/offline indicators, placeholder initials, and group stacking.

```gleam
import daisyui/avatar
import lustre/element/html

// Image avatar with online indicator
avatar.new()
|> avatar.online
|> avatar.rounded_full
|> avatar.size("w-12")
|> avatar.img("/images/user.jpg", "User name")
|> avatar.build

// Placeholder with initials
avatar.new()
|> avatar.placeholder
|> avatar.primary
|> avatar.size("w-12")
|> avatar.initials("JD")
|> avatar.build
```

🌐 [DaisyUI docs](https://daisyui.com/components/avatar/) · 💻 [Example](examples/example_avatar)

</td>
</tr></table>

---

#### 🏷️ Badge &nbsp;·&nbsp; [`daisyui/badge`](https://hexdocs.pm/daisyui_gleam/daisyui/badge.html)

<table><tr>
<td width="280"><img src="https://img.daisyui.com/images/components/badge.webp" width="280" alt="Badge preview"/></td>
<td valign="top">

Small labels for counts, status, or categorisation. All colours and sizes available.

```gleam
import daisyui/badge

badge.new()
|> badge.primary
|> badge.text("New")
|> badge.build

badge.new()
|> badge.error
|> badge.soft
|> badge.sm
|> badge.text("99+")
|> badge.build
```

🌐 [DaisyUI docs](https://daisyui.com/components/badge/) · 💻 [Example](examples/example_badge)

</td>
</tr></table>

---

#### 🃏 Card &nbsp;·&nbsp; [`daisyui/card`](https://hexdocs.pm/daisyui_gleam/daisyui/card.html)

<table><tr>
<td width="280"><img src="https://img.daisyui.com/images/components/card.webp" width="280" alt="Card preview"/></td>
<td valign="top">

Flexible content container with figure, title, body, and actions slots. Supports image overlays and compact layout.

```gleam
import daisyui/card

card.new()
|> card.border
|> card.figure([html.img([attribute.src("/img/cover.jpg")], [])])
|> card.title([html.text("Card Title")])
|> card.body([html.p([], [html.text("Card description.")])])
|> card.actions(
  attrs: [attribute.class("justify-end")],
  children: [buy_button],
)
|> card.build
```

🌐 [DaisyUI docs](https://daisyui.com/components/card/) · 💻 [Example](examples/example_card)

</td>
</tr></table>

---

#### 🎠 Carousel &nbsp;·&nbsp; [`daisyui/carousel`](https://hexdocs.pm/daisyui_gleam/daisyui/carousel.html)

<table><tr>
<td width="280"><img src="https://img.daisyui.com/images/components/carousel.webp" width="280" alt="Carousel preview"/></td>
<td valign="top">

Horizontally or vertically scrolling content slider with snap alignment.

```gleam
import daisyui/carousel
import lustre/element/html

carousel.new()
|> carousel.center
|> carousel.items([
  carousel.item([html.img([attribute.src("/img/1.jpg")], [])]),
  carousel.item([html.img([attribute.src("/img/2.jpg")], [])]),
  carousel.item([html.img([attribute.src("/img/3.jpg")], [])]),
])
|> carousel.build
```

🌐 [DaisyUI docs](https://daisyui.com/components/carousel/) · 💻 [Example](examples/example_carousel)

</td>
</tr></table>

---

#### 💬 Chat Bubble &nbsp;·&nbsp; [`daisyui/chat`](https://hexdocs.pm/daisyui_gleam/daisyui/chat.html)

<table><tr>
<td width="280"><img src="https://img.daisyui.com/images/components/chat.webp" width="280" alt="Chat preview"/></td>
<td valign="top">

Chat message bubbles with avatar, header, footer, and colour tints for sent/received distinction.

```gleam
import daisyui/chat

// Sent message (right-aligned)
chat.new()
|> chat.end
|> chat.primary
|> chat.header([html.text("You"), timestamp_el])
|> chat.text("Hey, how's it going?")
|> chat.build

// Received message (left-aligned)
chat.new()
|> chat.start
|> chat.image([avatar_el])
|> chat.text("All good! Just shipping some Gleam. 🚢")
|> chat.build
```

🌐 [DaisyUI docs](https://daisyui.com/components/chat/) · 💻 [Example](examples/example_chat)

</td>
</tr></table>

---

#### 📖 Collapse &nbsp;·&nbsp; [`daisyui/collapse`](https://hexdocs.pm/daisyui_gleam/daisyui/collapse.html)

<table><tr>
<td width="280"><img src="https://img.daisyui.com/images/components/collapse.webp" width="280" alt="Collapse preview"/></td>
<td valign="top">

A single expand/collapse panel using checkbox, radio, or native `<details>` semantics.

```gleam
import daisyui/collapse
import lustre/element/html

collapse.new()
|> collapse.plus
|> collapse.title([html.text("Click to expand")])
|> collapse.content([
  html.p([], [html.text("Hidden content revealed on click.")])
])
|> collapse.build
```

🌐 [DaisyUI docs](https://daisyui.com/components/collapse/) · 💻 [Example](examples/example_collapse)

</td>
</tr></table>

---

#### ⏱️ Countdown &nbsp;·&nbsp; [`daisyui/countdown`](https://hexdocs.pm/daisyui_gleam/daisyui/countdown.html)

<table><tr>
<td width="280"><img src="https://img.daisyui.com/images/components/countdown.webp" width="280" alt="Countdown preview"/></td>
<td valign="top">

Animated rolling-digit transition when cycling numbers 0–999. Compose multiple to build a timer display.

```gleam
import daisyui/countdown
import lustre/element/html

// Display "02:30:00"
html.div([attribute.class("flex gap-2 text-5xl font-mono")], [
  countdown.new(2)  |> countdown.min_digits(2) |> countdown.build,
  html.span([], [html.text(":")]),
  countdown.new(30) |> countdown.min_digits(2) |> countdown.build,
  html.span([], [html.text(":")]),
  countdown.new(0)  |> countdown.min_digits(2) |> countdown.build,
])
```

🌐 [DaisyUI docs](https://daisyui.com/components/countdown/) · 💻 [Example](examples/example_countdown)

</td>
</tr></table>

---

#### 🔲 Diff &nbsp;·&nbsp; [`daisyui/diff`](https://hexdocs.pm/daisyui_gleam/daisyui/diff.html)

<table><tr>
<td width="280"><img src="https://img.daisyui.com/images/components/diff.webp" width="280" alt="Diff preview"/></td>
<td valign="top">

Side-by-side comparison of two items with a draggable divider. Great for before/after image reveals.

```gleam
import daisyui/diff
import lustre/element/html

diff.new()
|> diff.item1([
  html.img([attribute.src("/img/before.jpg")], [])
])
|> diff.item2([
  html.img([attribute.src("/img/after.jpg")], [])
])
|> diff.build
```

🌐 [DaisyUI docs](https://daisyui.com/components/diff/) · 💻 [Example](examples/example_diff)

</td>
</tr></table>

---

#### 🌐 Hover 3D Card &nbsp;·&nbsp; [`daisyui/hover_3d`](https://hexdocs.pm/daisyui_gleam/daisyui/hover_3d.html)

<table><tr>
<td width="280"><img src="https://img.daisyui.com/images/components/hover-3d.webp" width="280" alt="Hover 3D preview"/></td>
<td valign="top">

Wraps any content and adds a CSS 3D tilt/rotate effect driven by mouse position over the element.

```gleam
import daisyui/hover_3d
import lustre/element/html

hover_3d.container([attribute.class("w-48 h-48")], [
  hover_3d.layer_back([
    html.div([attribute.class("bg-primary w-full h-full rounded-xl")], [])
  ]),
  hover_3d.layer_middle([card_el]),
  hover_3d.layer_front([icon_el]),
])
```

🌐 [DaisyUI docs](https://daisyui.com/components/hover-3d/) · 💻 [Example](examples/example_hover_3d)

</td>
</tr></table>

---

#### 🖼️ Hover Gallery &nbsp;·&nbsp; [`daisyui/hover_gallery`](https://hexdocs.pm/daisyui_gleam/daisyui/hover_gallery.html)

<table><tr>
<td width="280"><img src="https://img.daisyui.com/images/components/hover-gallery.webp" width="280" alt="Hover Gallery preview"/></td>
<td valign="top">

Image container that reveals additional images on horizontal hover. Supports up to 10 images.

```gleam
import daisyui/hover_gallery
import lustre/element/html

hover_gallery.gallery([
  html.img([attribute.src("/img/1.jpg"), attribute.alt("Photo 1")], []),
  html.img([attribute.src("/img/2.jpg"), attribute.alt("Photo 2")], []),
  html.img([attribute.src("/img/3.jpg"), attribute.alt("Photo 3")], []),
])
```

🌐 [DaisyUI docs](https://daisyui.com/components/hover-gallery/) · 💻 [Example](examples/example_hover_gallery)

</td>
</tr></table>

---

#### ⌨️ Kbd &nbsp;·&nbsp; [`daisyui/kbd`](https://hexdocs.pm/daisyui_gleam/daisyui/kbd.html)

<table><tr>
<td width="280"><img src="https://img.daisyui.com/images/components/kbd.webp" width="280" alt="Kbd preview"/></td>
<td valign="top">

Displays keyboard shortcuts in a key-cap style. All sizes available.

```gleam
import daisyui/kbd
import lustre/element/html

// Ctrl + S
html.span([], [
  kbd.new() |> kbd.sm |> kbd.text("Ctrl") |> kbd.build,
  html.text(" + "),
  kbd.new() |> kbd.sm |> kbd.text("S") |> kbd.build,
])
```

🌐 [DaisyUI docs](https://daisyui.com/components/kbd/) · 💻 [Example](examples/example_kbd)

</td>
</tr></table>

---

#### 📋 List &nbsp;·&nbsp; [`daisyui/list`](https://hexdocs.pm/daisyui_gleam/daisyui/list.html)

<table><tr>
<td width="280"><img src="https://img.daisyui.com/images/components/list.webp" width="280" alt="List preview"/></td>
<td valign="top">

Vertical layout for displaying information in labelled rows — great for settings panels and detail views.

```gleam
import daisyui/list
import lustre/element/html

list.new()
|> list.items([
  list.item([
    list.item_label("Name"),
    list.item_value([html.text("Jane Doe")]),
  ]),
  list.item([
    list.item_label("Role"),
    list.item_value([html.text("Engineer")]),
  ]),
])
|> list.build
```

🌐 [DaisyUI docs](https://daisyui.com/components/list/) · 💻 [Example](examples/example_list)

</td>
</tr></table>

---

#### 📊 Stat &nbsp;·&nbsp; [`daisyui/stat`](https://hexdocs.pm/daisyui_gleam/daisyui/stat.html)

<table><tr>
<td width="280"><img src="https://img.daisyui.com/images/components/stat.webp" width="280" alt="Stat preview"/></td>
<td valign="top">

Data display block with figure, title, value, description, and actions slots. Compose multiple inside a `Stats` container.

```gleam
import daisyui/stat

stat.new()
|> stat.items([
  stat.item()
  |> stat.title("Total Users")
  |> stat.value("4,200")
  |> stat.desc("↑ 12% from last month")
  |> stat.item_build,

  stat.item()
  |> stat.title("Revenue")
  |> stat.value("$18,400")
  |> stat.desc("↑ 4.2% from last month")
  |> stat.item_build,
])
|> stat.build
```

🌐 [DaisyUI docs](https://daisyui.com/components/stat/) · 💻 [Example](examples/example_stat)

</td>
</tr></table>

---

#### 🟢 Status &nbsp;·&nbsp; [`daisyui/status`](https://hexdocs.pm/daisyui_gleam/daisyui/status.html)

<table><tr>
<td width="280"><img src="https://img.daisyui.com/images/components/status.webp" width="280" alt="Status preview"/></td>
<td valign="top">

Tiny coloured dot indicating state (online, offline, error). Supports a ping animation for live indicators.

```gleam
import daisyui/status

// Simple green dot
status.new() |> status.success |> status.build

// Animated ping for "live"
status.new()
|> status.error
|> status.lg
|> status.ping
|> status.build
```

🌐 [DaisyUI docs](https://daisyui.com/components/status/) · 💻 [Example](examples/example_status)

</td>
</tr></table>

---

#### 📅 Table &nbsp;·&nbsp; [`daisyui/table`](https://hexdocs.pm/daisyui_gleam/daisyui/table.html)

<table><tr>
<td width="280"><img src="https://img.daisyui.com/images/components/table.webp" width="280" alt="Table preview"/></td>
<td valign="top">

Data table with zebra stripes, sticky header/column, and size variants. Wrap in `table.wrap` for horizontal scroll.

```gleam
import daisyui/table
import lustre/element/html

table.build(
  attrs: [table.zebra, table.pin_rows],
  head: [html.th([], [html.text("Name")]), html.th([], [html.text("Role")])],
  body: [
    html.tr([], [html.td([], [html.text("Alice")]), html.td([], [html.text("Admin")])]),
    html.tr([], [html.td([], [html.text("Bob")]),   html.td([], [html.text("User")])]),
  ],
  foot: [],
)
|> table.wrap
```

🌐 [DaisyUI docs](https://daisyui.com/components/table/) · 💻 [Example](examples/example_table)

</td>
</tr></table>

---

#### 🔄 Text Rotate &nbsp;·&nbsp; [`daisyui/text_rotate`](https://hexdocs.pm/daisyui_gleam/daisyui/text_rotate.html)

<table><tr>
<td width="280"><img src="https://img.daisyui.com/images/components/text-rotate.webp" width="280" alt="Text Rotate preview"/></td>
<td valign="top">

Cycles through up to 6 text items with an infinite loop animation. Perfect for hero taglines.

```gleam
import daisyui/text_rotate
import lustre/element/html

html.span([attribute.class("text-4xl font-bold")], [
  html.text("We help you "),
  text_rotate.new()
  |> text_rotate.items([
    text_rotate.item("design"),
    text_rotate.item("build"),
    text_rotate.item("ship"),
    text_rotate.item("scale"),
  ])
  |> text_rotate.build,
])
```

🌐 [DaisyUI docs](https://daisyui.com/components/text-rotate/) · 💻 [Example](examples/example_text_rotate)

</td>
</tr></table>

---

#### 📆 Timeline &nbsp;·&nbsp; [`daisyui/timeline`](https://hexdocs.pm/daisyui_gleam/daisyui/timeline.html)

<table><tr>
<td width="280"><img src="https://img.daisyui.com/images/components/timeline.webp" width="280" alt="Timeline preview"/></td>
<td valign="top">

Chronological event list, horizontal or vertical, with start/middle/end slots per item.

```gleam
import daisyui/timeline
import lustre/element/html

timeline.new()
|> timeline.vertical
|> timeline.items([
  timeline.item()
  |> timeline.item_start_box([html.text("2023")])
  |> timeline.item_middle(icon_el)
  |> timeline.item_end_box([html.text("Project kicked off")])
  |> timeline.item_build,
  // …more items
])
|> timeline.build
```

🌐 [DaisyUI docs](https://daisyui.com/components/timeline/) · 💻 [Example](examples/example_timeline)

</td>
</tr></table>

</details>

---

<details>
<summary><strong>🧭 Navigation</strong> &nbsp;—&nbsp; Breadcrumbs · Dock · Link · Menu · Navbar · Pagination · Steps · Tabs</summary>

---

#### 🍞 Breadcrumbs &nbsp;·&nbsp; [`daisyui/breadcrumbs`](https://hexdocs.pm/daisyui_gleam/daisyui/breadcrumbs.html)

<table><tr>
<td width="280"><img src="https://img.daisyui.com/images/components/breadcrumbs.webp" width="280" alt="Breadcrumbs preview"/></td>
<td valign="top">

Navigation trail showing the current page location within a hierarchy.

```gleam
import daisyui/breadcrumbs
import lustre/element/html

breadcrumbs.new()
|> breadcrumbs.items([
  breadcrumbs.item([html.a([attribute.href("/")], [html.text("Home")])]),
  breadcrumbs.item([html.a([attribute.href("/docs")], [html.text("Docs")])]),
  breadcrumbs.item([html.text("Components")]),
])
|> breadcrumbs.build
```

🌐 [DaisyUI docs](https://daisyui.com/components/breadcrumbs/) · 💻 [Example](examples/example_breadcrumbs)

</td>
</tr></table>

---

#### ⚓ Dock &nbsp;·&nbsp; [`daisyui/dock`](https://hexdocs.pm/daisyui_gleam/daisyui/dock.html)

<table><tr>
<td width="280"><img src="https://img.daisyui.com/images/components/dock.webp" width="280" alt="Dock preview"/></td>
<td valign="top">

Bottom navigation bar that sticks to the bottom of the viewport, inspired by mobile app navigation.

```gleam
import daisyui/dock

dock.new()
|> dock.md
|> dock.items([
  dock.item_new()
  |> dock.item_active
  |> dock.item_children([home_icon])
  |> dock.item_label("Home")
  |> dock.item_build,

  dock.item_new()
  |> dock.item_children([search_icon])
  |> dock.item_label("Search")
  |> dock.item_build,
])
|> dock.build
```

🌐 [DaisyUI docs](https://daisyui.com/components/dock/) · 💻 [Example](examples/example_dock)

</td>
</tr></table>

---

#### 🔗 Link &nbsp;·&nbsp; [`daisyui/link`](https://hexdocs.pm/daisyui_gleam/daisyui/link.html)

<table><tr>
<td width="280"><img src="https://img.daisyui.com/images/components/link.webp" width="280" alt="Link preview"/></td>
<td valign="top">

Adds the standard DaisyUI underline hover style to anchor elements. All colours and neutral available.

```gleam
import daisyui/link
import lustre/element/html

html.a([attribute.href("/docs")], [
  link.primary([html.text("Read the docs →")])
])

// Or with explicit attrs
link.link([attribute.href("#"), attribute.class("link-hover")], [
  html.text("Hover to see underline")
])
```

🌐 [DaisyUI docs](https://daisyui.com/components/link/) · 💻 [Example](examples/example_link)

</td>
</tr></table>

---

#### 📌 Menu &nbsp;·&nbsp; [`daisyui/menu`](https://hexdocs.pm/daisyui_gleam/daisyui/menu.html)

<table><tr>
<td width="280"><img src="https://img.daisyui.com/images/components/menu.webp" width="280" alt="Menu preview"/></td>
<td valign="top">

Vertical or horizontal navigation list with title, active, and disabled states. Supports nesting.

```gleam
import daisyui/menu
import lustre/element/html

menu.new()
|> menu.vertical
|> menu.items([
  menu.title("Dashboard"),
  menu.item([html.a([attribute.href("/")], [html.text("Overview")])]),
  menu.item_active([html.a([attribute.href("/stats")], [html.text("Stats")])]),
  menu.item_disabled([html.text("Reports (soon)")]),
])
|> menu.build
```

🌐 [DaisyUI docs](https://daisyui.com/components/menu/) · 💻 [Example](examples/example_menu)

</td>
</tr></table>

---

#### 🗂️ Navbar &nbsp;·&nbsp; [`daisyui/navbar`](https://hexdocs.pm/daisyui_gleam/daisyui/navbar.html)

<table><tr>
<td width="280"><img src="https://img.daisyui.com/images/components/navbar.webp" width="280" alt="Navbar preview"/></td>
<td valign="top">

Top-of-page navigation bar with start/center/end layout zones.

```gleam
import daisyui/navbar
import lustre/element/html

navbar.new()
|> navbar.start([
  html.a([attribute.class("btn btn-ghost text-xl")], [html.text("MyApp")])
])
|> navbar.center([menu_links])
|> navbar.end_([
  html.a([attribute.class("btn btn-primary btn-sm")], [html.text("Sign up")])
])
|> navbar.build
```

🌐 [DaisyUI docs](https://daisyui.com/components/navbar/) · 💻 [Example](examples/example_navbar)

</td>
</tr></table>

---

#### 📄 Pagination &nbsp;·&nbsp; [`daisyui/pagination`](https://hexdocs.pm/daisyui_gleam/daisyui/pagination.html)

<table><tr>
<td width="280"><img src="https://img.daisyui.com/images/components/pagination.webp" width="280" alt="Pagination preview"/></td>
<td valign="top">

Page navigation buttons with active, disabled, and outline states.

```gleam
import daisyui/pagination

pagination.new()
|> pagination.md
|> pagination.items([
  pagination.page("«") |> pagination.disabled |> pagination.page_attrs([attribute.href("#")]),
  pagination.page("1") |> pagination.active,
  pagination.page("2") |> pagination.page_attrs([attribute.href("?page=2")]),
  pagination.page("3") |> pagination.page_attrs([attribute.href("?page=3")]),
  pagination.page("»") |> pagination.page_attrs([attribute.href("?page=2")]),
])
|> pagination.build
```

🌐 [DaisyUI docs](https://daisyui.com/components/pagination/) · 💻 [Example](examples/example_pagination)

</td>
</tr></table>

---

#### 🪜 Steps &nbsp;·&nbsp; [`daisyui/steps`](https://hexdocs.pm/daisyui_gleam/daisyui/steps.html)

<table><tr>
<td width="280"><img src="https://img.daisyui.com/images/components/steps.webp" width="280" alt="Steps preview"/></td>
<td valign="top">

Visual list of process stages with colour-coded progress. Horizontal or vertical.

```gleam
import daisyui/steps

steps.new()
|> steps.horizontal
|> steps.items([
  steps.step("Cart")     |> steps.step_primary  |> steps.step_build,
  steps.step("Shipping") |> steps.step_primary  |> steps.step_build,
  steps.step("Payment")  |> steps.step_build,
  steps.step("Confirm")  |> steps.step_build,
])
|> steps.build
```

🌐 [DaisyUI docs](https://daisyui.com/components/steps/) · 💻 [Example](examples/example_steps)

</td>
</tr></table>

---

#### 🗂️ Tabs &nbsp;·&nbsp; [`daisyui/tabs`](https://hexdocs.pm/daisyui_gleam/daisyui/tabs.html)

<table><tr>
<td width="280"><img src="https://img.daisyui.com/images/components/tabs.webp" width="280" alt="Tabs preview"/></td>
<td valign="top">

Link/button tabs and radio-input tabs with content panels. Supports border, lift, and box styles.

```gleam
import daisyui/tabs

// Simple link tabs
tabs.new()
|> tabs.border
|> tabs.items([
  tabs.tab("Overview") |> tabs.tab_active |> tabs.tab_build,
  tabs.tab("Analytics") |> tabs.tab_build,
  tabs.tab("Settings") |> tabs.tab_build,
])
|> tabs.build

// Radio tabs with content panels (CSS-only interactivity)
tabs.radio_items("my-tabs", [
  tabs.radio_item("Tab 1", [panel_1_content]),
  tabs.radio_item("Tab 2", [panel_2_content]) |> tabs.radio_checked,
])
```

🌐 [DaisyUI docs](https://daisyui.com/components/tabs/) · 💻 [Example](examples/example_tabs)

</td>
</tr></table>

</details>

---

<details>
<summary><strong>💬 Feedback</strong> &nbsp;—&nbsp; Alert · Loading · Progress · Radial Progress · Skeleton · Toast</summary>

---

#### 🔔 Alert &nbsp;·&nbsp; [`daisyui/alert`](https://hexdocs.pm/daisyui_gleam/daisyui/alert.html)

<table><tr>
<td width="280"><img src="https://img.daisyui.com/images/components/alert.webp" width="280" alt="Alert preview"/></td>
<td valign="top">

Contextual feedback messages — info, success, warning, error. Supports icons and action buttons.

```gleam
import daisyui/alert
import lustre/element/html

alert.new()
|> alert.success
|> alert.soft
|> alert.children([
  html.span([], [html.text("✅ Your changes have been saved.")])
])
|> alert.build

alert.new()
|> alert.error
|> alert.children([
  html.span([], [html.text("Something went wrong.")]),
  retry_button,
])
|> alert.build
```

🌐 [DaisyUI docs](https://daisyui.com/components/alert/) · 💻 [Example](examples/example_alert)

</td>
</tr></table>

---

#### ⏳ Loading &nbsp;·&nbsp; [`daisyui/loading`](https://hexdocs.pm/daisyui_gleam/daisyui/loading.html)

<table><tr>
<td width="280"><img src="https://img.daisyui.com/images/components/loading.webp" width="280" alt="Loading preview"/></td>
<td valign="top">

Animated spinner, dots, ring, bars, infinity, or ball indicators. All colours and sizes.

```gleam
import daisyui/loading

// Spinning ring
loading.new()
|> loading.ring
|> loading.primary
|> loading.lg
|> loading.build

// Bouncing dots
loading.new()
|> loading.dots
|> loading.secondary
|> loading.build
```

🌐 [DaisyUI docs](https://daisyui.com/components/loading/) · 💻 [Example](examples/example_loading)

</td>
</tr></table>

---

#### 📈 Progress &nbsp;·&nbsp; [`daisyui/progress`](https://hexdocs.pm/daisyui_gleam/daisyui/progress.html)

<table><tr>
<td width="280"><img src="https://img.daisyui.com/images/components/progress.webp" width="280" alt="Progress preview"/></td>
<td valign="top">

Horizontal progress bar. Omit the value for an indeterminate animated state.

```gleam
import daisyui/progress

// Determinate — 60% complete
progress.new()
|> progress.primary
|> progress.value(60, 100)
|> progress.build

// Indeterminate
progress.new()
|> progress.secondary
|> progress.build
```

🌐 [DaisyUI docs](https://daisyui.com/components/progress/) · 💻 [Example](examples/example_progress)

</td>
</tr></table>

---

#### 🔵 Radial Progress &nbsp;·&nbsp; [`daisyui/radial_progress`](https://hexdocs.pm/daisyui_gleam/daisyui/radial_progress.html)

<table><tr>
<td width="280"><img src="https://img.daisyui.com/images/components/radial-progress.webp" width="280" alt="Radial Progress preview"/></td>
<td valign="top">

Circular progress indicator using CSS custom properties. Displays a percentage label inside.

```gleam
import daisyui/radial_progress

radial_progress.new()
|> radial_progress.percent(75)
|> radial_progress.primary
|> radial_progress.size("6rem")
|> radial_progress.build
```

🌐 [DaisyUI docs](https://daisyui.com/components/radial-progress/) · 💻 [Example](examples/example_radial_progress)

</td>
</tr></table>

---

#### 💀 Skeleton &nbsp;·&nbsp; [`daisyui/skeleton`](https://hexdocs.pm/daisyui_gleam/daisyui/skeleton.html)

<table><tr>
<td width="280"><img src="https://img.daisyui.com/images/components/skeleton.webp" width="280" alt="Skeleton preview"/></td>
<td valign="top">

Animated placeholder loading state for content blocks, circles, and text lines.

```gleam
import daisyui/skeleton
import lustre/attribute
import lustre/element/html

// Card skeleton
html.div([attribute.class("flex flex-col gap-4 w-52")], [
  skeleton.box([attribute.class("h-32 w-full")]),
  skeleton.box([attribute.class("h-4 w-28")]),
  skeleton.box([attribute.class("h-4 w-full")]),
])

// Animated gradient text
skeleton.text("Loading your content...")
```

🌐 [DaisyUI docs](https://daisyui.com/components/skeleton/) · 💻 [Example](examples/example_skeleton)

</td>
</tr></table>

---

#### 🍞 Toast &nbsp;·&nbsp; [`daisyui/toast`](https://hexdocs.pm/daisyui_gleam/daisyui/toast.html)

<table><tr>
<td width="280"><img src="https://img.daisyui.com/images/components/toast.webp" width="280" alt="Toast preview"/></td>
<td valign="top">

Fixed-corner notification stack. 9 placement combinations (start/center/end × top/middle/bottom).

```gleam
import daisyui/alert
import daisyui/toast

toast.new()
|> toast.end
|> toast.bottom
|> toast.children([
  alert.new()
  |> alert.success
  |> alert.children([html.text("Saved successfully!")])
  |> alert.build,
])
|> toast.build
```

🌐 [DaisyUI docs](https://daisyui.com/components/toast/) · 💻 [Example](examples/example_toast)

</td>
</tr></table>

</details>

---

<details>
<summary><strong>📝 Data Input</strong> &nbsp;—&nbsp; Calendar · Fieldset · File Input · Filter · Label · Radio · Range · Rating · Select · Text Input · Textarea · Toggle</summary>

---

#### 📅 Calendar &nbsp;·&nbsp; [`daisyui/calendar`](https://hexdocs.pm/daisyui_gleam/daisyui/calendar.html)

<table><tr>
<td width="280"><img src="https://img.daisyui.com/images/components/calendar.webp" width="280" alt="Calendar preview"/></td>
<td valign="top">

Helpers for the [Cally](https://wicky.nillia.ms/cally/) web component and [Pikaday](https://pikaday.com/). Also exposes class constants for React Day Picker integration.

```gleam
import daisyui/calendar

// Cally web component
calendar.cally([
  attribute.attribute("locale", "en-US"),
])

// Class constants for custom pickers
calendar.day_selected_class   // "btn-primary"
calendar.day_today_class      // "btn-ghost"
```

🌐 [DaisyUI docs](https://daisyui.com/components/calendar/) · 💻 [Example](examples/example_calendar)

</td>
</tr></table>

---

#### 🗂️ Fieldset &nbsp;·&nbsp; [`daisyui/fieldset`](https://hexdocs.pm/daisyui_gleam/daisyui/fieldset.html)

<table><tr>
<td width="280"><img src="https://img.daisyui.com/images/components/fieldset.webp" width="280" alt="Fieldset preview"/></td>
<td valign="top">

Container for grouping related form elements with a legend and helper labels.

```gleam
import daisyui/fieldset
import daisyui/input

fieldset.new()
|> fieldset.legend("Account Details")
|> fieldset.items([
  fieldset.field([
    fieldset.label("Email"),
    input.new()
    |> input.attrs([attribute.type_("email"), attribute.placeholder("you@example.com")])
    |> input.build,
    fieldset.label_alt("Required"),
  ]),
])
|> fieldset.build
```

🌐 [DaisyUI docs](https://daisyui.com/components/fieldset/) · 💻 [Example](examples/example_fieldset)

</td>
</tr></table>

---

#### 📁 File Input &nbsp;·&nbsp; [`daisyui/file_input`](https://hexdocs.pm/daisyui_gleam/daisyui/file_input.html)

<table><tr>
<td width="280"><img src="https://img.daisyui.com/images/components/file-input.webp" width="280" alt="File Input preview"/></td>
<td valign="top">

Styled file upload input field with all colour and size variants.

```gleam
import daisyui/file_input

file_input.new()
|> file_input.primary
|> file_input.md
|> file_input.attrs([attribute.accept("image/*")])
|> file_input.build
```

🌐 [DaisyUI docs](https://daisyui.com/components/file-input/) · 💻 [Example](examples/example_file_input)

</td>
</tr></table>

---

#### 🔽 Filter &nbsp;·&nbsp; [`daisyui/filter`](https://hexdocs.pm/daisyui_gleam/daisyui/filter.html)

<table><tr>
<td width="280"><img src="https://img.daisyui.com/images/components/filter.webp" width="280" alt="Filter preview"/></td>
<td valign="top">

Group of radio buttons where selecting one hides the others and reveals a reset button. Pure CSS.

```gleam
import daisyui/filter

filter.new("category-filter")
|> filter.reset_label("All")
|> filter.items([
  filter.item("Shirts",     [attribute.value("shirts")]),
  filter.item("Trousers",   [attribute.value("trousers")]),
  filter.item("Hats",       [attribute.value("hats")]),
])
|> filter.build
```

🌐 [DaisyUI docs](https://daisyui.com/components/filter/) · 💻 [Example](examples/example_filter)

</td>
</tr></table>

---

#### 🏷️ Label &nbsp;·&nbsp; [`daisyui/label`](https://hexdocs.pm/daisyui_gleam/daisyui/label.html)

<table><tr>
<td width="280"><img src="https://img.daisyui.com/images/components/label.webp" width="280" alt="Label preview"/></td>
<td valign="top">

Provides a name or helper text for a form input. Can appear before or after the field.

```gleam
import daisyui/label
import daisyui/input

label.new()
|> label.label_text("Username")
|> label.child(
  input.new()
  |> input.attrs([attribute.placeholder("gleam_dev")])
  |> input.build
)
|> label.label_text_alt("Max 20 chars")
|> label.build
```

🌐 [DaisyUI docs](https://daisyui.com/components/label/) · 💻 [Example](examples/example_label)

</td>
</tr></table>

---

#### 🔘 Radio &nbsp;·&nbsp; [`daisyui/radio`](https://hexdocs.pm/daisyui_gleam/daisyui/radio.html)

<table><tr>
<td width="280"><img src="https://img.daisyui.com/images/components/radio.webp" width="280" alt="Radio preview"/></td>
<td valign="top">

Radio button input — select one option from a set. All colours and sizes available.

```gleam
import daisyui/radio

// Inside a form group
radio.new()
|> radio.primary
|> radio.attrs([
  attribute.name("plan"),
  attribute.value("free"),
])
|> radio.build

radio.new()
|> radio.primary
|> radio.checked
|> radio.attrs([
  attribute.name("plan"),
  attribute.value("pro"),
])
|> radio.build
```

🌐 [DaisyUI docs](https://daisyui.com/components/radio/) · 💻 [Example](examples/example_radio)

</td>
</tr></table>

---

#### 🎚️ Range Slider &nbsp;·&nbsp; [`daisyui/range`](https://hexdocs.pm/daisyui_gleam/daisyui/range.html)

<table><tr>
<td width="280"><img src="https://img.daisyui.com/images/components/range.webp" width="280" alt="Range preview"/></td>
<td valign="top">

Slider input for selecting a numeric value within a min/max. Optional tick marks via step.

```gleam
import daisyui/range

range.new()
|> range.primary
|> range.min(0)
|> range.max(100)
|> range.value(40)
|> range.step(10)
|> range.build
```

🌐 [DaisyUI docs](https://daisyui.com/components/range/) · 💻 [Example](examples/example_range)

</td>
</tr></table>

---

#### ⭐ Rating &nbsp;·&nbsp; [`daisyui/rating`](https://hexdocs.pm/daisyui_gleam/daisyui/rating.html)

<table><tr>
<td width="280"><img src="https://img.daisyui.com/images/components/rating.webp" width="280" alt="Rating preview"/></td>
<td valign="top">

Star (or custom shape) rating input built from radio buttons. Supports half-stars and allow-clear.

```gleam
import daisyui/rating

rating.new()
|> rating.lg
|> rating.stars("my-rating", 5, 3, "mask-star-2", "bg-orange-400")
|> rating.build

// With half-stars
rating.new()
|> rating.half_stars("my-rating", 5, 4, "mask-star-2", "bg-yellow-400")
|> rating.build
```

🌐 [DaisyUI docs](https://daisyui.com/components/rating/) · 💻 [Example](examples/example_rating)

</td>
</tr></table>

---

#### 🔽 Select &nbsp;·&nbsp; [`daisyui/select`](https://hexdocs.pm/daisyui_gleam/daisyui/select.html)

<table><tr>
<td width="280"><img src="https://img.daisyui.com/images/components/select.webp" width="280" alt="Select preview"/></td>
<td valign="top">

Dropdown `<select>` for picking a value from a list of options. All colours and sizes.

```gleam
import daisyui/select
import lustre/element/html

select.new()
|> select.primary
|> select.md
|> select.attrs([attribute.name("country")])
|> select.options([
  html.option([attribute.value("")],  [html.text("Choose a country")]),
  html.option([attribute.value("ie")],[html.text("Ireland")]),
  html.option([attribute.value("us")],[html.text("United States")]),
])
|> select.build
```

🌐 [DaisyUI docs](https://daisyui.com/components/select/) · 💻 [Example](examples/example_field_input)

</td>
</tr></table>

---

#### 📝 Text Input &nbsp;·&nbsp; [`daisyui/input`](https://hexdocs.pm/daisyui_gleam/daisyui/input.html)

<table><tr>
<td width="280"><img src="https://img.daisyui.com/images/components/input.webp" width="280" alt="Input preview"/></td>
<td valign="top">

Single-line text field with colour, size, ghost, and bordered variants. Supports a prefix/suffix slot.

```gleam
import daisyui/input

input.new()
|> input.primary
|> input.md
|> input.attrs([
  attribute.type_("email"),
  attribute.placeholder("you@example.com"),
  attribute.name("email"),
])
|> input.build

// With ghost style
input.new()
|> input.ghost
|> input.attrs([attribute.placeholder("Search…")])
|> input.build
```

🌐 [DaisyUI docs](https://daisyui.com/components/input/) · 💻 [Example](examples/example_input)

</td>
</tr></table>

---

#### 📄 Textarea &nbsp;·&nbsp; [`daisyui/textarea`](https://hexdocs.pm/daisyui_gleam/daisyui/textarea.html)

<table><tr>
<td width="280"><img src="https://img.daisyui.com/images/components/textarea.webp" width="280" alt="Textarea preview"/></td>
<td valign="top">

Multi-line text input with colour, size, and ghost variants.

```gleam
import daisyui/textarea

textarea.new()
|> textarea.primary
|> textarea.attrs([
  attribute.placeholder("Tell us about yourself…"),
  attribute.rows(4),
  attribute.name("bio"),
])
|> textarea.build
```

🌐 [DaisyUI docs](https://daisyui.com/components/textarea/) · 💻 [Example](examples/example_textarea)

</td>
</tr></table>

---

#### 🔛 Toggle &nbsp;·&nbsp; [`daisyui/toggle`](https://hexdocs.pm/daisyui_gleam/daisyui/toggle.html)

<table><tr>
<td width="280"><img src="https://img.daisyui.com/images/components/toggle.webp" width="280" alt="Toggle preview"/></td>
<td valign="top">

Checkbox styled as a switch/toggle button. All colours and sizes.

```gleam
import daisyui/toggle

toggle.new()
|> toggle.primary
|> toggle.md
|> toggle.checked
|> toggle.attrs([attribute.name("notifications")])
|> toggle.build
```

🌐 [DaisyUI docs](https://daisyui.com/components/toggle/) · 💻 [Example](examples/example_toggle)

</td>
</tr></table>

</details>

---

<details>
<summary><strong>📐 Layout</strong> &nbsp;—&nbsp; Divider · Drawer · Footer · Hero · Indicator · Join · Mask · Stack</summary>

---

#### ➖ Divider &nbsp;·&nbsp; [`daisyui/divider`](https://hexdocs.pm/daisyui_gleam/daisyui/divider.html)

<table><tr>
<td width="280"><img src="https://img.daisyui.com/images/components/divider.webp" width="280" alt="Divider preview"/></td>
<td valign="top">

Horizontal or vertical separator line, optionally with a centred label.

```gleam
import daisyui/divider

// Simple horizontal rule
divider.new() |> divider.build

// With label and colour
divider.new()
|> divider.primary
|> divider.text("OR")
|> divider.build

// Vertical divider
divider.new()
|> divider.vertical
|> divider.build
```

🌐 [DaisyUI docs](https://daisyui.com/components/divider/) · 💻 [Example](examples/example_divider)

</td>
</tr></table>

---

#### 🗄️ Drawer &nbsp;·&nbsp; [`daisyui/drawer`](https://hexdocs.pm/daisyui_gleam/daisyui/drawer.html)

<table><tr>
<td width="280"><img src="https://img.daisyui.com/images/components/drawer.webp" width="280" alt="Drawer preview"/></td>
<td valign="top">

Grid layout that slides a sidebar in from the left or right on checkbox toggle. Can be always-open on wider screens.

```gleam
import daisyui/drawer

drawer.new("main-drawer")
|> drawer.content([main_page_content])
|> drawer.sidebar([sidebar_menu])
|> drawer.responsive_open("lg")  // always visible on lg+
|> drawer.build
```

🌐 [DaisyUI docs](https://daisyui.com/components/drawer/) · 💻 [Example](examples/example_drawer)

</td>
</tr></table>

---

#### 🦶 Footer &nbsp;·&nbsp; [`daisyui/footer`](https://hexdocs.pm/daisyui_gleam/daisyui/footer.html)

<table><tr>
<td width="280"><img src="https://img.daisyui.com/images/components/footer.webp" width="280" alt="Footer preview"/></td>
<td valign="top">

Page footer with logo, copyright notice, and columnar navigation links.

```gleam
import daisyui/footer

footer.new()
|> footer.center
|> footer.items([
  footer.logo_col([logo_el, copyright_el]),
  footer.nav_col("Product", [
    footer.nav_link("/features", "Features"),
    footer.nav_link("/pricing", "Pricing"),
  ]),
  footer.nav_col("Company", [
    footer.nav_link("/about", "About"),
    footer.nav_link("/blog", "Blog"),
  ]),
])
|> footer.build
```

🌐 [DaisyUI docs](https://daisyui.com/components/footer/) · 💻 [Example](examples/example_footer)

</td>
</tr></table>

---

#### 🦸 Hero &nbsp;·&nbsp; [`daisyui/hero`](https://hexdocs.pm/daisyui_gleam/daisyui/hero.html)

<table><tr>
<td width="280"><img src="https://img.daisyui.com/images/components/hero.webp" width="280" alt="Hero preview"/></td>
<td valign="top">

Full-width section with an optional background image and a centred content overlay.

```gleam
import daisyui/hero
import lustre/element/html

hero.new()
|> hero.bg_image("/img/hero-bg.jpg")
|> hero.overlay
|> hero.content([
  html.div([attribute.class("text-center text-neutral-content")], [
    html.h1([attribute.class("text-5xl font-bold")], [html.text("Hello there")]),
    html.p([attribute.class("py-6")], [html.text("The hero section tagline.")]),
    get_started_button,
  ]),
])
|> hero.build
```

🌐 [DaisyUI docs](https://daisyui.com/components/hero/) · 💻 [Example](examples/example_hero)

</td>
</tr></table>

---

#### 📍 Indicator &nbsp;·&nbsp; [`daisyui/indicator`](https://hexdocs.pm/daisyui_gleam/daisyui/indicator.html)

<table><tr>
<td width="280"><img src="https://img.daisyui.com/images/components/indicator.webp" width="280" alt="Indicator preview"/></td>
<td valign="top">

Positions a badge, dot, or any element on the corner of another element.

```gleam
import daisyui/badge
import daisyui/button
import daisyui/indicator

indicator.new()
|> indicator.children([
  indicator.item_new([
    badge.new() |> badge.secondary |> badge.text("3") |> badge.build
  ])
  |> indicator.item_end
  |> indicator.item_top
  |> indicator.item_build,

  button.new() |> button.text("Inbox") |> button.build,
])
|> indicator.build
```

🌐 [DaisyUI docs](https://daisyui.com/components/indicator/) · 💻 [Example](examples/example_indicator)

</td>
</tr></table>

---

#### 🔗 Join &nbsp;·&nbsp; [`daisyui/join`](https://hexdocs.pm/daisyui_gleam/daisyui/join.html)

<table><tr>
<td width="280"><img src="https://img.daisyui.com/images/components/join.webp" width="280" alt="Join preview"/></td>
<td valign="top">

Groups buttons, inputs, or other items into a visually connected horizontal or vertical row.

```gleam
import daisyui/join
import daisyui/button
import daisyui/input

join.new()
|> join.horizontal
|> join.children([
  input.new()
  |> input.attrs([attribute.placeholder("Search…")])
  |> input.build,

  button.new()
  |> button.primary
  |> button.text("Go")
  |> button.build,
])
|> join.build
```

🌐 [DaisyUI docs](https://daisyui.com/components/join/) · 💻 [Example](examples/example_join)

</td>
</tr></table>

---

#### 🎭 Mask &nbsp;·&nbsp; [`daisyui/mask`](https://hexdocs.pm/daisyui_gleam/daisyui/mask.html)

<table><tr>
<td width="280"><img src="https://img.daisyui.com/images/components/mask.webp" width="280" alt="Mask preview"/></td>
<td valign="top">

Crops element content to a common shape — circle, heart, hexagon, star, squircle, and more.

```gleam
import daisyui/mask
import lustre/element/html

// Heart-shaped image
mask.heart([
  html.img([attribute.src("/img/photo.jpg")], [])
])

// Hexagonal avatar
mask.hexagon([
  html.img([attribute.src("/img/avatar.jpg")], [])
])
```

🌐 [DaisyUI docs](https://daisyui.com/components/mask/) · 💻 [Example](examples/example_mask)

</td>
</tr></table>

---

#### 📚 Stack &nbsp;·&nbsp; [`daisyui/stack`](https://hexdocs.pm/daisyui_gleam/daisyui/stack.html)

<table><tr>
<td width="280"><img src="https://img.daisyui.com/images/components/stack.webp" width="280" alt="Stack preview"/></td>
<td valign="top">

Visually layers child elements on top of each other. Great for card fans and image overlays.

```gleam
import daisyui/stack

stack.new()
|> stack.children([card1, card2, card3])
|> stack.build
```

🌐 [DaisyUI docs](https://daisyui.com/components/stack/) · 💻 [Example](examples/example_stack)

</td>
</tr></table>

</details>

---

<details>
<summary><strong>🖥️ Mockup</strong> &nbsp;—&nbsp; Code · Phone · Window &nbsp;·&nbsp; ⏳ Browser (coming soon)</summary>

---

#### 💻 Code Mockup &nbsp;·&nbsp; [`daisyui/mockup_code`](https://hexdocs.pm/daisyui_gleam/daisyui/mockup_code.html)

<table><tr>
<td width="280"><img src="https://img.daisyui.com/images/components/mockup-code.webp" width="280" alt="Code Mockup preview"/></td>
<td valign="top">

Styled code block that resembles a terminal or code editor. Supports line prefixes and custom colours.

```gleam
import daisyui/mockup_code

mockup_code.new()
|> mockup_code.lines([
  mockup_code.line("gleam add daisyui_gleam") |> mockup_code.prefix("$"),
  mockup_code.line("Resolving versions") |> mockup_code.prefix(">"),
  mockup_code.line("Done!") |> mockup_code.prefix(">"),
])
|> mockup_code.build
```

🌐 [DaisyUI docs](https://daisyui.com/components/mockup-code/) · 💻 [Example](examples/example_mockup_code)

</td>
</tr></table>

---

#### 📱 Phone Mockup &nbsp;·&nbsp; [`daisyui/mockup_phone`](https://hexdocs.pm/daisyui_gleam/daisyui/mockup_phone.html)

<table><tr>
<td width="280"><img src="https://img.daisyui.com/images/components/mockup-phone.webp" width="280" alt="Phone Mockup preview"/></td>
<td valign="top">

iPhone-style device frame for showcasing a mobile UI inside a presentation or landing page.

```gleam
import daisyui/mockup_phone

mockup_phone.new()
|> mockup_phone.display_children([
  html.div(
    [attribute.class("bg-base-100 w-full h-full flex items-center justify-center")],
    [html.text("Your mobile UI here")],
  )
])
|> mockup_phone.build
```

🌐 [DaisyUI docs](https://daisyui.com/components/mockup-phone/) · 💻 [Example](examples/example_mockup_phone)

</td>
</tr></table>

---

#### 🪟 Window Mockup &nbsp;·&nbsp; [`daisyui/mockup_window`](https://hexdocs.pm/daisyui_gleam/daisyui/mockup_window.html)

<table><tr>
<td width="280"><img src="https://img.daisyui.com/images/components/mockup-window.webp" width="280" alt="Window Mockup preview"/></td>
<td valign="top">

OS-style window frame with traffic-light controls. Optional border variant.

```gleam
import daisyui/mockup_window

mockup_window.new()
|> mockup_window.bordered
|> mockup_window.bg("bg-base-200")
|> mockup_window.content_children([
  html.div(
    [attribute.class("p-8 text-center")],
    [html.text("Window content here")],
  )
])
|> mockup_window.build
```

🌐 [DaisyUI docs](https://daisyui.com/components/mockup-window/) · 💻 [Example](examples/example_mockup_window)

</td>
</tr></table>

</details>

---

## 🛠️ Development

```sh
# Run the test suite (no browser needed)
gleam test

# Build docs locally
gleam docs build

# Run any example with live reload
cd examples/example_button
gleam run -m lustre/dev start
```

Each example project is pre-configured with Lustre, lustre_dev_tools, and DaisyUI. A theme-switcher in the header lets you preview all built-in DaisyUI themes.

---

## 🤝 Contributing

Issues and pull requests are welcome at
[github.com/p424p424/daisyui_gleam](https://github.com/p424p424/daisyui_gleam).

When adding a new component, please follow the conventions in existing modules:

- ✅ Opaque builder type with `new/0` → setters → `build/1`
- ✅ All public functions documented with `///` doc comments
- ✅ Section dividers matching the `// --------…` style in existing files
- ✅ Reuse types from `tokens.gleam` wherever possible
- ✅ Add a scaffolded example under `examples/example_<name>/`

---

## 🔗 Links

| Resource | Link |
|----------|------|
| 📦 Hex package | [hex.pm/packages/daisyui_gleam](https://hex.pm/packages/daisyui_gleam) |
| 📖 Hex docs | [hexdocs.pm/daisyui_gleam](https://hexdocs.pm/daisyui_gleam/) |
| 🎨 DaisyUI docs | [daisyui.com/docs](https://daisyui.com/docs/install/) |
| 🧩 DaisyUI components | [daisyui.com/components](https://daisyui.com/components/) |
| 🌈 DaisyUI colours | [daisyui.com/docs/colors](https://daisyui.com/docs/colors/) |
| 💨 Tailwind CSS | [tailwindcss.com/docs](https://tailwindcss.com/docs) |
| ✨ Lustre framework | [hexdocs.pm/lustre](https://hexdocs.pm/lustre/) |
