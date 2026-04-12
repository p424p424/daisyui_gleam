# daisyui_gleam

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

## What is this?

[DaisyUI](https://daisyui.com) is a component library built on top of
[Tailwind CSS](https://tailwindcss.com). It gives you semantic class names like
`btn-primary` and `card-body` that automatically adapt to themes.

[Lustre](https://hexdocs.pm/lustre/) is a Gleam web framework that models your
UI as a tree of `Element(msg)` values — think Elm architecture but in Gleam.

**daisyui_gleam** bridges the two. Every component is an opaque builder:

```gleam
// Instead of remembering "was it btn-outline or outline-btn?"...
html.button([attribute.class("btn btn-outline btn-primary btn-lg")], [html.text("Click")])

// ...you get autocomplete and a compiler that catches typos:
button.new()
|> button.outline
|> button.primary
|> button.lg
|> button.text("Click")
|> button.build
```

The library does **not** ship any CSS — it generates the right DaisyUI class
strings for you. You bring DaisyUI and Tailwind via npm (one-time setup,
shown below).

---

## Installation

### 1. Add the Gleam package

```sh
gleam add daisyui_gleam
```

Your project must target JavaScript (`target = "javascript"` in `gleam.toml`)
since Lustre renders in the browser.

### 2. Install DaisyUI and Tailwind via npm

DaisyUI v5 includes Tailwind v4 as a peer dependency — you only need one
`npm install`:

```sh
npm install --save-dev daisyui
```

### 3. Wire up your CSS

Create a CSS entry point (e.g. `src/app.css`):

```css
@import "tailwindcss";
@plugin "daisyui";
```

Then reference it from your HTML. If you are using
[`lustre_dev_tools`](https://hexdocs.pm/lustre_dev_tools/) the dev server will
pick it up automatically.

> **Further reading**
> - [DaisyUI installation guide](https://daisyui.com/docs/install/)
> - [Tailwind v4 docs](https://tailwindcss.com/docs/installation)
> - [Lustre getting started](https://hexdocs.pm/lustre/)

---

## Quick start

Here is a minimal Lustre app that renders a card with a button:

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
          |> button.attrs([event.on_click(UserClickedBuy)])
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

## Components

All components live under the `daisyui/` namespace.

| Module | DaisyUI component | Notes |
|--------|-------------------|-------|
| [`accordion`](https://hexdocs.pm/daisyui_gleam/daisyui/accordion.html) | [Collapse / Accordion](https://daisyui.com/components/collapse/) | Checkbox, radio, or `<details>` variants |
| [`alert`](https://hexdocs.pm/daisyui_gleam/daisyui/alert.html) | [Alert](https://daisyui.com/components/alert/) | info / success / warning / error |
| [`avatar`](https://hexdocs.pm/daisyui_gleam/daisyui/avatar.html) | [Avatar](https://daisyui.com/components/avatar/) | Online/offline status, placeholder initials, group stacks |
| [`badge`](https://hexdocs.pm/daisyui_gleam/daisyui/badge.html) | [Badge](https://daisyui.com/components/badge/) | Full colour + variant + size support |
| [`breadcrumbs`](https://hexdocs.pm/daisyui_gleam/daisyui/breadcrumbs.html) | [Breadcrumbs](https://daisyui.com/components/breadcrumbs/) | `link/2` and `item/1` helpers |
| [`button`](https://hexdocs.pm/daisyui_gleam/daisyui/button.html) | [Button](https://daisyui.com/components/button/) | All colours, styles, sizes, and layout modifiers |
| [`calendar`](https://hexdocs.pm/daisyui_gleam/daisyui/calendar.html) | [Calendar](https://daisyui.com/components/calendar/) | Cally web component + Pikaday helpers; class constants for React Day Picker |
| [`card`](https://hexdocs.pm/daisyui_gleam/daisyui/card.html) | [Card](https://daisyui.com/components/card/) | Figure, title, body, actions slots |
| [`carousel`](https://hexdocs.pm/daisyui_gleam/daisyui/carousel.html) | [Carousel](https://daisyui.com/components/carousel/) | Snap position and scroll direction |
| [`text`](https://hexdocs.pm/daisyui_gleam/daisyui/text.html) | *(Tailwind typography)* | `<span>` / `<p>` / `<h1>`–`<h6>` with size, weight, and colour |

A shared [`tokens`](https://hexdocs.pm/daisyui_gleam/daisyui/tokens.html) module
defines the `Color`, `Size`, `TextSize`, `Weight`, and `Variant` types used
across all components — you rarely need to import it directly.

---

## How the builder pattern works

Every component follows the same three-step rhythm:

```
new()           ← create a blank builder
|> modifier()   ← chain as many setters as you need
|> build        ← produce a Lustre Element(msg)
```

Builders are **opaque** — you can't pattern-match on them, you can only use the
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

You can always attach arbitrary Lustre attributes via `attrs/2`:

```gleam
button.new()
|> button.primary
|> button.attrs([
  attribute.id("submit-btn"),
  event.on_click(UserSubmitted),
])
|> button.text("Submit")
|> button.build
```

---

## The colour system

DaisyUI's semantic colour tokens are the same across every component:

| Function | Tailwind/DaisyUI class | CSS variable |
|----------|------------------------|--------------|
| `primary` | `*-primary` | `--color-primary` |
| `secondary` | `*-secondary` | `--color-secondary` |
| `accent` | `*-accent` | `--color-accent` |
| `neutral` | `*-neutral` | `--color-neutral` |
| `info` | `*-info` | `--color-info` |
| `success` | `*-success` | `--color-success` |
| `warning` | `*-warning` | `--color-warning` |
| `error` | `*-error` | `--color-error` |

Switching DaisyUI themes updates every colour automatically — your Gleam code
stays the same.

> **Reference:** [DaisyUI colour tokens](https://daisyui.com/docs/colors/) ·
> [Tailwind text colour](https://tailwindcss.com/docs/text-color)

---

## Examples

The `examples/` directory contains a scaffolded Lustre project for each
component. Each project is already wired up with Lustre, lustre_dev_tools, and
DaisyUI — just add your view code and run the dev server.

**`example_01`** is the only example with application code today. It
demonstrates `accordion` and `text` side by side:

```sh
cd examples/example_01
gleam run -m lustre/dev start
```

The remaining example projects (`example_accordion`, `example_alert`, …) will
have component showcases added in upcoming releases.

---

## Development

```sh
# Run the test suite (Gleam stdlib-only, no browser needed)
gleam test

# Check docs locally
gleam docs build
```

To hack on an example:

```sh
cd examples/example_01
gleam run -m lustre/dev start
```

---

## Contributing

Issues and pull requests are welcome at
[github.com/p424p424/daisyui_gleam](https://github.com/p424p424/daisyui_gleam).

If you are adding a new component, please follow the conventions established
by the existing modules:

- Opaque builder type with `new/0` → setters → `build/1`
- All public functions documented with `///` doc comments
- Section dividers matching the `// --------…` style in existing files
- Reuse types from `tokens.gleam` wherever possible

---

## Links

- [DaisyUI docs](https://daisyui.com/docs/install/)
- [DaisyUI components](https://daisyui.com/components/)
- [DaisyUI colour tokens](https://daisyui.com/docs/colors/)
- [Tailwind CSS docs](https://tailwindcss.com/docs)
- [Lustre docs](https://hexdocs.pm/lustre/)
- [Hex package](https://hex.pm/packages/daisyui_gleam)
- [Hex docs](https://hexdocs.pm/daisyui_gleam/)
