import daisyui/select
import daisyui/text
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
      html.h1([attribute.class("text-lg font-semibold")], [html.text("Text")]),
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
      html.div([attribute.class("max-w-lg space-y-4 p-8")], [
        text.new()
          |> text.h1()
          |> text.xl4()
          |> text.bold()
          |> text.primary()
          |> text.text("Heading 1")
          |> text.build(),
        text.new()
          |> text.h2()
          |> text.xl3()
          |> text.semibold()
          |> text.secondary()
          |> text.text("Heading 2")
          |> text.build(),
        text.new()
          |> text.h3()
          |> text.xl2()
          |> text.semibold()
          |> text.accent()
          |> text.text("Heading 3")
          |> text.build(),
        text.new()
          |> text.p()
          |> text.base_content()
          |> text.text("Regular paragraph text in base content colour.")
          |> text.build(),
        text.new()
          |> text.p()
          |> text.info()
          |> text.text("Info coloured paragraph text.")
          |> text.build(),
        text.new()
          |> text.p()
          |> text.success()
          |> text.text("Success coloured paragraph text.")
          |> text.build(),
        text.new()
          |> text.p()
          |> text.warning()
          |> text.text("Warning coloured paragraph text.")
          |> text.build(),
        text.new()
          |> text.p()
          |> text.error()
          |> text.text("Error coloured paragraph text.")
          |> text.build(),
        html.div([attribute.class("flex flex-wrap gap-2 items-baseline")], [
          text.new() |> text.span() |> text.xs() |> text.text("xs") |> text.build(),
          text.new() |> text.span() |> text.sm() |> text.text("sm") |> text.build(),
          text.new()
            |> text.span()
            |> text.base()
            |> text.text("base")
            |> text.build(),
          text.new() |> text.span() |> text.lg() |> text.text("lg") |> text.build(),
          text.new() |> text.span() |> text.xl() |> text.text("xl") |> text.build(),
          text.new()
            |> text.span()
            |> text.xl2()
            |> text.text("2xl")
            |> text.build(),
          text.new()
            |> text.span()
            |> text.xl3()
            |> text.text("3xl")
            |> text.build(),
        ]),
      ]),
    ],
  )
}
