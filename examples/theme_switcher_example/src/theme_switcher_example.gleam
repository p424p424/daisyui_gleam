/// Theme Switcher Example
///
/// Demonstrates three ways to switch DaisyUI themes in a Lustre app:
///
///   1. Model-driven  — theme name lives in the Lustre model; `update` changes
///      it and `view` sets `data-theme` on the root element. Full Gleam control.
///
///   2. CSS-only toggle — a `theme_controller` checkbox swaps between two themes
///      with zero JavaScript and no model changes.
///
///   3. CSS-only dropdown — radio inputs inside a dropdown let the user pick from
///      a list of themes, again with no model or JS involvement.
///
/// All three approaches can coexist; pick whichever fits your use-case.

import daisyui/badge
import daisyui/button
import daisyui/card
import daisyui/select
import daisyui/theme_controller as tc
import gleam/list
import lustre
import lustre/attribute
import lustre/element.{type Element}
import lustre/element/html
import lustre/event

// ---------------------------------------------------------------------------
// Theme list
// ---------------------------------------------------------------------------

const all_themes = [
  "light", "dark", "cupcake", "bumblebee", "emerald", "corporate", "synthwave",
  "retro", "cyberpunk", "valentine", "halloween", "garden", "forest", "aqua",
  "lofi", "pastel", "fantasy", "wireframe", "black", "luxury", "dracula",
  "cmyk", "autumn", "business", "acid", "lemonade", "night", "coffee",
  "winter", "dim", "nord", "sunset", "caramellatte", "abyss", "silk",
]

const dropdown_themes = [
  "light", "dark", "cupcake", "synthwave", "retro", "dracula", "nord",
]

// ---------------------------------------------------------------------------
// Model / update
// ---------------------------------------------------------------------------

pub type Model {
  Model(theme: String)
}

pub type Msg {
  UserPickedTheme(String)
}

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

// ---------------------------------------------------------------------------
// View
// ---------------------------------------------------------------------------

fn view(model: Model) -> Element(Msg) {
  // Setting data-theme on the root element applies the theme to the whole page.
  html.div(
    [
      attribute.attribute("data-theme", model.theme),
      attribute.class("min-h-screen bg-base-200 transition-colors duration-300"),
    ],
    [
      page_header(model.theme),
      html.main(
        [attribute.class("max-w-3xl mx-auto px-4 py-10 space-y-10")],
        [
          approach_1(model.theme),
          approach_2(),
          approach_3(),
          preview_section(model.theme),
        ],
      ),
    ],
  )
}

fn page_header(current_theme: String) -> Element(Msg) {
  html.header(
    [
      attribute.class(
        "sticky top-0 z-50 bg-base-100 shadow px-6 h-16 flex items-center gap-4",
      ),
    ],
    [
      html.h1([attribute.class("text-lg font-semibold flex-1")], [
        html.text("🎨 Theme Switcher"),
      ]),
      badge.new()
        |> badge.primary
        |> badge.text(current_theme)
        |> badge.build,
    ],
  )
}

// ---------------------------------------------------------------------------
// Approach 1 — Model-driven (Lustre update cycle)
// ---------------------------------------------------------------------------

fn approach_1(current_theme: String) -> Element(Msg) {
  html.section([attribute.class("space-y-4")], [
    section_heading(
      "Approach 1 — Model-driven",
      "The theme name lives in the Lustre model. The select fires a Msg on change,
       update/2 stores the new name, and view/1 re-renders the root element with
       the updated data-theme attribute. Use this when you need to react to the
       theme in code (e.g. swap an image, adjust a chart palette).",
    ),
    select.new()
      |> select.primary
      |> select.attrs([
        attribute.value(current_theme),
        event.on_input(UserPickedTheme),
      ])
      |> select.children(
        list.map(all_themes, fn(t) {
          html.option([attribute.value(t)], t)
        }),
      )
      |> select.build,
  ])
}

// ---------------------------------------------------------------------------
// Approach 2 — CSS-only toggle (theme_controller checkbox)
// ---------------------------------------------------------------------------

