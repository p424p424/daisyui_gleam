import daisyui/progress
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
        html.text("Progress"),
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

fn bars(color_fn: fn(progress.Progress(msg)) -> progress.Progress(msg)) -> Element(msg) {
  html.div([attribute.class("flex flex-col gap-2")], [
    progress.new() |> color_fn |> progress.value(0)   |> progress.attrs([attribute.class("w-56")]) |> progress.build,
    progress.new() |> color_fn |> progress.value(10)  |> progress.attrs([attribute.class("w-56")]) |> progress.build,
    progress.new() |> color_fn |> progress.value(40)  |> progress.attrs([attribute.class("w-56")]) |> progress.build,
    progress.new() |> color_fn |> progress.value(70)  |> progress.attrs([attribute.class("w-56")]) |> progress.build,
    progress.new() |> color_fn |> progress.value(100) |> progress.attrs([attribute.class("w-56")]) |> progress.build,
  ])
}

fn main_content() -> Element(Msg) {
  html.main(
    [attribute.class("pt-20 pb-10 flex flex-col items-center min-h-screen gap-8")],
    [
      section("Default", [bars(fn(p) { p })]),
      section("Primary", [bars(progress.primary)]),
      section("Secondary", [bars(progress.secondary)]),
      section("Accent", [bars(progress.accent)]),
      section("Neutral", [bars(progress.neutral)]),
      section("Info", [bars(progress.info)]),
      section("Success", [bars(progress.success)]),
      section("Warning", [bars(progress.warning)]),
      section("Error", [bars(progress.error)]),
      section("Indeterminate (no value)", [
        progress.new()
        |> progress.attrs([attribute.class("w-56")])
        |> progress.build,
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
