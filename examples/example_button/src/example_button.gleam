import daisyui/button
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
      html.h1([attribute.class("text-lg font-semibold")], [
        html.text("Button"),
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
    [attribute.class("pt-16 flex items-center justify-center min-h-screen")],
    [
      html.div([attribute.class("p-8 space-y-4")], [
        html.div([attribute.class("flex flex-wrap gap-2")], [
          button.new()
            |> button.primary
            |> button.text("Primary")
            |> button.build,
          button.new()
            |> button.secondary
            |> button.text("Secondary")
            |> button.build,
          button.new()
            |> button.accent
            |> button.text("Accent")
            |> button.build,
          button.new()
            |> button.neutral
            |> button.text("Neutral")
            |> button.build,
          button.new() |> button.info |> button.text("Info") |> button.build,
          button.new()
            |> button.success
            |> button.text("Success")
            |> button.build,
          button.new()
            |> button.warning
            |> button.text("Warning")
            |> button.build,
          button.new() |> button.error |> button.text("Error") |> button.build,
        ]),
        html.div([attribute.class("flex flex-wrap gap-2")], [
          button.new()
            |> button.primary
            |> button.outline
            |> button.text("Outline")
            |> button.build,
          button.new()
            |> button.primary
            |> button.dash
            |> button.text("Dash")
            |> button.build,
          button.new()
            |> button.primary
            |> button.soft
            |> button.text("Soft")
            |> button.build,
          button.new() |> button.ghost |> button.text("Ghost") |> button.build,
          button.new() |> button.link |> button.text("Link") |> button.build,
        ]),
        html.div([attribute.class("flex flex-wrap gap-2 items-center")], [
          button.new()
            |> button.primary
            |> button.xs
            |> button.text("xs")
            |> button.build,
          button.new()
            |> button.primary
            |> button.sm
            |> button.text("sm")
            |> button.build,
          button.new()
            |> button.primary
            |> button.md
            |> button.text("md")
            |> button.build,
          button.new()
            |> button.primary
            |> button.lg
            |> button.text("lg")
            |> button.build,
          button.new()
            |> button.primary
            |> button.xl
            |> button.text("xl")
            |> button.build,
        ]),
        html.div([attribute.class("flex flex-wrap gap-2")], [
          button.new()
            |> button.primary
            |> button.disabled
            |> button.text("Disabled")
            |> button.build,
          button.new()
            |> button.primary
            |> button.wide
            |> button.text("Wide")
            |> button.build,
        ]),
      ]),
    ],
  )
}