fn approach_2() -> Element(Msg) {
  html.section([attribute.class("space-y-4")], [
    section_heading(
      "Approach 2 — CSS-only toggle",
      "A theme_controller checkbox swaps between two themes using only CSS —
       no Msg, no update, no JavaScript. Perfect for a simple light/dark toggle.",
    ),
    html.label(
      [attribute.class("flex items-center gap-3 cursor-pointer w-fit")],
      [
        html.span([attribute.class("label-text font-medium")], [
          html.text("Light"),
        ]),
        tc.toggle("dark", []),
        html.span([attribute.class("label-text font-medium")], [
          html.text("Dark"),
        ]),
      ],
    ),
  ])
}

// ---------------------------------------------------------------------------
// Approach 3 — CSS-only dropdown (theme_controller radio)
// ---------------------------------------------------------------------------

fn approach_3() -> Element(Msg) {
  html.section([attribute.class("space-y-4")], [
    section_heading(
      "Approach 3 — CSS-only dropdown",
      "Radio inputs with class theme-controller let the user pick from a list of
       themes. DaisyUI's CSS activates the chosen theme automatically — still no
       JavaScript required. Note: this approach works independently of the model,
       so the badge in the header won't update when using this picker.",
    ),
    html.div([attribute.class("dropdown")], [
      html.div(
        [
          attribute.attribute("tabindex", "0"),
          attribute.role("button"),
          attribute.class("btn btn-outline m-1"),
        ],
        [html.text("Choose theme ▾")],
      ),
      html.ul(
        [
          attribute.attribute("tabindex", "-1"),
          attribute.class(
            "dropdown-content bg-base-300 rounded-box z-10 w-48 p-2 shadow-2xl space-y-1",
          ),
        ],
        list.map(dropdown_themes, fn(t) {
          html.li([], [tc.radio_dropdown("css-dropdown", t, t, [])])
        }),
      ),
    ]),
  ])
}

// ---------------------------------------------------------------------------
// Preview — shows a few components so the active theme is visible
// ---------------------------------------------------------------------------

fn preview_section(theme: String) -> Element(Msg) {
  html.section([attribute.class("space-y-4")], [
    section_heading(
      "Live preview",
      "These components automatically reflect the active theme — no extra code needed.",
    ),
    html.div([attribute.class("flex flex-wrap gap-3")], [
      button.new() |> button.primary   |> button.text("Primary")   |> button.build,
      button.new() |> button.secondary |> button.text("Secondary") |> button.build,
      button.new() |> button.accent    |> button.text("Accent")    |> button.build,
      button.new() |> button.ghost     |> button.text("Ghost")     |> button.build,
    ]),
    html.div([attribute.class("flex flex-wrap gap-2")], [
      badge.new() |> badge.primary   |> badge.text("primary")   |> badge.build,
      badge.new() |> badge.secondary |> badge.text("secondary") |> badge.build,
      badge.new() |> badge.accent    |> badge.text("accent")    |> badge.build,
      badge.new() |> badge.info      |> badge.text("info")      |> badge.build,
      badge.new() |> badge.success   |> badge.text("success")   |> badge.build,
      badge.new() |> badge.warning   |> badge.text("warning")   |> badge.build,
      badge.new() |> badge.error     |> badge.text("error")     |> badge.build,
    ]),
    card.new()
      |> card.border
      |> card.attrs([attribute.class("bg-base-100 shadow-sm")])
      |> card.title([html.text("Card in the \"" <> theme <> "\" theme")])
      |> card.body([
        html.p([], [
          html.text(
            "Every daisyui_gleam component automatically adapts to the active
             theme — no code changes needed.",
          ),
        ]),
      ])
      |> card.build,
  ])
}

// ---------------------------------------------------------------------------
// Helper
// ---------------------------------------------------------------------------

fn section_heading(title: String, description: String) -> Element(Msg) {
  html.div([], [
    html.h2([attribute.class("text-xl font-semibold")], [html.text(title)]),
    html.p([attribute.class("text-sm opacity-60 mt-1")], [
      html.text(description),
    ]),
  ])
}
