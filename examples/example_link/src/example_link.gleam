import daisyui/link
import daisyui/select
import lustre
import lustre/attribute
import lustre/element.{type Element}
import lustre/element/html
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

fn update(_model: Model, msg: Msg) -> Model {
  case msg {
    UserChangedTheme(t) -> Model(theme: t)
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
      html.h1([attribute.class("text-lg font-semibold")], [html.text("Link")]),
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
    [attribute.class("pt-20 pb-10 flex flex-col items-center min-h-screen gap-8")],
    [
      // Basic
      section("Basic", [link.new("Click me") |> link.build]),
      // In prose
      section("In paragraph text", [
        html.p([], [
          html.text("Tailwind CSS resets the style of links by default. "),
          html.br([]),
          html.text("Add \"link\" class to make it look like a "),
          link.new("normal link") |> link.build,
          html.text(" again."),
        ]),
      ]),
      // Hover only
      section("Underline on hover only", [
        link.new("Click me") |> link.hover |> link.build,
      ]),
      // Colors
      section("Colors", [
        html.div([attribute.class("flex flex-wrap gap-4")], [
          link.new("neutral") |> link.neutral |> link.build,
          link.new("primary") |> link.primary |> link.build,
          link.new("secondary") |> link.secondary |> link.build,
          link.new("accent") |> link.accent |> link.build,
          link.new("success") |> link.success |> link.build,
          link.new("info") |> link.info |> link.build,
          link.new("warning") |> link.warning |> link.build,
          link.new("error") |> link.error |> link.build,
        ]),
      ]),
      // With href
      section("With href", [
        link.new("DaisyUI documentation")
          |> link.primary
          |> link.attrs([
            attribute.href("https://daisyui.com"),
            attribute.attribute("target", "_blank"),
            attribute.attribute("rel", "noopener noreferrer"),
          ])
          |> link.build,
      ]),
    ],
  )
}

fn section(label: String, children: List(Element(Msg))) -> Element(Msg) {
  html.div([attribute.class("w-full max-w-xl space-y-3 px-4")], [
    html.p(
      [
        attribute.class(
          "text-sm font-semibold opacity-60 uppercase tracking-wide",
        ),
      ],
      [html.text(label)],
    ),
    ..children
  ])
}
