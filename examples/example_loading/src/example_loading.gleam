import daisyui/loading
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
        html.text("Loading"),
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

fn sizes(style_fn: fn(loading.Loading(msg)) -> loading.Loading(msg)) -> Element(msg) {
  html.div([attribute.class("flex items-center gap-4")], [
    loading.new() |> style_fn |> loading.xs |> loading.build,
    loading.new() |> style_fn |> loading.sm |> loading.build,
    loading.new() |> style_fn |> loading.md |> loading.build,
    loading.new() |> style_fn |> loading.lg |> loading.build,
    loading.new() |> style_fn |> loading.xl |> loading.build,
  ])
}

fn main_content() -> Element(Msg) {
  html.main(
    [attribute.class("pt-20 pb-10 flex flex-col items-center min-h-screen gap-8")],
    [
      section("Spinner", [sizes(loading.spinner)]),
      section("Dots", [sizes(loading.dots)]),
      section("Ring", [sizes(loading.ring)]),
      section("Ball", [sizes(loading.ball)]),
      section("Bars", [sizes(loading.bars)]),
      section("Infinity", [sizes(loading.infinity)]),
      section("Colors (spinner)", [
        html.div([attribute.class("flex flex-wrap items-center gap-4")], [
          loading.new() |> loading.spinner |> loading.primary |> loading.build,
          loading.new() |> loading.spinner |> loading.secondary |> loading.build,
          loading.new() |> loading.spinner |> loading.accent |> loading.build,
          loading.new() |> loading.spinner |> loading.neutral |> loading.build,
          loading.new() |> loading.spinner |> loading.info |> loading.build,
          loading.new() |> loading.spinner |> loading.success |> loading.build,
          loading.new() |> loading.spinner |> loading.warning |> loading.build,
          loading.new() |> loading.spinner |> loading.error |> loading.build,
        ]),
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
