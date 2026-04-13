import daisyui/badge
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
      html.h1([attribute.class("text-lg font-semibold")], [html.text("Badge")]),
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
    [attribute.class("pt-16 flex items-center justify-center min-h-screen")],
    [
      html.div([attribute.class("p-8 space-y-4")], [
        html.div([attribute.class("flex flex-wrap gap-2")], [
          badge.new() |> badge.primary |> badge.text("Primary") |> badge.build,
          badge.new()
            |> badge.secondary
            |> badge.text("Secondary")
            |> badge.build,
          badge.new() |> badge.accent |> badge.text("Accent") |> badge.build,
          badge.new() |> badge.neutral |> badge.text("Neutral") |> badge.build,
          badge.new() |> badge.info |> badge.text("Info") |> badge.build,
          badge.new() |> badge.success |> badge.text("Success") |> badge.build,
          badge.new() |> badge.warning |> badge.text("Warning") |> badge.build,
          badge.new() |> badge.error |> badge.text("Error") |> badge.build,
        ]),
        html.div([attribute.class("flex flex-wrap gap-2")], [
          badge.new()
            |> badge.primary
            |> badge.soft
            |> badge.text("Soft")
            |> badge.build,
          badge.new()
            |> badge.primary
            |> badge.outline
            |> badge.text("Outline")
            |> badge.build,
          badge.new()
            |> badge.primary
            |> badge.dash
            |> badge.text("Dash")
            |> badge.build,
          badge.new()
            |> badge.primary
            |> badge.ghost
            |> badge.text("Ghost")
            |> badge.build,
        ]),
        html.div([attribute.class("flex flex-wrap gap-2 items-center")], [
          badge.new()
            |> badge.primary
            |> badge.xs
            |> badge.text("xs")
            |> badge.build,
          badge.new()
            |> badge.primary
            |> badge.sm
            |> badge.text("sm")
            |> badge.build,
          badge.new()
            |> badge.primary
            |> badge.md
            |> badge.text("md")
            |> badge.build,
          badge.new()
            |> badge.primary
            |> badge.lg
            |> badge.text("lg")
            |> badge.build,
          badge.new()
            |> badge.primary
            |> badge.xl
            |> badge.text("xl")
            |> badge.build,
        ]),
      ]),
    ],
  )
}
