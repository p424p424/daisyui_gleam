import daisyui/select
import daisyui/status
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
        html.text("Status"),
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
  html.div([attribute.class("flex flex-wrap items-center gap-3")], children)
}

fn main_content() -> Element(Msg) {
  html.main(
    [attribute.class("pt-20 pb-10 flex flex-col items-center min-h-screen gap-8")],
    [
      section("Basic", [
        status.new() |> status.build,
      ]),
      section("Sizes", [
        row([
          status.new() |> status.xs |> status.build,
          status.new() |> status.sm |> status.build,
          status.new() |> status.md |> status.build,
          status.new() |> status.lg |> status.build,
          status.new() |> status.xl |> status.build,
        ]),
      ]),
      section("Colors", [
        row([
          status.new() |> status.primary |> status.label("primary") |> status.build,
          status.new() |> status.secondary |> status.label("secondary") |> status.build,
          status.new() |> status.accent |> status.label("accent") |> status.build,
          status.new() |> status.neutral |> status.label("neutral") |> status.build,
          status.new() |> status.info |> status.label("info") |> status.build,
          status.new() |> status.success |> status.label("success") |> status.build,
          status.new() |> status.warning |> status.label("warning") |> status.build,
          status.new() |> status.error |> status.label("error") |> status.build,
        ]),
      ]),
      section("Ping animation", [
        html.div([attribute.class("flex items-center gap-2")], [
          status.ping(status.new() |> status.error),
          html.span([], [html.text("Server is down")]),
        ]),
      ]),
      section("Bounce animation", [
        html.div([attribute.class("flex items-center gap-2")], [
          status.new() |> status.info |> status.animate_bounce |> status.build,
          html.span([], [html.text("Unread messages")]),
        ]),
      ]),
      section("In context (avatar-like badges)", [
        row([
          html.div([attribute.class("relative inline-block")], [
            html.div(
              [attribute.class("w-10 h-10 rounded-full bg-base-300")],
              [],
            ),
            html.div([attribute.class("absolute bottom-0 right-0")], [
              status.new() |> status.success |> status.sm |> status.build,
            ]),
          ]),
          html.div([attribute.class("relative inline-block")], [
            html.div(
              [attribute.class("w-10 h-10 rounded-full bg-base-300")],
              [],
            ),
            html.div([attribute.class("absolute bottom-0 right-0")], [
              status.ping(status.new() |> status.error |> status.sm),
            ]),
          ]),
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
