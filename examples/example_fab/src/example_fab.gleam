import daisyui/fab
import daisyui/select
import lustre
import lustre/attribute
import lustre/element.{type Element}
import lustre/element/html
import lustre/element/svg
import lustre/event

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

fn view(model: Model) -> Element(Msg) {
  html.div(
    [
      attribute.attribute("data-theme", model.theme),
      attribute.class("min-h-screen bg-base-200"),
    ],
    [page_header(model.theme), main_content()],
  )
}

fn page_header(current_theme: String) -> Element(Msg) {
  html.header(
    [
      attribute.class(
        "fixed top-0 left-0 right-0 z-50 flex items-center justify-between px-6 h-16 bg-base-100 shadow",
      ),
    ],
    [
      html.h1([attribute.class("text-lg font-semibold")], [
        html.text("FAB / Speed Dial"),
      ]),
      theme_select(current_theme),
    ],
  )
}

fn theme_select(current: String) -> Element(Msg) {
  select.new()
  |> select.sm
  |> select.attrs([attribute.value(current), event.on_input(UserChangedTheme)])
  |> select.children([
    html.option([attribute.value("light")], "Light"),
    html.option([attribute.value("dark")], "Dark"),
    html.option([attribute.value("cupcake")], "Cupcake"),
    html.option([attribute.value("corporate")], "Corporate"),
    html.option([attribute.value("synthwave")], "Synthwave"),
    html.option([attribute.value("retro")], "Retro"),
    html.option([attribute.value("cyberpunk")], "Cyberpunk"),
    html.option([attribute.value("valentine")], "Valentine"),
    html.option([attribute.value("aqua")], "Aqua"),
    html.option([attribute.value("dracula")], "Dracula"),
  ])
  |> select.build
}

fn main_content() -> Element(Msg) {
  html.main(
    [attribute.class("pt-20 pb-10 flex justify-center min-h-screen")],
    [
      html.div([attribute.class("w-full max-w-3xl space-y-10 p-4")], [
        // FAB in page corner — the real use case
        section("FAB in page corner (click F in the bottom-right)", [
          html.p([attribute.class("text-sm opacity-60")], [
            html.text(
              "The FAB below is position:fixed — it stays in the bottom-right corner of this page.",
            ),
          ]),
          fab.new()
            |> fab.trigger([
              fab_trigger("F", "btn-primary"),
            ])
            |> fab.close([
              html.span(
                [attribute.class("btn btn-circle btn-lg btn-error")],
                [html.text("✕")],
              ),
            ])
            |> fab.items([
              labeled_item("Save", "A"),
              labeled_item("Share", "B"),
              labeled_item("Edit", "C"),
            ])
            |> fab.build,
        ]),
        // Vertical — basic
        section("Vertical speed dial (inline demo)", [
          demo_box([
            fab.new()
              |> fab.attrs([attribute.class("!static")])
              |> fab.trigger([fab_trigger("F", "btn-success")])
              |> fab.items([
                html.button(
                  [attribute.class("btn btn-lg btn-circle")],
                  [html.text("A")],
                ),
                html.button(
                  [attribute.class("btn btn-lg btn-circle")],
                  [html.text("B")],
                ),
                html.button(
                  [attribute.class("btn btn-lg btn-circle")],
                  [html.text("C")],
                ),
              ])
              |> fab.build,
          ]),
        ]),
        // Vertical — with main-action
        section("Vertical with main-action slot", [
          demo_box([
            fab.new()
              |> fab.attrs([attribute.class("!static")])
              |> fab.trigger([fab_trigger("F", "btn-info")])
              |> fab.main_action([
                html.text("Main "),
                html.button(
                  [attribute.class("btn btn-circle btn-secondary btn-lg")],
                  [html.text("M")],
                ),
              ])
              |> fab.items([
                labeled_item("Alpha", "A"),
                labeled_item("Beta", "B"),
                labeled_item("Gamma", "C"),
              ])
              |> fab.build,
          ]),
        ]),
        // Flower — basic
        section("Flower speed dial", [
          demo_box([
            fab.new()
              |> fab.flower
              |> fab.attrs([attribute.class("!static")])
              |> fab.trigger([fab_trigger("F", "btn-secondary")])
              |> fab.main_action([
                html.button(
                  [attribute.class("btn btn-circle btn-lg btn-primary")],
                  [icon_plus()],
                ),
              ])
              |> fab.items([
                html.button(
                  [attribute.class("btn btn-lg btn-circle")],
                  [html.text("A")],
                ),
                html.button(
                  [attribute.class("btn btn-lg btn-circle")],
                  [html.text("B")],
                ),
                html.button(
                  [attribute.class("btn btn-lg btn-circle")],
                  [html.text("C")],
                ),
                html.button(
                  [attribute.class("btn btn-lg btn-circle")],
                  [html.text("D")],
                ),
              ])
              |> fab.build,
          ]),
        ]),
        // Single FAB
        section("Single FAB (no speed dial)", [
          demo_box([
            fab.new()
              |> fab.attrs([attribute.class("!static")])
              |> fab.items([
                html.button(
                  [attribute.class("btn btn-lg btn-circle btn-primary")],
                  [icon_plus()],
                ),
              ])
              |> fab.build,
          ]),
        ]),
      ]),
    ],
  )
}

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

fn fab_trigger(label: String, color_class: String) -> Element(Msg) {
  html.div(
    [
      attribute.attribute("tabindex", "0"),
      attribute.attribute("role", "button"),
      attribute.class("btn btn-lg btn-circle " <> color_class),
    ],
    [html.text(label)],
  )
}

fn labeled_item(label: String, letter: String) -> Element(Msg) {
  html.div([attribute.class("flex items-center gap-2")], [
    html.span([attribute.class("text-sm font-medium")], [html.text(label)]),
    html.button(
      [attribute.class("btn btn-lg btn-circle")],
      [html.text(letter)],
    ),
  ])
}

fn demo_box(children: List(Element(Msg))) -> Element(Msg) {
  html.div(
    [attribute.class("relative bg-base-100 rounded-xl h-56 overflow-hidden border border-base-300")],
    children,
  )
}

fn section(label: String, children: List(Element(Msg))) -> Element(Msg) {
  html.div([attribute.class("space-y-3")], [
    html.p(
      [attribute.class("text-sm font-semibold opacity-60 uppercase tracking-wide")],
      [html.text(label)],
    ),
    ..children
  ])
}

fn icon_plus() -> Element(Msg) {
  svg.svg(
    [
      attribute.attribute("xmlns", "http://www.w3.org/2000/svg"),
      attribute.attribute("fill", "none"),
      attribute.attribute("viewBox", "0 0 24 24"),
      attribute.attribute("stroke-width", "2"),
      attribute.attribute("stroke", "currentColor"),
      attribute.class("size-6"),
    ],
    [
      svg.path(
        [
          attribute.attribute("stroke-linecap", "round"),
          attribute.attribute("stroke-linejoin", "round"),
          attribute.attribute("d", "M12 4.5v15m7.5-7.5h-15"),
        ],
        [],
      ),
    ],
  )
}
