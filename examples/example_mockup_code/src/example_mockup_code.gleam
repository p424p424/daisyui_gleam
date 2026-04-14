import daisyui/mockup_code
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
      html.h1([attribute.class("text-lg font-semibold")], [
        html.text("Code Mockup"),
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
    [attribute.class("pt-20 pb-10 flex flex-col items-center min-h-screen gap-8")],
    [
      section("Single line with prefix", [
        mockup_code.new()
        |> mockup_code.attrs([attribute.class("w-full")])
        |> mockup_code.lines([
          mockup_code.line("npm i daisyui") |> mockup_code.prefix("$"),
        ])
        |> mockup_code.build,
      ]),
      section("Multi-line", [
        mockup_code.new()
        |> mockup_code.attrs([attribute.class("w-full")])
        |> mockup_code.lines([
          mockup_code.line("npm i daisyui") |> mockup_code.prefix("$"),
          mockup_code.line("installing...")
            |> mockup_code.prefix(">")
            |> mockup_code.line_class("text-warning"),
          mockup_code.line("Done!")
            |> mockup_code.prefix(">")
            |> mockup_code.line_class("text-success"),
        ])
        |> mockup_code.build,
      ]),
      section("Highlighted line", [
        mockup_code.new()
        |> mockup_code.attrs([attribute.class("w-full")])
        |> mockup_code.lines([
          mockup_code.line("npm i daisyui") |> mockup_code.prefix("1"),
          mockup_code.line("installing...") |> mockup_code.prefix("2"),
          mockup_code.line("Error!")
            |> mockup_code.prefix("3")
            |> mockup_code.line_class("bg-warning text-warning-content"),
        ])
        |> mockup_code.build,
      ]),
      section("Long line scrolls", [
        mockup_code.new()
        |> mockup_code.attrs([attribute.class("w-full")])
        |> mockup_code.lines([
          mockup_code.line(
            "Magnam dolore beatae necessitatibus nemo ipsum itaque sit. Et porro quae qui et et dolore ratione.",
          )
          |> mockup_code.prefix("~"),
        ])
        |> mockup_code.build,
      ]),
      section("Without prefix", [
        mockup_code.new()
        |> mockup_code.attrs([attribute.class("w-full")])
        |> mockup_code.lines([mockup_code.line("without prefix")])
        |> mockup_code.build,
      ]),
      section("With color", [
        mockup_code.new()
        |> mockup_code.color("bg-primary text-primary-content")
        |> mockup_code.attrs([attribute.class("w-full")])
        |> mockup_code.lines([mockup_code.line("can be any color!")])
        |> mockup_code.build,
      ]),
    ],
  )
}

fn section(label: String, children: List(Element(Msg))) -> Element(Msg) {
  html.div([attribute.class("w-full max-w-2xl space-y-3 px-4")], [
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
