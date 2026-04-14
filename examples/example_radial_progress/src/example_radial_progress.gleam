import daisyui/radial_progress
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
        html.text("Radial Progress"),
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

fn row(children: List(Element(msg))) -> Element(msg) {
  html.div([attribute.class("flex flex-wrap gap-4 items-center")], children)
}

fn main_content() -> Element(Msg) {
  html.main(
    [attribute.class("pt-20 pb-10 flex flex-col items-center min-h-screen gap-8")],
    [
      section("Different values", [
        row([
          radial_progress.new(0) |> radial_progress.build,
          radial_progress.new(20) |> radial_progress.build,
          radial_progress.new(60) |> radial_progress.build,
          radial_progress.new(80) |> radial_progress.build,
          radial_progress.new(100) |> radial_progress.build,
        ]),
      ]),
      section("Custom color", [
        row([
          radial_progress.new(70) |> radial_progress.color("text-primary") |> radial_progress.build,
          radial_progress.new(70) |> radial_progress.color("text-secondary") |> radial_progress.build,
          radial_progress.new(70) |> radial_progress.color("text-accent") |> radial_progress.build,
          radial_progress.new(70) |> radial_progress.color("text-success") |> radial_progress.build,
          radial_progress.new(70) |> radial_progress.color("text-error") |> radial_progress.build,
        ]),
      ]),
      section("With background color and border", [
        row([
          radial_progress.new(70)
          |> radial_progress.classes(
            "bg-primary text-primary-content border-primary border-4",
          )
          |> radial_progress.build,
          radial_progress.new(70)
          |> radial_progress.classes(
            "bg-secondary text-secondary-content border-secondary border-4",
          )
          |> radial_progress.build,
          radial_progress.new(70)
          |> radial_progress.classes(
            "bg-accent text-accent-content border-accent border-4",
          )
          |> radial_progress.build,
        ]),
      ]),
      section("Custom size and thickness", [
        row([
          radial_progress.new(70)
          |> radial_progress.size("12rem")
          |> radial_progress.thickness("2px")
          |> radial_progress.build,
          radial_progress.new(70)
          |> radial_progress.size("12rem")
          |> radial_progress.thickness("2rem")
          |> radial_progress.build,
        ]),
      ]),
      section("Custom label", [
        row([
          radial_progress.new(33)
          |> radial_progress.label("1/3")
          |> radial_progress.build,
          radial_progress.new(75)
          |> radial_progress.label("3/4")
          |> radial_progress.build,
        ]),
      ]),
    ],
  )
}

fn section(label: String, children: List(Element(Msg))) -> Element(Msg) {
  html.div([attribute.class("w-full max-w-3xl space-y-3 px-4")], [
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
