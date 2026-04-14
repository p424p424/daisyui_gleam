import daisyui/radio
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
      html.h1([attribute.class("text-lg font-semibold")], [html.text("Radio")]),
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

fn color_pair(
  name: String,
  color_fn: fn(radio.Radio(msg)) -> radio.Radio(msg),
) -> Element(msg) {
  row([
    radio.new()
    |> color_fn
    |> radio.checked
    |> radio.attrs([attribute.name(name)])
    |> radio.build,
    radio.new()
    |> color_fn
    |> radio.attrs([attribute.name(name)])
    |> radio.build,
  ])
}

fn main_content() -> Element(Msg) {
  html.main(
    [attribute.class("pt-20 pb-10 flex flex-col items-center min-h-screen gap-8")],
    [
      section("Basic", [
        row([
          radio.new()
          |> radio.checked
          |> radio.attrs([attribute.name("radio-basic")])
          |> radio.build,
          radio.new()
          |> radio.attrs([attribute.name("radio-basic")])
          |> radio.build,
        ]),
      ]),
      section("Sizes", [
        row([
          radio.new() |> radio.xs |> radio.checked |> radio.attrs([attribute.name("radio-sizes")]) |> radio.build,
          radio.new() |> radio.sm |> radio.checked |> radio.attrs([attribute.name("radio-sizes")]) |> radio.build,
          radio.new() |> radio.md |> radio.checked |> radio.attrs([attribute.name("radio-sizes")]) |> radio.build,
          radio.new() |> radio.lg |> radio.checked |> radio.attrs([attribute.name("radio-sizes")]) |> radio.build,
          radio.new() |> radio.xl |> radio.checked |> radio.attrs([attribute.name("radio-sizes")]) |> radio.build,
        ]),
      ]),
      section("Colors", [
        html.div([attribute.class("flex flex-col gap-3")], [
          color_pair("radio-neutral", radio.neutral),
          color_pair("radio-primary", radio.primary),
          color_pair("radio-secondary", radio.secondary),
          color_pair("radio-accent", radio.accent),
          color_pair("radio-success", radio.success),
          color_pair("radio-warning", radio.warning),
          color_pair("radio-info", radio.info),
          color_pair("radio-error", radio.error),
        ]),
      ]),
      section("Disabled", [
        row([
          radio.new()
          |> radio.checked
          |> radio.disabled
          |> radio.attrs([attribute.name("radio-disabled")])
          |> radio.build,
          radio.new()
          |> radio.disabled
          |> radio.attrs([attribute.name("radio-disabled")])
          |> radio.build,
        ]),
      ]),
      section("Custom colors", [
        row([
          radio.new()
          |> radio.checked
          |> radio.attrs([
            attribute.name("radio-custom"),
            attribute.class(
              "bg-red-100 border-red-300 checked:bg-red-200 checked:text-red-600 checked:border-red-600",
            ),
          ])
          |> radio.build,
          radio.new()
          |> radio.checked
          |> radio.attrs([
            attribute.name("radio-custom"),
            attribute.class(
              "bg-blue-100 border-blue-300 checked:bg-blue-200 checked:text-blue-600 checked:border-blue-600",
            ),
          ])
          |> radio.build,
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
