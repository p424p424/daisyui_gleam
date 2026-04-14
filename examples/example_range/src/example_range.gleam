import daisyui/range
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
      html.h1([attribute.class("text-lg font-semibold")], [html.text("Range")]),
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
      section("Basic", [
        range.new() |> range.value(40) |> range.build,
      ]),
      section("With steps and measure", [
        range.with_steps(
          range.new() |> range.value(25) |> range.step(25),
          ["|", "|", "|", "|", "|"],
          ["1", "2", "3", "4", "5"],
        ),
      ]),
      section("Colors", [
        html.div([attribute.class("flex flex-col gap-3")], [
          range.new() |> range.value(40) |> range.neutral |> range.build,
          range.new() |> range.value(40) |> range.primary |> range.build,
          range.new() |> range.value(40) |> range.secondary |> range.build,
          range.new() |> range.value(40) |> range.accent |> range.build,
          range.new() |> range.value(40) |> range.success |> range.build,
          range.new() |> range.value(40) |> range.warning |> range.build,
          range.new() |> range.value(40) |> range.info |> range.build,
          range.new() |> range.value(40) |> range.error |> range.build,
        ]),
      ]),
      section("Sizes", [
        html.div([attribute.class("flex flex-col gap-3")], [
          range.new() |> range.value(30) |> range.xs |> range.build,
          range.new() |> range.value(40) |> range.sm |> range.build,
          range.new() |> range.value(50) |> range.md |> range.build,
          range.new() |> range.value(60) |> range.lg |> range.build,
          range.new() |> range.value(70) |> range.xl |> range.build,
        ]),
      ]),
      section("Custom color and no fill", [
        range.new()
        |> range.value(40)
        |> range.attrs([
          attribute.class(
            "text-blue-300 [--range-bg:orange] [--range-thumb:blue] [--range-fill:0]",
          ),
        ])
        |> range.build,
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
